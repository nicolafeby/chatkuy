import 'dart:async';
import 'package:chatkuy/presentation/chat/widget/chat_display.dart';
import 'package:chatkuy/presentation/chat/widget/chat_input_text.dart';
import 'package:chatkuy/provider/firebase_provider.dart';
import 'package:chatkuy/service/firestore_service.dart';
import 'package:chatkuy/service/media_service.dart';
import 'package:chatkuy/service/notif_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatArgument {
  const ChatArgument({
    required this.uid,
  });

  final String uid;
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.argument}) : super(key: key);

  final ChatArgument argument;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  final notificationsService = NotificationsService();

  final FocusNode _focusNode = FocusNode();
  bool _isDisabledButtonSend = true;
  final _scrollController = ScrollController();
  String? senderName;

  Uint8List? file;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    notificationsService.getReceiverToken(widget.argument.uid);
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.argument.uid)
      ..getMessages(widget.argument.uid);
    super.initState();
  }

  Future<void> _sendText() async {
    // var focusScope = FocusScope.of(context);
    if (messageController.text.isNotEmpty) {
      FirebaseFirestoreService.addTextMessage(
        receiverId: widget.argument.uid,
        content: messageController.text.trim(),
      );

      notificationsService.sendNotification(
        body: messageController.text.trim(),
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderName: senderName ?? 'New Message!!',
      );
      messageController.clear();
      _isDisabledButtonSend = true;
      setState(() {});
    }
  }

  Future<void> _sendImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirebaseFirestoreService.addImageMessage(
        receiverId: widget.argument.uid,
        file: file!,
      );
      await notificationsService.sendNotification(
        body: 'Gambar diterima',
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderName: senderName ?? 'New Message!!',
      );
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      title: Consumer<FirebaseProvider>(
        builder: (context, value, child) {
          senderName = value.user?.name;
          return value.user != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(value.user!.image),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value.user!.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                  ),
                        ),
                        Text(
                          value.user!.isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: value.user!.isOnline
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox();
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ChatDisplay(
          controller: _scrollController,
          uid: widget.argument.uid,
        ),
        ChatInputText(
          isDisable: _isDisabledButtonSend,
          focusNode: _focusNode,
          onChanged: (value) {
            setState(() {});
            _isDisabledButtonSend = value.trim().isEmpty;
          },
          onTap: () {
            setState(() {
              if (messageController.text.isNotEmpty) {
                Timer(
                  const Duration(milliseconds: 300),
                  () => _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent),
                );
              }
            });
          },
          sendMessage: _sendText,
          messageController: messageController,
          onTapCamera: _sendImage,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }
}
