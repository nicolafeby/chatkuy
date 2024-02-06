import 'dart:io';

import 'package:chatkuy/widgets/custom_button_widget.dart';
import 'package:chatkuy/widgets/text_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileArgument {
  const EditProfileArgument({required this.fullName});

  final String fullName;
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.argument});

  final EditProfileArgument argument;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? image;

  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.argument.fullName);
    super.initState();
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
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
      onChanged: (val) {
        setState(() {
          // fullName = val;
        });
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

  Widget _buildSaveButton() {
    return CustomButtonWidget(
      text: 'Simpan',
      onPressed: _controller.text == widget.argument.fullName ? null : () {},
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
