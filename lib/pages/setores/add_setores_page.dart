import 'package:escalatrabalho/components/inputs/my_input.dart';
import 'package:escalatrabalho/components/inputs/my_switch.dart';
import 'package:escalatrabalho/models/setor.dart';
import 'package:flutter/material.dart';
import 'package:escalatrabalho/components/dialogs/my_progress_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddSetoresPage extends StatefulWidget {
  Setor setor;

  AddSetoresPage({
    Key key,
    this.setor
  }) : super(key: key);

  @override
  _AddSetoresPageState createState() => _AddSetoresPageState(Setor.fromMap(this.setor?.toJSON() ?? {}));
}

class _AddSetoresPageState extends State<AddSetoresPage> {
  final _formKey = GlobalKey<FormState>();
  Setor setor;

  _AddSetoresPageState(this.setor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Informações do Setor'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _buildForm(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: _buildButtonConfirm(),
      ),
    );
  }

  _buildForm() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MyInput(
                labelText: 'Nome',
                controller: new TextEditingController(text: setor.nome),
                onSaved: (val) => setState(() => setor.nome = val.trim()),
              ),
              MyInput(
                labelText: 'Quantidade',
                controller: new TextEditingController(text: setor.quantidade?.toString()),
                keyboardType: TextInputType.number,
                onSaved: (val) => setState(() => setor.quantidade = int.tryParse(val)),
                onValidator: (val) {
                  int result = int.tryParse(val);
                  if (result == null || result < 1) {
                    return 'Por favor, insira um valor válido';
                  } else {
                    return null;
                  }
                },
              ),
              MySwitch(
                labelTextEnable:'Ativo',
                labelTextDisable: 'Desativado',
                descriptionText: 'Indica se o setor vai estar na escala',
                value: setor.estaAtivado,
                onChange: (value) {
                  setState(() {
                    setor.ativo = value;
                  });
                },
              ),
            ],
          ),
        )
    );
  }

  _buildButtonConfirm() {
    return Container(
      color: Colors.green[700],
      height: 50.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: salvar,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.check,
                color: Colors.white,
              ),
              SizedBox(width: 8.0,),
              Text(
                'SALVAR',
                style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  salvar() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      MyProgressDialog  pr = MyProgressDialog(
        context: context,
        isDismissible: false,
        message: 'Aguarde...',
      );
      await pr.show();

      setor.save().then((value) {
        Navigator.of(context).pop();
      }).catchError((error) {
        Scaffold.of(context)
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
}
