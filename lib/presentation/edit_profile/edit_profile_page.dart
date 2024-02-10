import 'dart:developer';
import 'dart:io';

import 'package:chatkuy/helper/sf_helper.dart';
import 'package:chatkuy/mixin/app_mixin.dart';
import 'package:chatkuy/presentation/base/base_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/database_service.dart';
import 'package:chatkuy/widgets/custom_button_widget.dart';
import 'package:chatkuy/widgets/text_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

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
  final formKey = GlobalKey<FormState>();
  File? image;
  bool isChangedPhoto = false;
  bool? isUsernameAvailable;
  String? newImage;
  String? newName;
  String? userName;

  late TextEditingController _fullNameController;
  late TextEditingController _userNameController;
  bool _isLoading = false;

  @override
  void initState() {
    _fullNameController = TextEditingController(text: widget.argument.fullName);
    _userNameController = TextEditingController(text: widget.argument.userName);
    super.initState();
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        isChangedPhoto = true;
      });
      log('ini dari galeri: ${image.path}');
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
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
      child: widget.argument.profileImage.isEmpty == true
          ? Container(
              height: 120.r,
              width: 120.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black38,
              ),
              child: Icon(
                Icons.camera_enhance,
                color: Colors.black,
                size: 24.r,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Image.file(
                image ?? File(widget.argument.profileImage),
                height: 100.r,
                width: 100.r,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Future<bool> _checkUsername(String userName) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await userCollection.where('username', isEqualTo: userName).get();
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

  void _updateData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .editUserData(
        fullname: newName ?? widget.argument.fullName,
        profilePicture: image?.path ?? widget.argument.profileImage,
        userName: userName ?? widget.argument.userName,
      )
          .whenComplete(() async {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(widget.argument.email);
        // saving the values to our shared preferences
        await SfHelper.saveFullNameSF(snapshot.docs[0]['fullName']);
        await SfHelper.saveUsernameSF(snapshot.docs[0]['username']);
        await SfHelper.saveProfilePictureSF(snapshot.docs[0]['profilePic']);
      });

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
