import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  Btn({
    Key key,
    this.gradient,
    this.callBack,
    this.child}) : super(key: key);
  final List<Color> gradient;
  final Widget child;
  final GestureDragCancelCallback callBack;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            gradient: this.gradient == null
              ? null
              : LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.1, 0.8],
              colors: gradient),
        ),
        child: Center(
          child: child
        ),
      ),
    );
  }
}
