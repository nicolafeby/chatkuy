import 'dart:async';

import 'package:chatkuy/presentation/chat/widget/chat_input_text.dart';
import 'package:chatkuy/presentation/group_info/page/group_info_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/database_service.dart';
import 'package:chatkuy/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatArgument {
  const ChatArgument({
    required this.groupId,
    required this.groupName,
    required this.userName,
  });

  final String groupId;
  final String groupName;
  final String userName;
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.argument}) : super(key: key);

  final ChatArgument argument;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  final ScrollController _controller = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isDisabledButtonSend = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getChatandAdmin();
  }

  getChatandAdmin() {
    DatabaseService().getChats(grubId: widget.argument.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService()
        .getGruopAdmin(groupId: widget.argument.groupId)
        .then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text.trim(),
        "sender": widget.argument.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(
          chatMessagesData: chatMessageMap, groupId: widget.argument.groupId);
      setState(() {
        messageController.clear();
      });
      _isDisabledButtonSend = true;
    }
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: StreamBuilder(
            stream: chats,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.only(top: 8.h),
                  controller: _controller,
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    int reversedIndex = snapshot.data.docs.length - 1 - index;
                    int checkBefore = 0;
                    if (reversedIndex != 0) {
                      checkBefore = 1;
                    }

                    return MessageTile(
                        message: snapshot.data.docs[reversedIndex]['message'],
                        sender: snapshot.data.docs[reversedIndex]['sender'],
                        sentByMe: widget.argument.userName ==
                            snapshot.data.docs[reversedIndex]['sender'],
                        checkMessageBefore: snapshot.data
                                .docs[reversedIndex - checkBefore]['sender'] ==
                            snapshot.data.docs[reversedIndex]['sender']);
                  },
                );
              } else {
                return Container();
              }
            },
          ),
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
                  () =>
                      _controller.jumpTo(_controller.position.maxScrollExtent),
                );
              }
            });
          },
          sendMessage: sendMessage,
          messageController: messageController,
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(widget.argument.groupName),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              RouterConstant.groupInfoPage,
              arguments: GroupInfoArgument(
                adminName: admin,
                groupId: widget.argument.groupId,
                groupName: widget.argument.groupName,
              ),
            );
          },
          icon: const Icon(Icons.info),
        )
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
