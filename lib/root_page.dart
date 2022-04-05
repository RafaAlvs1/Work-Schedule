import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:escalatrabalho/pages/acesso/login_page.dart';
import 'package:escalatrabalho/pages/home_page.dart';
import 'package:escalatrabalho/services/authentication.dart';

class RootPage extends StatelessWidget {
  final BaseAuth auth = new Auth();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: auth.authState,
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasError) {
            // TODO: Criar tela de erro
            return _buildErrorScreen(context);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // TODO: Criar tela animada
            return _buildWaitingScreen(context);
          } else {
            FirebaseUser user = snapshot.data;
            bool isLogged = user != null;
            if (isLogged) {
              return MyHomePage();
            } else {
              Navigator.of(context).popUntil((route) => route.isFirst);
              return LoginPage();
            }
          }
        });
  }

  Widget _buildWaitingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        alignment: Alignment.center,
        child: Text("Error!"),
      ),
    );
  }
}