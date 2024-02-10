import 'package:chatkuy/models/message_model.dart';
import 'package:chatkuy/provider/firebase_provider.dart';
import 'package:chatkuy/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatDisplay extends StatelessWidget {
  final ScrollController controller;
  final String uid;
  const ChatDisplay({
    super.key,
    required this.controller,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<FirebaseProvider>(
        builder: (context, value, child) {
          if (value.messages.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 8.h),
              controller: controller,
              reverse: true,
              itemCount: value.messages.length,
              itemBuilder: (context, index) {
                int reversedIndex = value.messages.length - 1 - index;

                final isTextMessage =
                    value.messages[reversedIndex].messageType ==
                        MessageType.text;

                final isMe = uid !=
                    value.messages[reversedIndex].senderId;

                return isTextMessage
                    ? MessageTile(
                        isImage: false,
                        isMe: isMe,
                        message: value.messages[reversedIndex],
                      )
                    : MessageTile(
                        isImage: true,
                        isMe: isMe,
                        message: value.messages[reversedIndex],
                      );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
