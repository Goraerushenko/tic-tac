import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac/theme/theme.dart';

class XIcon extends StatelessWidget {
  XIcon({Key key,
       this.size}) : super(key:key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.rotate(
          angle: -pi/4,
          child: Container(
            height: size,
            width: size / 5,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.8],
                    colors: [MyTheme.red,MyTheme.orange]
                )
            ),
          ),
        ),
        Transform.rotate(
          angle: pi/4,
          child: Container(
            height: size,
            width: size / 5,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.8],
                    colors: [MyTheme.red, MyTheme.orange]
                )
            ),
          ),
        ),
      ],
    );
  }
}
