import 'package:escalatrabalho/components/inputs/my_input.dart';
import 'package:escalatrabalho/models/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:escalatrabalho/components/dialogs/my_progress_dialog.dart';

class AddPessoaPage extends StatefulWidget {
  Pessoa pessoa;

  AddPessoaPage({
    Key key,
    this.pessoa
  }) : super(key: key);

  @override
  _AddPessoaPageState createState() => _AddPessoaPageState(Pessoa.fromMap(this.pessoa?.toJSON() ?? {}));
}

class _AddPessoaPageState extends State<AddPessoaPage> {
  final _formKey = GlobalKey<FormState>();
  Pessoa pessoa;

  _AddPessoaPageState(this.pessoa);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _buildForm(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildButtonConfirm(),
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
                controller: new TextEditingController(text: pessoa.nome),
                onSaved: (val) => setState(() => pessoa.nome = val.trim()),
              ),
            ],
          ),
        )
    );
  }

  _buildButtonConfirm() {
    return Builder(
      builder: (context) => Container(
        width: 200,
        child: FloatingActionButton.extended(
          icon: Icon(Icons.done),
          label: Text('Concluir'),
          backgroundColor: Colors.green[700],
          onPressed: salvar,
        ),
      ),
    );
  }

  salvar() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print(pessoa);

      MyProgressDialog  pr = MyProgressDialog(
        context: context,
        isDismissible: false,
        message: 'Aguarde...',
      );
      await pr.show();

      pessoa.save().then((value) {
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
