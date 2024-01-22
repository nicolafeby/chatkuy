import 'dart:async';

import 'package:chatkuy/presentation/chat/widget/chat_input_text.dart';
import 'package:chatkuy/presentation/group_info/group_info_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/database_service.dart';
import 'package:chatkuy/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatArgument {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatArgument({
    required this.groupId,
    required this.groupName,
    required this.userName,
  });
}

class ChatPage extends StatefulWidget {
  final ChatArgument argument;
  const ChatPage({Key? key, required this.argument}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final FocusNode _focusNode = FocusNode();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
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
                  controller: _controller,
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    int reversedIndex = snapshot.data.docs.length - 1 - index;
                    return MessageTile(
                        message: snapshot.data.docs[reversedIndex]['message'],
                        sender: snapshot.data.docs[reversedIndex]['sender'],
                        sentByMe: widget.argument.userName ==
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
          focusNode: _focusNode,
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

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.argument.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(
          chatMessagesData: chatMessageMap, groupId: widget.argument.groupId);
      setState(() {
        messageController.clear();
      });
    }
  }
}
