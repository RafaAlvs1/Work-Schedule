import 'package:flutter/material.dart';

class MySwitch extends StatefulWidget {
  final bool value;
  final String labelTextEnable;
  final String labelTextDisable;
  final String descriptionText;
  final Function(bool) onChange;

  const MySwitch({Key key, this.descriptionText, this.onChange, this.value, this.labelTextEnable, this.labelTextDisable}) : super(key: key);

  @override
  _MySwitchState createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.only(bottom: 8.0,),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(Radius.circular(4.0),),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    // TODO: Retirar a animação do centro
                    final  offsetAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  child: Text(
                    widget.value ? widget.labelTextEnable : widget.labelTextDisable,
                    key: ValueKey<bool>(widget.value),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: widget.value ? Theme.of(context).primaryColor : Colors.black54,
                    ),
                  ),
                ),
                Text(
                  widget.descriptionText,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.value,
            onChanged: widget.onChange,
          )
        ],
      ),
    );
  }
}