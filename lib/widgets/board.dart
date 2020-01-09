import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/models/board-model.dart';
import 'dart:math';

import 'package:tic_tac/widgets/o.dart';
import 'package:tic_tac/widgets/x.dart';

class BoardWidget extends StatefulWidget {
  BoardWidget({
    Key key,
    this.reverse,
    this.currPlayer,
    this.withBot,
    this.winCallback,
    this.whoseMove,
    this.clearIsStarted,
    this.drawALine
  }) : super(key:key);
  final bool reverse;
  final Function(Offset, Offset) drawALine;
  final Function clearIsStarted;
  final String currPlayer;
  final Function(String) whoseMove;
  final bool withBot;
  final Function(int, int) winCallback;

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> with TickerProviderStateMixin{
  int _xWins = 0;
  int _oWins = 0;
  AnimationController _controller;
  List<List<AnimationController>> _animationsController = [];
  List<Animation<dynamic>> _animations = [];
  List<List<Animation<dynamic>>> _animatedIcon = [];
  List<Offset> _coords = [];
  List<List<GlobalKey>> _keys = [
    [GlobalKey(), GlobalKey(), GlobalKey()],
    [GlobalKey(), GlobalKey(), GlobalKey()],
    [GlobalKey(), GlobalKey(), GlobalKey()],
  ];
  List<List<int>> coordAround = [[0,1],[1,-1],[-1,-1],[0,-1],[1,0],[-1,0],[1,1],[-1,1]];
  Board _board = Board();
  List<dynamic> list = [];
  AudioCache player = AudioCache();
  String currentPlayer = 'x';
  final borderLine = BorderSide(color: Colors.grey);
  final transLine = BorderSide(color: Colors.transparent);
  void clearBoard(){
    widget.clearIsStarted();
    currentPlayer = widget.currPlayer;
    for(int i = 0;i < 3;i++){
      for(int j = 0;j < 3;j++){
        _animationsController[i][j].status == AnimationStatus.completed ? _animationsController[i][j].reverse() : null;
      }
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _board = Board();
      });
    });
  }
  bool draw() => _board.isDraw;

  String whoWinner(){
    String winner = '';
    for(int i = 0; i < _board.length; i++){
      for(int j = 0; j < _board[i].length; j++){
        for(int el = 0; el < coordAround.length; el++){
          if(i + coordAround[el][0]*2 >= 0 && j + coordAround[el][1]*2 >= 0 && j + coordAround[el][1]*2 < 3 && i + coordAround[el][0]*2 < 3){
            if(arrayOfBorder[i][j] == arrayOfBorder[i + coordAround[el][0]][j + coordAround[el][1]] &&
                arrayOfBorder[i][j] == arrayOfBorder[i + coordAround[el][0]*2][j + coordAround[el][1]*2]){
              if(arrayOfBorder[i][j] != '' && winner == ''){
                winner = arrayOfBorder[i][j];
                RenderBox boxF = _keys[i][j].currentContext.findRenderObject();
                RenderBox boxS = _keys[i + coordAround[el][0]*2][j + coordAround[el][1]*2].currentContext.findRenderObject();
                widget.drawALine(
                    Offset(boxF.localToGlobal(Offset.zero).dx + 2, boxF.localToGlobal(Offset.zero).dy + 3),
                    Offset(boxS.localToGlobal(Offset.zero).dx + 2, boxS.localToGlobal(Offset.zero).dy + 3));
                print(_coords);
              }
            }
          }
        }
      }
    }
    return winner;
  }
  void onTap(int x, int y){
    _controller.forward();
    RenderBox f = _keys[x][y].currentContext.findRenderObject();
    list.add(f.localToGlobal(Offset.zero));
    print(list);
    if(arrayOfBorder[y][x] == ''){
      _animationsController[y][x].forward();
      if(widget.withBot != null){
        currentPlayer == 'x' ? player.play('x.mp3') :  player.play('o.mp3');
        setState(() => arrayOfBorder[y][x] = currentPlayer);
        while(!draw()){
          List<int> randomNum = [Random().nextInt(3),Random().nextInt(3)];
          if(arrayOfBorder[randomNum[0]][randomNum[1]] == ''){
            setState(() => arrayOfBorder[randomNum[0]][randomNum[1]] = widget.currPlayer == 'x' ? 'o' : 'x');
            _animationsController[randomNum[0]][randomNum[1]].forward();
            break;
          }
        }
      } else {
        currentPlayer == 'x' ? player.play('x.mp3') :  player.play('o.mp3');
        setState(() => arrayOfBorder[y][x] = currentPlayer);
        setState(() => currentPlayer == 'x' ? currentPlayer = 'o' : currentPlayer = 'x');
      }
      widget.whoseMove(currentPlayer);
    } else {

  }
    if(whoWinner() != ''){
      whoWinner() == 'x' ? _xWins++ : _oWins++;
      widget.winCallback(_xWins, _oWins);
    } else if(draw()){
      widget.winCallback(_xWins, _oWins);
      widget.currPlayer == 'o' && widget.withBot != null ? arrayOfBorder[Random().nextInt(3)][Random().nextInt(3)] = 'x' : null;
    }
  }

  Widget cell(bool left, bool right, bool bottom,int x, int y) => GestureDetector(
    onTap: (){onTap(x,y);},
    child: Container(
      height: 93.3,
      width: 76.6,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: bottom ? borderLine : transLine,right: right ? borderLine : transLine,left: left ? borderLine : transLine,)
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              key: _keys[y][x],
              height: 10,
              width: 10,
              color: Colors.transparent,
            ),
          ),
          arrayOfBorder[y][x] == '' ? SizedBox() : Opacity(
            opacity: _animatedIcon[y][x].value,
            child: Center(
              child: arrayOfBorder[y][x] == 'x' ? XIcon(size: 50,) : OIcon(size: 50,),
            ),
          ),
        ],
      )
    ),
  );

  @override
  void initState() {
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 400));
    for(int i = 0;i < 3;i++){
      _animationsController.add([]);
      _animatedIcon.add([]);
      for(int j = 0;j < 3;j++){
        _animationsController[i].add(AnimationController(vsync: this,duration: Duration(milliseconds: 400)));
        _animatedIcon[i].add(Tween(begin: 0.0, end: 1.0).animate(_animationsController[i][j])..addListener((){setState(() {});}));
      }
    }
    currentPlayer = widget.currPlayer;
    if(widget.currPlayer == 'o' && widget.withBot != null){
      List<int> random = [Random().nextInt(3),Random().nextInt(3)];
      arrayOfBorder[random[0]][random[1]] = 'x';
      _animationsController[random[0]][random[1]].forward();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.reverse){
      clearBoard();
      Future.delayed(Duration(milliseconds: 500), (){
        if(widget.currPlayer == 'o' && widget.withBot != null){
          List<int> random = [Random().nextInt(3),Random().nextInt(3)];
          arrayOfBorder[random[0]][random[1]] = 'x';
          _animationsController[random[0]][random[1]].forward();
        }
      });
    }
    return Card(
      elevation: 1,
      child: Container(
        height: 300,
        width: 250,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      cell(false, false, true, 0, 0),
                      cell(true, true, true, 1, 0),
                      cell(false, false, true, 2, 0),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      cell(false, false, true, 0, 1),
                      cell(true, true, true, 1, 1),
                      cell(false, false, true, 2, 1),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      cell(false, false, false, 0, 2),
                      cell(true, true, false, 1, 2),
                      cell(false, false, false, 2, 2),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
