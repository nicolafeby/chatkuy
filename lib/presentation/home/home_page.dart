import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:chatkuy/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Scaffold(
      body: Center(
        child: CustomButtonWidget(
          onPressed: () async {
            final navigator = Navigator.of(context);
            await authService.signOut();
            navigator.pushReplacementNamed(RouterConstant.loginPage);
          },
          text: 'Keluar',
        ),
      ),
    );
  }
}
