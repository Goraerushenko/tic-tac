import 'package:flutter/material.dart';
import 'package:tic_tac/theme/theme.dart';


class PainterOfLine extends StatelessWidget {
  PainterOfLine({
    Key key,
    this.start,
    this.end,
  }) : super(key: key);
  final Offset start;
  final Offset end;
  List<Widget> listOfPosition = [];
  void buildLine(){
    for(double i = 0;i < 100;i += 0.5){
      double x = end.dx - start.dx;
      double y = end.dy - start.dy;
      listOfPosition.add(
        Transform.translate(
          offset: Offset(start.dx + (x / 100 * i), start.dy + (y / 100 * i)),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey
            ),
            height: 5,
            width: 5,
          ),
        )
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    buildLine();
    return Stack(
      children: listOfPosition.map((el) => el).toList(),
    ) ;
  }
}

