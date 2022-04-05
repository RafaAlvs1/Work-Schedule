import 'package:flutter/material.dart';
import 'package:escalatrabalho/components/dialogs/my_progress_dialog.dart';
import 'package:escalatrabalho/services/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final BaseAuth auth = new Auth();
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage = "";

  bool isVisible = false;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
    });

    MyProgressDialog  pr = new MyProgressDialog(
      context: context,
      isDismissible: false,
      message: 'Aguarde...',
    );
    await pr.show();

    if (validateAndSave()) {
      bool userResult = false;
      FocusScope.of(context).requestFocus(FocusNode());
      try {
        userResult = await auth.signIn(
            email: _email,
            password: _password
        );
        print('Signed in: $userResult');

        if (!userResult) {
          String errorMessage = "Não foi possível realizar a autenticação";
          setState(() {
            _errorMessage = errorMessage;
          });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = e.message; // TODO: Problema ao tentar recuperar o erro na get de message
        });
      }
    }

    await pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _loginForm(),
              ),
//              _buildFooter(context),
            ],
          ),
        )
    );
  }

  _loginForm() => Center(
    child: SingleChildScrollView(
      child: new Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              showEmailInput(),
              showPasswordInput(),
              showErrorMessage(),
              showButtonLogin(),
            ],
          )
      ),
    ),
  );

  Widget loginHeader() => Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: 'Venha participar da nossa comunidade e ajudar a '),
              TextSpan(text: ' Lojinha ', style: TextStyle(fontWeight: FontWeight.bold),),
              TextSpan(text: ' ser o maior ponto de vendas para pequenos negócios'),
            ],
          ),
        ),
      )
    ],
  );

  Widget showEmailInput() => Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: new TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: "E-mail",
        labelText: "Digite seu e-mail",
        icon: new Icon(Icons.mail),
      ),
      validator: (value) => value.isEmpty ? 'E-mail não pode estar vazio' : null,
      onSaved: (value) => _email = value.trim(),
    ),
  );

  Widget showPasswordInput() => Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: new TextFormField(
      obscureText: !isVisible,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: "Digite sua senha",
        labelText: "Senha",
        icon: new Icon(Icons.lock),
        suffixIcon: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() => isVisible = !isVisible);
          },
        ),
      ),
      validator: (value) => value.isEmpty ? 'Senha não pode estar vazio' : null,
      onSaved: (value) => _password = value.trim(),
    ),
  );

  Widget showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: new Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.bold
          ),
        ),
      );
    } else {
      return Container( height: 0.0,);
    }
  }

  Widget showButtonLogin() => Container(
    width: double.infinity,
    padding: EdgeInsets.only(top: 30.0),
    margin: EdgeInsets.symmetric(horizontal: 30.0),
    child: RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
      shape: StadiumBorder(),
      child: Text(
        "Acessar", style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      color: Theme.of(context).accentColor,
      onPressed: validateAndSubmit,
    ),
  );
}
