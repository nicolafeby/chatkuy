import 'dart:typed_data';
import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/service/firestore_service.dart';
import 'package:chatkuy/service/media_service.dart';
import 'package:chatkuy/service/notif_service.dart';
import 'package:chatkuy/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();
  final notificationsService = NotificationsService();

  Uint8List? file;

  @override
  void initState() {
    notificationsService.getReceiverToken(widget.receiverId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: controller,
              hintText: 'Add Message...',
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: AppColor.primaryColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendText(context),
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: AppColor.primaryColor,
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _sendImage,
            ),
          ),
        ],
      );

  Future<void> _sendText(BuildContext context) async {
    var focusScope = FocusScope.of(context);
    if (controller.text.isNotEmpty) {
      await FirebaseFirestoreService.addTextMessage(
        receiverId: widget.receiverId,
        content: controller.text,
      );
      // await notificationsService.sendNotification(
      //   body: controller.text,
      //   senderId: FirebaseAuth.instance.currentUser!.uid,
      // );
      controller.clear();
      focusScope.unfocus();
    }
    focusScope.unfocus();
  }

  Future<void> _sendImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirebaseFirestoreService.addImageMessage(
        receiverId: widget.receiverId,
        file: file!,
      );
      // await notificationsService.sendNotification(
      //   body: 'image........',
      //   senderId: FirebaseAuth.instance.currentUser!.uid,
      // );
    }
  }
}
