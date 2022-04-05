import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  final String labelText;
  final void Function(String) onSaved;
  final void Function(String) onValidator;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const MyInput({Key key, this.labelText, this.onSaved, this.controller, this.keyboardType, this.onValidator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0,),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        validator: onValidator != null ? onValidator : keyboardType == TextInputType.number ?
        ((value) => value.isEmpty ? 'Por favor, não pode estar vazio' :
        double.tryParse(value) == null ? 'Por favor, insira um valor válido' : null)
            : (value) => value.isEmpty ? 'Por favor, não pode estar vazio' : null,
        onSaved: onSaved,
      ),
    );
  }

}