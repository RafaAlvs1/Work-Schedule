import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escalatrabalho/models/escalas.dart';
import 'package:escalatrabalho/pages/escalas/nova_escala_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ListaEscalasPage extends StatefulWidget {
  @override
  _ListaEscalasPageState createState() => _ListaEscalasPageState();
}

class _ListaEscalasPageState extends State<ListaEscalasPage> {
  final dayFormat = DateFormat('dd/MM/yyyy');
  List<Escala> escalas;
  StreamSubscription streamSubscription;
  @override
  void initState() {
    super.initState();
    streamSubscription = Escala.path_escalas.snapshots().listen((event) {
      setState(() {
        escalas = event.documents.map((e) => Escala.fromDoc(e)).toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Escalas'),
            ),
            floating: true,
            pinned: escalas == null || escalas.length == 0,
            actions: <Widget>[
              IconButton(
                icon: const Icon(FontAwesomeIcons.plusCircle),
                tooltip: 'Adicionar Escala',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NovaEscalaPage(),),
                  );
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return _buildItem(escalas[index]);
              },
              childCount: escalas?.length ?? 0,
            ),
          ),
          if (escalas == null || escalas.length == 0) SliverFillRemaining(
            child: _buildProgress(),
          )
        ],
      ),
    );
  }

  _buildProgress() {
    if (escalas == null) {
      return Center(child: CircularProgressIndicator(),);
    } else {
      return Center(child: _buildCenterText('Não há escalas registrada'),);
    }
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

  Widget _buildItem(Escala data) {
    return Card(
      elevation: 1.5,
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Semana',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  dayFormat.format(DateTime.parse(data.inicio)) ?? '',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ' à ',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  dayFormat.format(DateTime.parse(data.fim)) ?? '',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => AddSetoresPage(setor: data,),),
//          );
        },
      ),
    );
  }
}
