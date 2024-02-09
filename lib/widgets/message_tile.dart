import 'package:chatkuy/helper/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final bool checkMessageBefore;
  final String messageTime;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.checkMessageBefore,
    required this.messageTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 2,
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0,
      ),
      child: Column(
        crossAxisAlignment:
            sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !checkMessageBefore,
            child: _buildDisplayName(context),
          ),
          _buildDisplayChat(context),
        ],
      ),
    );
  }

  Widget _buildDisplayName(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4.h),
        Text(
          sender.toUpperCase(),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: sentByMe ? Theme.of(context).primaryColor : Colors.grey[700],
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayChat(BuildContext context) {
    return Container(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        decoration: BoxDecoration(
            borderRadius: sentByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
            color:
                sentByMe ? Theme.of(context).primaryColor : Colors.grey[700]),
        child: Column(
          crossAxisAlignment:
              sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                sentByMe
                    ? message.length <= 30
                        ? _buildTime(context)
                        : const SizedBox()
                    : const SizedBox(),
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                !sentByMe
                    ? message.length <= 30
                        ? _buildTime(context)
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ),
            message.length >= 30 ? _buildTime(context) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildTime(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: sentByMe ? 0 : 4.w),
        Text(
          DateHelper.getTime(messageTime),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: sentByMe ? Colors.black54 : Colors.white60,
              ),
        ),
        SizedBox(width: !sentByMe ? 0 : 4.w),
      ],
    );
  }
}
