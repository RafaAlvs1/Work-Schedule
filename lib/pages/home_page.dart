import 'package:escalatrabalho/pages/escalas/lista_escalas_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:escalatrabalho/pages/setores/lista_setores_page.dart';
import 'package:escalatrabalho/pages/pessoas/lista_pessoas_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semana atual'),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  _buildBottomBar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.cubes,
              ),
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaSetoresPage(),),
                );
              },
            ),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.columns,
              ),
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaEscalasPage(),),
                );
              },
            ),
            SizedBox(width: 20,),
            SizedBox(width: 20,),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.users,
              ),
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaPessoasPage(),),
                );
              },
            ),
          ],
        ),
      ),
    );
  }}
