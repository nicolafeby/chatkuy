import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputText extends StatelessWidget {
  final FocusNode focusNode;
  final Function() onTap;
  final Function() sendMessage;
  final TextEditingController messageController;
  final bool? isDisable;
  final Function(String)? onChanged;
  const ChatInputText({
    super.key,
    required this.focusNode,
    required this.onTap,
    required this.sendMessage,
    required this.messageController,
    this.isDisable = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: Colors.grey[700],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                maxLines: 3,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                focusNode: focusNode,
                onTap: onTap,
                onChanged: onChanged,
                controller: messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Send a message...",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 16),
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
                  color: isDisable!
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Icon(
                    Icons.send,
                    color: isDisable!
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
