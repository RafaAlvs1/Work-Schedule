import 'package:escalatrabalho/components/dialogs/my_dialog.dart';
import 'package:escalatrabalho/components/dialogs/my_progress_dialog.dart';
import 'package:escalatrabalho/components/inputs/my_date_input.dart';
import 'package:escalatrabalho/models/escalas.dart';
import 'package:escalatrabalho/models/pessoa.dart';
import 'package:escalatrabalho/models/restricao.dart';
import 'package:escalatrabalho/models/setor.dart';
import 'package:escalatrabalho/pages/escalas/nova_restricao.dart';
import 'package:escalatrabalho/pages/escalas/pessoa_card.dart';
import 'package:escalatrabalho/pages/escalas/setor_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NovaEscalaPage extends StatefulWidget {
  @override
  _NovaEscalaPageState createState() => _NovaEscalaPageState();
}

class _NovaEscalaPageState extends State<NovaEscalaPage> {
  List<Pessoa> pessoas;
  List<Setor> setores;
  List<Restricao> restricoes = [];

  final dayFormat = DateFormat('dd/MM/yyyy');
  DateTime inicio;
  DateTime fim;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _updateSemana(DateTime.now());

    Setor.setores_lista_ativos.snapshots().listen((snapshots) {
      setState(() => setores = snapshots.documents.map((doc) => Setor.fromDoc(doc)).toList());
    });
    Pessoa.path_pessoas.snapshots().listen((snapshots) {
      setState(() => pessoas = snapshots.documents.map((doc) => Pessoa.fromDoc(doc)).toList());
    });
  }

  void _updateSemana(DateTime dateTime) {
    inicio = dateTime.subtract(Duration(days: dateTime.weekday % 7));
    fim = inicio.add(Duration(days: 6));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Escala a ser montada'),
            ),
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: MyDateInput(
                        value: inicio,
                        labelText: 'Início em',
                        onChange: (val) {
                          if (val != null) {
                            _updateSemana(val);
                            setState(() {});
                          }
                        }
                    ),
                  ),
                  SizedBox(width: 8.0,),
                  Expanded(
                    child: MyDateInput(
                      value: fim,
                      labelText: 'Final em',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${pessoas?.length ?? 0} pessoas a serem escaladas',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pessoas?.length ?? 0,
                itemBuilder: (context, index) {
                  return PessoaCard(pessoas[index]);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${setores?.length ?? 0} setores na escala',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: setores?.length ?? 0,
                itemBuilder: (context, index) {
                  return SetorCard(setores[index]);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Restrições',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.plusCircle,
                      color: Colors.green,
                    ),
                    onPressed: _buildRestricao,
                  ),
                ],
              ),
            ),
          ),
          if (restricoes.length == 0) SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Nenhuma restrição registrada',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildListaRestricoes(),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(30, 20, 30, 40),
              child: RaisedButton.icon(
                elevation: 0,
                color: Colors.green,
                onPressed: _salvar,
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Montar Escala',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                icon: Icon(
                  FontAwesomeIcons.cogs,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _buildRestricao() async {
    MyDialog dialog = MyDialog(
      context: context,
      content: NovaRestricao(
        pessoas: pessoas,
        setores: setores,
        restricoes: restricoes,
      ),
    );

    Restricao restricao = await dialog.show();

    if (restricao != null) {
      setState(() {
        restricoes.add(restricao);
      });
    }
  }

  _buildListaRestricoes() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return _buildItem(restricoes[index]);
        },
        childCount: restricoes.length,
      ),
    );
  }

  _buildItem(Restricao restricao) {
    return Card(
      elevation: 1.5,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(10.0),
        trailing: IconButton(
          icon: Icon(
            FontAwesomeIcons.trashAlt,
            color: Colors.red,
          ),
          onPressed: () {
            setState(() {
              restricoes.remove(restricao);
            });
          },
        ),
        title: Text(
          restricao.quem.nome ?? '',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        subtitle: Text(
          restricao.qual == FIXAR
              ? 'Fixado no setor ${restricao.onde[0].nome}'
              : 'Evitando ' + (restricao.onde.length == 1 ? 'o setor ${restricao.onde[0].nome}' : ' ${restricao.onde.length} setores'),
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  void _salvar() async {
    MyProgressDialog  pr = MyProgressDialog(
      context: context,
      isDismissible: false,
      message: 'Aguarde...',
    );
    await pr.show();

    Escala escala = Escala(
      fim: fim,
      inicio: inicio,
      pessoas: pessoas,
      setores: setores,
      restricoes: restricoes,
    );

    escala.save().then((value) {
      Navigator.of(context).pop();
    }).catchError((error) {
      _scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
    }).whenComplete(() => pr.hide());
  }
}
