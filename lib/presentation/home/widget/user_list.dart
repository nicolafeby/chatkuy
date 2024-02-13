import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/main.dart';
import 'package:chatkuy/models/user_model.dart';
import 'package:chatkuy/presentation/chat/page/chat_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_preview/image_preview.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState?.pushNamed(
          RouterConstant.chatPage,
          arguments: ChatArgument(uid: user.uid),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // CircleAvatar(
            //   radius: 30,
            //   backgroundImage: NetworkImage(user.image),
            // ),
            _buildImageMessage(context),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                backgroundColor: user.isOnline ? Colors.green : Colors.grey,
                radius: 5,
              ),
            ),
          ],
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Last Active : ${timeago.format(user.lastActive)}',
          maxLines: 2,
          style: const TextStyle(
            color: AppColor.primaryColor,
            fontSize: 15,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(80.r),
      child: Hero(
        tag: user.image,
        child: GestureDetector(
          onTap: () {
            openImagePage(Navigator.of(context), imgUrl: user.image);
          },
          child: CustomCachedNetworkImage(
            height: 50.r,
            width: 50.r,
            imageUrl: user.image,
          ),
        ),
      ),
    );
  }
}
