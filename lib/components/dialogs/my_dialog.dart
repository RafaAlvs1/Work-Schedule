
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

BuildContext _context;
Widget _content;
List<Widget> _actions;

BuildContext _dismissingContext;
bool _isShowing = false;

class MyDialog {
  _Body _body;

  MyDialog({
    @required BuildContext context,
    Widget content,
    List<Widget> actions,
  }) {
    _context = context;
    _content = content;
    _actions = actions;
  }

  bool isShowing() {
    return _isShowing;
  }

  void update({
    Widget content,
    List<Widget> actions
  }) {
    if (content != null) {
      _content = content;
    }
    _actions = actions;

    if (_isShowing) {
      _body.update();
    }
  }

  Future<dynamic> show() async {
    try {
      if (!_isShowing) {
        _isShowing = true;

        _body = _Body(hide: hide);

        return showGeneralDialog(
          context: _context,
          pageBuilder: (context, anim1, anim2) {
            _dismissingContext = context;
            return _body;
          },
          barrierDismissible: true,
          barrierLabel: MaterialLocalizations.of(_context).modalBarrierDismissLabel,
          barrierColor: Colors.black12,
          transitionDuration: Duration(milliseconds: 200),
          transitionBuilder: (context, animation, secondaryAnimation, child,) {
            return ScaleTransition(
              scale: animation,
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      } else {
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err);
      return;
    }
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
}


class _Body extends StatefulWidget {
  final Function() hide;

  _BodyState _dialog = _BodyState();

  _Body({Key key, this.hide}) : super(key: key);

  update() {
    _dialog.update();
  }

  @override
  _BodyState createState() {
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
    return  SafeArea(
      child: Card(
        margin: EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            _buildActions(),
            if (_content != null) Expanded(
              child: _content,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _actions ?? [
        FlatButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          icon: const Icon(FontAwesomeIcons.solidTimesCircle, size: 18.0),
          label: const Text('Fechar'),
          onPressed: widget.hide,
        ),
      ],
    );
  }
}