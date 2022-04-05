import 'package:flutter/material.dart';

String _dialogMessage = "Carregando...";

TextAlign _textAlign = TextAlign.left;
Alignment _progressWidgetAlignment = Alignment.centerLeft;

bool _isShowing = false;
BuildContext _context, _dismissingContext;
bool _barrierDismissible = true;

TextStyle _messageStyle = TextStyle(
  color: Colors.black,
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

double _dialogElevation = 8.0, _borderRadius = 8.0;
Color _backgroundColor = Colors.white;
Curve _insetAnimCurve = Curves.easeInOut;
EdgeInsets _dialogPadding = const EdgeInsets.all(8.0);

Widget _progressWidget = CircularProgressIndicator();

class MyProgressDialog {
  _Body _dialog;

  MyProgressDialog({
    @required BuildContext context,
    bool isDismissible,
    String message,
  }) {
    _context = context;
    _barrierDismissible = isDismissible ?? true;
    _dialogMessage = message ?? _dialogMessage;
  }

  void style({
    Widget child,
    String message,
    Widget progressWidget,
    Color backgroundColor,
    TextStyle progressTextStyle,
    TextStyle messageTextStyle,
    double elevation,
    TextAlign textAlign,
    double borderRadius,
    Curve insetAnimCurve,
    EdgeInsets padding,
    Alignment progressWidgetAlignment
  }) {
    if (_isShowing) return;

    _dialogMessage = message ?? _dialogMessage;
    _progressWidget = progressWidget ?? _progressWidget;
    _backgroundColor = backgroundColor ?? _backgroundColor;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _dialogElevation = elevation ?? _dialogElevation;
    _borderRadius = borderRadius ?? _borderRadius;
    _insetAnimCurve = insetAnimCurve ?? _insetAnimCurve;
    _textAlign = textAlign ?? _textAlign;
    _progressWidget = child ?? _progressWidget;
    _dialogPadding = padding ?? _dialogPadding;
    _progressWidgetAlignment = progressWidgetAlignment ?? _progressWidgetAlignment;
  }

  void update({
    String message,
    Widget progressWidget,
    TextStyle messageTextStyle,
  }) {
    _dialogMessage = message ?? _dialogMessage;
    _progressWidget = progressWidget ?? _progressWidget;
    _messageStyle = messageTextStyle ?? _messageStyle;

    if (_isShowing) {
      _dialog.update();
    }
  }

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop();
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err);
      return Future.value(false);
    }
  }

  Future<bool> show() async {
    try {
      if (!_isShowing) {
        _dialog = new _Body();
        FocusScope.of(_context).requestFocus(FocusNode());
        showDialog<dynamic>(
          context: _context,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            _dismissingContext = context;
            return WillPopScope(
              onWillPop: () async => _barrierDismissible,
              child: Dialog(
                  backgroundColor: _backgroundColor,
                  insetAnimationCurve: _insetAnimCurve,
                  insetAnimationDuration: Duration(milliseconds: 100),
                  elevation: _dialogElevation,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(_borderRadius))),
                  child: _dialog),
            );
          },
        );
        // Delaying the function for 200 milliseconds
        // [Default transitionDuration of DialogRoute]
        await Future.delayed(Duration(milliseconds: 200));
        _isShowing = true;
        return true;
      } else {
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err);
      return false;
    }
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _BodyState _dialog = _BodyState();

  update() {
    _dialog.update();
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  update() {
    setState(() {});
  }

  @override
  void dispose() {
    _isShowing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _dialogPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 60.0),
              const SizedBox(width: 8.0),
              Align(
                alignment: _progressWidgetAlignment,
                child: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: _progressWidget,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _dialogMessage,
                  textAlign: _textAlign,
                  style: _messageStyle,
                ),
              ),
              const SizedBox(width: 8.0)
            ],
          ),
        ],
      ),
    );
  }
}