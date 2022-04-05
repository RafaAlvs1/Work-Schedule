import 'package:escalatrabalho/models/pessoa.dart';
import 'package:escalatrabalho/models/restricao.dart';
import 'package:escalatrabalho/models/setor.dart';
import 'package:escalatrabalho/pages/escalas/pessoa_card.dart';
import 'package:escalatrabalho/pages/escalas/setor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const FIXAR = 'FIXAR';
const EVITAR = 'EVITAR';

const opcoes = {
  'FIXAR': {
    'nome': FIXAR,
    'desc': 'Colocar pessoa somente em um setor',
  },
  'EVITAR': {
    'nome': EVITAR,
    'desc': 'Não deixar pessoa em um ou mais setores',
  }
};

class NovaRestricao extends StatefulWidget {
  List<Pessoa> pessoas;
  List<Setor> setores;

  NovaRestricao({
    Key key,
    List<Pessoa> pessoas,
    List<Setor> setores,
    List<Restricao> restricoes,
  }) : super(key: key) {
    this.pessoas = pessoas.toList();
    this.setores = setores.toList();
    restricoes.forEach((restricao) {
      this.pessoas.remove(restricao.quem);
      restricao.onde.forEach((setor) {
        int setorIndex = this.setores.indexWhere((local) => local.id == setor.id);
        this.setores[setorIndex] = Setor.fromMap(this.setores[setorIndex].toJSON());
        this.setores[setorIndex].quantidade--;
      });
    });

    this.setores.removeWhere((element) => element.quantidade < 1);
  }

  @override
  _NovaRestricaoState createState() => _NovaRestricaoState(setores.toList());
}

class _NovaRestricaoState extends State<NovaRestricao> {
  Pessoa pessoaEscolhida;
  List<Setor> setoresEscolhidos = [];
  String tipo;

  List<Setor> setores;

  _NovaRestricaoState(this.setores);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Qual pessoa tem alguma restrição?',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                pessoaEscolhida == null ? Container(
                  height: 100.0,
                  padding: EdgeInsets.symmetric(horizontal: 8.0,),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.pessoas?.length ?? 0,
                    itemBuilder: (context, index) {
                      return PessoaCard(
                        widget.pessoas[index],
                        onTap: () {
                          setState(() {
                            pessoaEscolhida = widget.pessoas[index];
                          });
                        },
                      );
                    },
                  ),
                ) : Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 8.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PessoaCard(
                        pessoaEscolhida,
                        onTap: () {
                          setState(() {
                            pessoaEscolhida = null;
                            tipo = null;
                            setoresEscolhidos = [];
                            setores = widget.setores.toList();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (pessoaEscolhida != null) _buildQualRestricao((val) {
                  setState(() => tipo = val);
                },),
                if (tipo != null) _buildQuaisSetores(),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
        if (setoresEscolhidos.length > 0) _buildBtnConcluir(),
      ],
    );
  }

  Widget _buildTipoRestricao({
    Key key,
    String option,
    String description,
    Function() onTap,
  }) {
    return Container(
      key: key,
      width: 150,
      child: Card(
        elevation: 1.5,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  option ?? '',
                  textAlign: TextAlign.center,
                ),
                Text(
                  description ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQualRestricao(Function(String) onChange) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Qual é a restrição?',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        Container(
          height: 100.0,
          padding: EdgeInsets.symmetric(horizontal: 8.0,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: tipo == null ? opcoes.values.map((value) => _buildTipoRestricao(
              option: value['nome'],
              description: value['desc'],
              onTap: () {
                onChange(value['nome']);
              },
            )).toList() : [
              _buildTipoRestricao(
                key: ValueKey<String>('selecionado'),
                option: opcoes[tipo]['nome'],
                description: opcoes[tipo]['desc'],
                onTap: () {
                  onChange(null);
                  setoresEscolhidos = [];
                  setores = widget.setores.toList();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuaisSetores() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (setores.length > 0) Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tipo == FIXAR ? 'Qual é o setor?' : setores.length == 1 ? 'Este setor?' : 'Quais dos ${setores.length} setores?',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        if ((tipo == FIXAR && setoresEscolhidos.length < 1) || (tipo == EVITAR && setores.length > 0)) Container(
          height: 100.0,
          padding: EdgeInsets.symmetric(horizontal: 8.0,),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: setores?.length ?? 0,
            itemBuilder: (context, index) {
              return SetorCard(
                setores[index],
                onTap: () {
                  setState(() {
                    setoresEscolhidos.add(setores[index]);
                    setores.removeAt(index);
                  });
                },
              );
            },
          ),
        ),
        if (tipo != FIXAR && setoresEscolhidos.length > 0) Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Setores Escolhido',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        if (tipo != FIXAR && setoresEscolhidos.length > 0) Container(
          height: 100.0,
          padding: EdgeInsets.symmetric(horizontal: 8.0,),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: setoresEscolhidos.length ?? 0,
            itemBuilder: (context, index) {
              return SetorCard(
                setoresEscolhidos[index],
                onTap: () {
                  _updateArraySetores(index);
                },
              );
            },
          ),
        ),
        if (tipo == FIXAR && setoresEscolhidos.length > 0) Container(
          height: 100.0,
          padding: EdgeInsets.symmetric(horizontal: 8.0,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SetorCard(
                setoresEscolhidos[0],
                onTap: () {
                  _updateArraySetores(0);
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildBtnConcluir() {
    return Container(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Text(
          'Concluir',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Restricao restricao = Restricao(
            quem: pessoaEscolhida,
            qual: tipo,
            onde: setoresEscolhidos,
          );

          Navigator.of(context).pop(restricao);
        },
        color: Colors.green,
      ),
    );
  }

  _updateArraySetores(int index) {
    final oldIndex = widget.setores.indexWhere((element) => element.id == setoresEscolhidos[index].id);
    for (var i = setores.length; i >= 0; i--) {
      if (i == 0) {
        setores.insert(0, setoresEscolhidos[index]);
        break;
      }
      final searchIndex = widget.setores.indexWhere((element) => element.id == setores[i - 1].id);
      if (oldIndex > searchIndex) {
        if (searchIndex >= i) {
          setores.add(setoresEscolhidos[index]);
        } else {
          setores.insert(searchIndex + 1, setoresEscolhidos[index]);
        }
        break;
      }
    }
    setState(() {
      setoresEscolhidos.removeAt(index);
    });
  }}