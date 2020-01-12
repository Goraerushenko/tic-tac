import 'package:flutter/material.dart';
import 'package:tic_tac/theme/theme.dart';
class OIcon extends StatelessWidget {
  OIcon(
      {Key key,
      this.size}) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: MyTheme.green,
          shape: BoxShape.circle
      ),
      child: Center(
        child: Container(
          height: size / 3,
          width: size / 3,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
          ),
        ),
      ),
    );
  }
}
