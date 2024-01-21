import 'dart:async';

import 'package:chatkuy/presentation/group_info/group_info_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/database_service.dart';
import 'package:chatkuy/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  double gapHeight = 58;

  @override
  void initState() {
    getChatandAdmin();
    _focusNode.addListener(isActive);
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
        appBar: AppBar(
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
                icon: const Icon(Icons.info))
          ],
        ),
        body: Stack(
          children: <Widget>[
            // chat messages here
            chatMessages(),
            Container(
              padding: EdgeInsets.all(16.r),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: Colors.grey[700],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 2,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        focusNode: _focusNode,
                        onTap: () {
                          setState(() {
                            if (messageController.text.isNotEmpty) {
                              Timer(
                                const Duration(milliseconds: 300),
                                () => _controller.jumpTo(
                                    _controller.position.maxScrollExtent),
                              );
                            }
                          });
                        },
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Send a message...",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: sendMessage,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void isActive() {
    if (_focusNode.hasFocus) {
      gapHeight = 78;
      setState(() {
        if (messageController.text.isNotEmpty) {
          Timer(
            const Duration(milliseconds: 300),
            () => _controller.jumpTo(_controller.position.minScrollExtent),
          );
        }
      });
    } else {
      gapHeight = 58;
      setState(() {
        if (messageController.text.isNotEmpty) {
          Timer(
            const Duration(milliseconds: 300),
            () => _controller.jumpTo(_controller.position.minScrollExtent),
          );
        }
      });
    }
  }

  chatMessages() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: chats,
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      controller: _controller,
                      reverse: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        int reversedIndex =
                            snapshot.data.docs.length - 1 - index;
                        return MessageTile(
                            message: snapshot.data.docs[reversedIndex]
                                ['message'],
                            sender: snapshot.data.docs[reversedIndex]['sender'],
                            sentByMe: widget.argument.userName ==
                                snapshot.data.docs[reversedIndex]['sender']);
                      },
                    )
                  : Container();
            },
          ),
        ),
        SizedBox(height: gapHeight.h),
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
