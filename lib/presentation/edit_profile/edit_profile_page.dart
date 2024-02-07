import 'dart:io';

import 'package:chatkuy/helper/helper.dart';
import 'package:chatkuy/mixin/app_mixin.dart';
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
  String newImage = '';
  String newName = '';

  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.argument.fullName);
    newImage = widget.argument.profileImage;
    super.initState();
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
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
      child: Container(
        height: 100.r,
        width: 100.r,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.camera_enhance,
          color: Colors.white,
          size: 24.r,
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
          RouterConstant.homePage,
          (route) => false,
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
      onPressed: (_controller.text == widget.argument.fullName ||
              newImage == image?.path)
          ? null
          : _updateData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }
}
