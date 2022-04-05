import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escalatrabalho/pages/pessoas/add_pessoa_page.dart';
import 'package:escalatrabalho/pages/pessoas/ver_pessoa_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:escalatrabalho/models/pessoa.dart';

class ListaPessoasPage extends StatefulWidget {
  @override
  _ListaPessoasPageState createState() => _ListaPessoasPageState();
}

class _ListaPessoasPageState extends State<ListaPessoasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: Pessoa.path_pessoas.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return _buildCenterText('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                  height: 8.0,
                  child: LinearProgressIndicator(),
                );
              default:
                if (!snapshot.hasData) {
                  return _buildCenterText('Problema recebendo dados');
                } else {
                  if (snapshot.data.documents.length == 0) {
                    return _buildCenterText('Não há pessoas registrada');
                  } else {
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                            expandedHeight: 150.0,
                            flexibleSpace: const FlexibleSpaceBar(
                              title: Text('Pessoas'),
                            ),
                            floating: true,
                            actions: <Widget>[
                              IconButton(
                                icon: const Icon(FontAwesomeIcons.userPlus),
                                tooltip: 'Adicionar Pessoa',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddPessoaPage(),),
                                  );
                                },
                              ),
                            ]
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(20),
                          sliver: SliverGrid.count(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: snapshot.data.documents.map((DocumentSnapshot document) {
                              Pessoa data = Pessoa.fromDoc(document);
                              return _buildItem(data);
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }

  Widget _buildCenterText(String text) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Pessoa pessoa) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.all(0.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(4.0),),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerPessoaPage(pessoa: pessoa,),),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                _buildAvatar(pessoa),
                Hero(
                  tag: 'pessoa-nome-' + pessoa.id,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      pessoa.nome ?? '',
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAvatar(Pessoa pessoa) {
    return Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.all(8.0),
        decoration: new BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: new BorderRadius.all(Radius.circular(8.0),),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: pessoa.fotoUrl == null ?
          Icon(
            FontAwesomeIcons.userAlt,
            size: 36.0,
            color: Colors.white,
          ) :
          Image(
            image: NetworkImage(pessoa.fotoUrl),
            fit: BoxFit.cover,
          ),
        )
    );
  }
}