import 'dart:developer';
import 'package:chatkuy/mixin/app_mixin.dart';
import 'package:chatkuy/presentation/base/base_page.dart';
import 'package:chatkuy/provider/firebase_provider.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/media_service.dart';
import 'package:chatkuy/widgets/cached_network_image.dart';
import 'package:chatkuy/widgets/custom_button_widget.dart';
import 'package:chatkuy/widgets/text_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditProfileArgument {
  const EditProfileArgument({
    required this.fullName,
    required this.email,
    required this.profileImage,
    required this.userName,
  });

  final String email;
  final String fullName;
  final String profileImage;
  final String userName;
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.argument});

  final EditProfileArgument argument;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with AppMixin {
  Uint8List? file;

  final formKey = GlobalKey<FormState>();
  bool isChangedPhoto = false;
  bool? isUsernameAvailable;
  String? newImage;
  String? newName;
  String? userName;

  late TextEditingController _fullNameController;
  bool _isLoading = false;
  late TextEditingController _userNameController;

  @override
  void initState() {
    _fullNameController = TextEditingController(text: widget.argument.fullName);
    _userNameController = TextEditingController(text: widget.argument.userName);
    super.initState();
  }

  Future _pickImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() {
      isChangedPhoto = true;
      file = pickedImage!;
    });
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text('Edit Profile'),
    );
  }

  Widget _buildBody(BuildContext context) {
    return _isLoading == true
        ? Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPhotoProfile(context),
                    SizedBox(height: 24.h),
                    _buildEditFullname(context),
                    SizedBox(height: 8.h),
                    _buildUsername(),
                    SizedBox(height: 42.h),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildPhotoProfile(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(),
      child: isChangedPhoto
          ? CircleAvatar(
              radius: 60.r,
              backgroundImage: MemoryImage(file!),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(500.r),
              child: CustomCachedNetworkImage(
                height: 120.r,
                width: 120.r,
                imageUrl: widget.argument.profileImage,
              ),
            ),
    );
  }

  Future<bool> _checkUsername(String userName) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await userCollection.where('userName', isEqualTo: userName).get();
    return querySnapshot.docs.isEmpty;
  }

  Widget _buildUsername() {
    return TextFormField(
      controller: _userNameController,
      textInputAction: TextInputAction.next,
      decoration: textInputDecoration.copyWith(
          labelText: "Username",
          prefixIcon: Icon(
            Icons.note,
            color: Theme.of(context).primaryColor,
          )),
      onChanged: (val) {
        setState(() {
          userName = val.trim();
          log(userName.toString());
          (_fullNameController.text.trim() == widget.argument.fullName &&
                  !isChangedPhoto == true)
              ? _checkUsername(userName!).then((value) {
                  isUsernameAvailable = value;
                  log('Username is available: $isUsernameAvailable');
                })
              : null;
        });
      },
      validator: (val) {
        if (isUsernameAvailable == false) {
          return "Username sudah dipakai";
        } else if (val!.isNotEmpty) {
          return null;
        } else {
          return "Name cannot be empty";
        }
      },
    );
  }

  Widget _buildEditFullname(BuildContext context) {
    return TextFormField(
      controller: _fullNameController,
      textInputAction: TextInputAction.next,
      decoration: textInputDecoration.copyWith(
          labelText: "Full Name",
          prefixIcon: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          )),
      onChanged: (val) async {
        newName = val.trim();
        setState(() {});
      },
      validator: (val) {
        if (val!.isNotEmpty) {
          return null;
        } else {
          return "Name cannot be empty";
        }
      },
    );
  }

  Future<Uint8List> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Uint8List.fromList(response.bodyBytes);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _updateData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<FirebaseProvider>(context, listen: false).editProfile(
        username: userName ?? widget.argument.userName,
        name: newName ?? widget.argument.fullName,
        profilePicture: file ?? await fetchData(widget.argument.profileImage),
      );
      // .whenComplete(() => navigatorKey.currentState?.pop());

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouterConstant.basePage,
          (route) => false,
          arguments: const BasePageArg(route: BasePageRoute.profile),
        );
        showAppSnackbar(
          context,
          Colors.green,
          'Berhasil mengubah profile',
        );
      }
    }
  }

  Widget _buildSaveButton() {
    return CustomButtonWidget(
      text: 'Simpan',
      onPressed: (_fullNameController.text.trim() == widget.argument.fullName &&
              !isChangedPhoto == true &&
              _userNameController.text.trim() == widget.argument.userName)
          ? null
          : _updateData,
    );
  }

  @override
  Widget build(BuildContext context) {
    log(widget.argument.profileImage.toString());
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }
}
