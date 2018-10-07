import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MarqueeSingle extends StatefulWidget {
  final Widget child;

  MarqueeSingle({Key key, this.child}) : super(key: key);

  @override
  _MarqueeSingleState createState() => _MarqueeSingleState();
}

class _MarqueeSingleState extends State<MarqueeSingle> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(-1.0, 0.0))
        .animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(child: FractionalTranslation(
        translation: _animation.value,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: widget.child)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MarqueeContinuous extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double stepOffset;

  MarqueeContinuous(
      {Key key,
        this.child,
        this.duration = const Duration(seconds: 2),
        this.stepOffset = 50.0})
      : super(key: key);

  @override
  _MarqueeContinuousState createState() => _MarqueeContinuousState();
}

class _MarqueeContinuousState extends State<MarqueeContinuous> {
  ScrollController _controller;
  Timer _timer;
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(initialScrollOffset: _offset);
    _timer = Timer.periodic(widget.duration, (timer) {
      double newOffset = _controller.offset + widget.stepOffset;
      if (newOffset != _offset) {
        _offset = newOffset;
        _controller.animateTo(_offset,
            duration: widget.duration, curve: Curves.linear);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          return widget.child;
        });
  }
}
