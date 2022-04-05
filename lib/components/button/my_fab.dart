import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyFAB extends StatefulWidget {
  final ScrollController controller;
  final FloatingActionButton child;
  const MyFAB({Key key, @required this.controller,@required this.child}) : super(key: key);

  @override
  _MyFABState createState() => _MyFABState(this.controller);
}

class _MyFABState extends State<MyFAB> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  final ScrollController _scrollController;
  ScrollDirection _direction;

  _MyFABState(ScrollController controller) : _scrollController = controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
    );
    _controller.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset == 0) {
        _direction = ScrollDirection.forward;
        _controller.forward();
      } else if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
        _direction = ScrollDirection.reverse;
        _controller.reverse();
      } else if (_direction != _scrollController.position.userScrollDirection) {
        _direction = _scrollController.position.userScrollDirection;
        if (_direction == ScrollDirection.forward) {
          _controller.forward();
        } else if (_direction == ScrollDirection.reverse) {
          _controller.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      alignment: Alignment.center,
      child: widget.child,
    );
  }
}