import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';


class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: [
            FacebookSignInButton( onPressed: () {
              print("hello");
            },)
          ],
        ),

    );
  }
}
