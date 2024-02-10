import 'package:chatkuy/presentation/home/widget/user_list.dart';
import 'package:chatkuy/provider/firebase_provider.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/firestore_service.dart';
import 'package:chatkuy/service/notif_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final notificationService = NotificationsService();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': true,
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        FirebaseFirestoreService.updateUserData({'isOnline': false});
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
    notificationService.firebaseNotification(context);
  }

  Widget _buildChatList() {
    return Consumer<FirebaseProvider>(
      builder: (context, value, child) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: value.users.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return value.users[index].uid !=
                    FirebaseAuth.instance.currentUser?.uid
                ? UserItem(user: value.users[index])
                : const SizedBox();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouterConstant.searchPage),
              icon: const Icon(
                Icons.search,
              ))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Chat"),
      ),
      body: _buildChatList(),
    );
  }
}
