import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:lean_code_chat/pages/channels_page.dart';
import 'package:lean_code_chat/connection/server_connection.dart';
import 'package:lean_code_chat/models/token_model.dart';

final facebookLogin = FacebookLogin();

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _loginPageState();
  }
}

class _loginPageState extends State<LoginPage> {
  String error = null;
  final ServerConnection serverConnection = ServerConnection();

  _showErrorOnUI(String result) {
    setState(() {
      error = result;
    });
  }

  Future fbLogin() async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        // _sendTokenToServer(result.accessToken.token);
        // _showLoggedInUI();
        await logIn(result);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ChannelPage();
            },
          ),
        );
        break;
      case FacebookLoginStatus.cancelledByUser:
      case FacebookLoginStatus.error:
        _showErrorOnUI(result.errorMessage);
        break;
    }
  }

  Future logIn(FacebookLoginResult result) async {
    var connectionResult =
        await serverConnection.signIn(result.accessToken.token);
    switch (connectionResult.statusCode) {
      case HttpStatus.ok:
        ServerConnection.tokenStorage
            .setToken(Token.fromJson(json.decode(connectionResult.body)));
        await serverConnection.getFirebaseToken();
        await serverConnection.getCurrentUser();
        break;
      case HttpStatus.badRequest:
        var badRequest = json.decode(connectionResult.body);
        if (badRequest['error_description'] == 'user_does_not_exist') {
          var accountCreationResult =
              await serverConnection.accountCreate(result.accessToken.token);
          if (accountCreationResult.statusCode == HttpStatus.ok) {
            return logIn(result);
          }
        }
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FacebookSignInButton(onPressed: fbLogin),
              Text(error ?? ''),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
