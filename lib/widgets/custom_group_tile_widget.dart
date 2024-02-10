import 'package:chatkuy/presentation/chat/page/chat_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  final String fullName;
  final String groupId;
  final String groupName;
  const GroupTile({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.fullName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   RouterConstant.chatPage,
        //   arguments: ChatArgument(
        //     groupId: groupId,
        //     groupName: groupName,
        //     fullName: fullName,
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as $fullName",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
