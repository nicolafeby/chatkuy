import 'dart:developer';
import 'dart:io';

import 'package:chatkuy/helper/helper.dart';
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
  });

  final String email;
  final String fullName;
  final String profileImage;
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
  String? newImage;
  String newName = '';
  bool isChangedPhoto = false;

  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.argument.fullName);
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
          ? Icon(
              Icons.camera_enhance,
              color: Colors.white,
              size: 24.r,
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

  Widget _buildEditFullname(BuildContext context) {
    return TextFormField(
      controller: _controller,
      textInputAction: TextInputAction.next,
      decoration: textInputDecoration.copyWith(
          labelText: "Full Name",
          prefixIcon: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          )),
      onChanged: (val) async {
        newName = val;
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
        fullname: newName,
        profilePicture: image?.path ?? '',
      )
          .whenComplete(() async {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(widget.argument.email);
        // saving the values to our shared preferences

        await Helper.saveUsernameSF(snapshot.docs[0]['fullName']);
        await Helper.saveProfilePictureSF(snapshot.docs[0]['profilePic']);
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
      onPressed: (_controller.text == widget.argument.fullName &&
              !isChangedPhoto == true)
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
