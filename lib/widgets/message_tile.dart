import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final bool checkMessageBefore;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.checkMessageBefore,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 2,
        left: widget.sentByMe ? 0 : 24,
        right: widget.sentByMe ? 24 : 0,
      ),
      child: Column(
        crossAxisAlignment:
            widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !widget.checkMessageBefore,
            child: _buildDisplayName(),
          ),
          _buildDIsplayChat(),
        ],
      ),
    );
  }

  Widget _buildDisplayName() {
    return Column(
      children: [
        SizedBox(height: 4.h),
        Text(
          widget.sender.toUpperCase(),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: widget.sentByMe
                ? Theme.of(context).primaryColor
                : Colors.grey[700],
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDIsplayChat() {
    return Container(
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
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
            color: widget.sentByMe
                ? Theme.of(context).primaryColor
                : Colors.grey[700]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
