import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  get authState => null;

  Future<bool> signIn({@required String email, @required String password});

  Future<void> signOut();

  Future<FirebaseUser> currentUser();
}

class Auth implements BaseAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> currentUser() {
    return auth.currentUser();
  }

  @override
  Future<bool> signIn({@required String email, @required String password}) async {
    return auth.signInWithEmailAndPassword(email: email, password: password).then((authResult) => authResult != null);
  }

  @override
  Future<void> signOut() async {
    return auth.signOut();
  }

  @override
  get authState => auth.onAuthStateChanged;
}
