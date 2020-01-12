import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/models/board-model.dart';
import 'package:tic_tac/widgets/o.dart';
import 'package:tic_tac/widgets/x.dart';

class CellWidget extends InkWell {
  CellWidget({
    @required Cell cell,
    @required VoidCallback onTap,

    bool bottom = true,
    bool left = false,
    bool right = false,

    final borderLine = const BorderSide(color: Colors.grey),
    final transLine = const BorderSide(color: Colors.transparent),
    Animation animatedIcon
  }) : super(
    onTap: onTap,
    child: Container(
      height: 93.3,
      width: 76.6,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: bottom ? borderLine : transLine,
          right: right ? borderLine : transLine,
          left: left ? borderLine : transLine,
        )
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              key: cell.key,
              height: 10,
              width: 10,
              color: Colors.transparent,
            ),
          ),
          cell.cell == ''
            ? SizedBox()
            : Opacity(
                opacity: animatedIcon.value ?? 1,
                child: Center(
                  child: cell.cell == 'x'
                    ? XIcon(size: 50,)
                    : OIcon(size: 50,),
                ),
              ),
      ],
    )
  ),
);



}
