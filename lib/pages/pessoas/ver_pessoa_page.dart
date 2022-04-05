import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escalatrabalho/pages/pessoas/add_pessoa_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:escalatrabalho/models/pessoa.dart';

class VerPessoaPage extends StatefulWidget {
  Pessoa pessoa;

  VerPessoaPage({
    Key key,
    this.pessoa
  }) : super(key: key);

  @override
  _VerPessoaPageState createState() => _VerPessoaPageState(this.pessoa);
}

class _VerPessoaPageState extends State<VerPessoaPage> {
  Pessoa pessoa;

  _VerPessoaPageState(this.pessoa);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                expandedHeight: 150.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Hero(
                    tag: 'pessoa-nome-' + pessoa.id,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        pessoa.nome ?? '',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
//                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.userEdit),
                    tooltip: 'Editar Informações',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPessoaPage(pessoa: pessoa,),),
                      );
                    },
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }
}