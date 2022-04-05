import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateInput extends StatelessWidget {
  final DateTime value;
  final Function(DateTime) onChange;
  final String labelText;

  const MyDateInput({Key key, this.value, this.onChange, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(Radius.circular(4.0),),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(4.0),),
          onTap: onChange == null ? null : () async {
            onChange(await _selectDate(context, value));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  labelText,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(value),
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context, [DateTime initialDate]) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: new DateTime(2000),
      lastDate: new DateTime(2030),
    );
    return picked;
  }
}