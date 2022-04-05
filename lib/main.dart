import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:escalatrabalho/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firestore.instance.settings(persistenceEnabled: true);

    return MaterialApp(
      title: 'Escala de Trabalho',
      theme: ThemeData(
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.teal[100],
          elevation: 0,
          shape: CircularNotchedRectangle(),
        ),
//        scaffoldBackgroundColor: Colors.teal[50],
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      home: RootPage(),
    );
  }
}
