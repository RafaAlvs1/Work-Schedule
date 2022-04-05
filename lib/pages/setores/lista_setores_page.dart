import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escalatrabalho/models/setor.dart';
import 'package:escalatrabalho/pages/setores/add_setores_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListaSetoresPage extends StatefulWidget {
  @override
  _ListaSetoresPageState createState() => _ListaSetoresPageState();
}

class _ListaSetoresPageState extends State<ListaSetoresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: Setor.setores_lista.snapshots(),
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
                              title: Text('Setores'),
                            ),
                            floating: true,
                            actions: <Widget>[
                              IconButton(
                                icon: const Icon(FontAwesomeIcons.plusCircle),
                                tooltip: 'Adicionar Setor',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddSetoresPage(),),
                                  );
                                },
                              ),
                            ]
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  Setor data = Setor.fromDoc(snapshot.data.documents[index]);
                                  return _buildItem(data);
                            },
                            childCount: snapshot.data.documents.length,
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

  Widget _buildItem(Setor data) {
    return Card(
      elevation: 1.5,
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        leading: _buildAvatar(data),
        trailing: _buildCapacidade(data),
        title: Text(
          data.nome ?? '',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSetoresPage(setor: data,),),
          );
        },
      ),
    );
  }

  _buildAvatar(Setor data) {
    return Container(
        width: 50,
        height: 50,
        decoration: new BoxDecoration(
          color: data.estaAtivado ? Colors.teal : Colors.black45,
          borderRadius: new BorderRadius.all(Radius.circular(8.0),),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: data.fotoUrl == null ?
          Icon(
            FontAwesomeIcons.cube,
            size: 36.0,
            color: Colors.white,
          ) :
          Image(
            image: NetworkImage(data.fotoUrl),
            fit: BoxFit.cover,
          ),
        )
    );
  }

  _buildCapacidade(Setor data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          'máx',
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
        new Text(
          data.quantidade?.toString() ?? '1',
          style: TextStyle(
            fontSize: 22.0,
          ),
        ),
      ],
    );
  }
}