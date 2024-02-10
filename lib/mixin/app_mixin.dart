import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:flutter/material.dart';

mixin AppMixin {
  void showAppSnackbar(BuildContext context, Color color, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14.0),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Oke',
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }

  void showExitGroupConfirmation(
    BuildContext context, {
    required Function()? onPressed,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Are you sure you exit the group? "),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  void showSignOutConfirmation(BuildContext context,
      {required AuthService authService}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await authService.signOut();
                navigator.pushNamedAndRemoveUntil(
                    RouterConstant.loginPage, (route) => false);
              },
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  // void showPopUpDialog(
  //   BuildContext context, {
  //   required void Function()? onPressed,
  // }) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: ((context, setState) {
  //           return AlertDialog(
  //             title: const Text(
  //               "Create a group",
  //               textAlign: TextAlign.left,
  //             ),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 _isLoading == true
  //                     ? Center(
  //                         child: CircularProgressIndicator(
  //                             color: Theme.of(context).primaryColor),
  //                       )
  //                     : TextField(
  //                         onChanged: (val) {
  //                           setState(() {
  //                             groupName = val;
  //                           });
  //                         },
  //                         style: const TextStyle(color: Colors.black),
  //                         decoration: InputDecoration(
  //                           enabledBorder: OutlineInputBorder(
  //                               borderSide: BorderSide(
  //                                   color: Theme.of(context).primaryColor),
  //                               borderRadius: BorderRadius.circular(20)),
  //                           errorBorder: OutlineInputBorder(
  //                               borderSide: const BorderSide(color: Colors.red),
  //                               borderRadius: BorderRadius.circular(20)),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).primaryColor),
  //                             borderRadius: BorderRadius.circular(20),
  //                           ),
  //                         ),
  //                       ),
  //               ],
  //             ),
  //             actions: [
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                     backgroundColor: Theme.of(context).primaryColor),
  //                 child: const Text("CANCEL"),
  //               ),
  //               ElevatedButton(
  //                 onPressed:onPressed,
  //                 style: ElevatedButton.styleFrom(
  //                     backgroundColor: Theme.of(context).primaryColor),
  //                 child: const Text("CREATE"),
  //               )
  //             ],
  //           );
  //         }),
  //       );
  //     },
  //   );
  // }
}
