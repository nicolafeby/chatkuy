import 'package:chatkuy/models/message_model.dart';
import 'package:chatkuy/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_preview/image_preview.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  // final bool checkMessageBefore;
  // final String messageTime;
  final bool isMe;
  final bool isImage;
  final Message message;

  const MessageTile({
    Key? key,
    required this.isMe,
    required this.isImage,
    required this.message,
    // required this.checkMessageBefore,
    // required this.messageTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 2,
        left: isMe ? 0 : 24,
        right: isMe ? 24 : 0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: false, // checkMessageBefore,
            child: SizedBox(height: 8.h), // _buildDisplayName(context),
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
          message.senderId.toUpperCase(),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isMe ? Theme.of(context).primaryColor : Colors.grey[700],
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayChat(BuildContext context) {
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        decoration: BoxDecoration(
            borderRadius: isMe
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
            color: isMe ? Theme.of(context).primaryColor : Colors.grey[700]),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                isMe
                    ? message.content.length <= 30
                        ? _buildTime(context)
                        : const SizedBox()
                    : const SizedBox(),
                Flexible(
                  child: isImage
                      ? _buildImageMessage(context)
                      : Text(message.content,
                          style: const TextStyle(color: Colors.white)),
                ),
                !isMe
                    ? message.content.length <= 30
                        ? _buildTime(context)
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ),
            message.content.length >= 30
                ? _buildTime(context)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildTime(BuildContext context) {
    String formattedTime = DateFormat.Hm().format(message.sentTime);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: isMe ? 0 : 4.w),
        Text(
          formattedTime, //DateHelper.getTime(message.sentTime.toString(), false),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isMe ? Colors.black54 : Colors.white60,
              ),
        ),
        SizedBox(width: !isMe ? 0 : 4.w),
      ],
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Hero(
        tag: message.content,
        child: GestureDetector(
          onTap: () {
            openImagePage(Navigator.of(context), imgUrl: message.content);
          },
          child: CustomCachedNetworkImage(
            height: 180.r,
            width: 180.r,
            imageUrl: message.content,
          ),
        ),
      ),
    );
  }
}
