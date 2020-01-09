import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/components/customLine.dart';
import 'package:tic_tac/components/o.dart';
import 'package:tic_tac/components/x.dart';
import 'dart:math';

class Board extends StatefulWidget {
  Board({
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
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> with TickerProviderStateMixin{
  int xWins = 0;
  int oWins = 0;
  AnimationController controller;
  List<List<AnimationController>> animationsController = [];
  List<Animation<dynamic>> animations = [];
  List<List<Animation<dynamic>>> animatedIcon = [];
  List<Offset> coords = [];
  List<List<GlobalKey>> keys = [
    [GlobalKey(), GlobalKey(), GlobalKey()],
    [GlobalKey(), GlobalKey(), GlobalKey()],
    [GlobalKey(), GlobalKey(), GlobalKey()],
  ];
  List<List<int>> coordAround = [[0,1],[1,-1],[-1,-1],[0,-1],[1,0],[-1,0],[1,1],[-1,1]];
  var arrayOfBorder = [
    ['', '' ,''],
    ['', '' ,''],
    ['', '' ,''],
  ];
  List<dynamic> list = [];
  GlobalKey firstKey = GlobalKey();
  GlobalKey secondKey = GlobalKey();
  List<GlobalKey> listOfKeys = [GlobalKey(),GlobalKey(),GlobalKey()];
  AudioCache player = AudioCache();
  String currentPlayer = 'x';
  final borderLine = BorderSide(color: Colors.grey);
  final transLine = BorderSide(color: Colors.transparent);
  void clearBoard(){
    widget.clearIsStarted();
    currentPlayer = widget.currPlayer;
    for(int i = 0;i < 3;i++){
      for(int j = 0;j < 3;j++){
        animationsController[i][j].status == AnimationStatus.completed ? animationsController[i][j].reverse() : null;
      }
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        arrayOfBorder = [
          ['', '' ,''],
          ['', '' ,''],
          ['', '' ,''],
        ];
      });
    });
  }
  bool draw(){
    bool have = true;
    arrayOfBorder.forEach((el){
      el.forEach((e){
        if(e == ''){
          have = false;
        }
      });
    });
    return have;
  }
  String whoWinner(){
    String winner = '';
    for(int i = 0; i < arrayOfBorder.length; i++){
      for(int j = 0; j < arrayOfBorder[i].length; j++){
        for(int el = 0; el < coordAround.length; el++){
          if(i + coordAround[el][0]*2 >= 0 && j + coordAround[el][1]*2 >= 0 && j + coordAround[el][1]*2 < 3 && i + coordAround[el][0]*2 < 3){
            if(arrayOfBorder[i][j] == arrayOfBorder[i + coordAround[el][0]][j + coordAround[el][1]] &&
                arrayOfBorder[i][j] == arrayOfBorder[i + coordAround[el][0]*2][j + coordAround[el][1]*2]){
              if(arrayOfBorder[i][j] != '' && winner == ''){
                winner = arrayOfBorder[i][j];
                RenderBox boxF = keys[i][j].currentContext.findRenderObject();
                RenderBox boxS = keys[i + coordAround[el][0]*2][j + coordAround[el][1]*2].currentContext.findRenderObject();
                widget.drawALine(
                    Offset(boxF.localToGlobal(Offset.zero).dx + 2, boxF.localToGlobal(Offset.zero).dy + 3),
                    Offset(boxS.localToGlobal(Offset.zero).dx + 2, boxS.localToGlobal(Offset.zero).dy + 3));
                print(coords);
              }
            }
          }
        }
      }
    }
    return winner;
  }
  void onTap(int x, int y){
    controller.forward();
    RenderBox f = keys[x][y].currentContext.findRenderObject();
    list.add(f.localToGlobal(Offset.zero));
    print(list);
    if(arrayOfBorder[y][x] == ''){
      animationsController[y][x].forward();
      if(widget.withBot != null){
        currentPlayer == 'x' ? player.play('x.mp3') :  player.play('o.mp3');
        setState(() => arrayOfBorder[y][x] = currentPlayer);
        while(!draw()){
          List<int> randomNum = [Random().nextInt(3),Random().nextInt(3)];
          if(arrayOfBorder[randomNum[0]][randomNum[1]] == ''){
            setState(() => arrayOfBorder[randomNum[0]][randomNum[1]] = widget.currPlayer == 'x' ? 'o' : 'x');
            animationsController[randomNum[0]][randomNum[1]].forward();
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
      whoWinner() == 'x' ? xWins++ : oWins++;
      widget.winCallback(xWins, oWins);
    } else if(draw()){
      widget.winCallback(xWins, oWins);
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
              key: keys[y][x],
              height: 10,
              width: 10,
              color: Colors.transparent,
            ),
          ),
          arrayOfBorder[y][x] == '' ? SizedBox() : Opacity(
            opacity: animatedIcon[y][x].value,
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
    controller = AnimationController(vsync: this,duration: Duration(milliseconds: 400));
    for(int i = 0;i < 3;i++){
      animationsController.add([]);
      animatedIcon.add([]);
      for(int j = 0;j < 3;j++){
        animationsController[i].add(AnimationController(vsync: this,duration: Duration(milliseconds: 400)));
        animatedIcon[i].add(Tween(begin: 0.0, end: 1.0).animate(animationsController[i][j])..addListener((){setState(() {});}));
      }
    }
    currentPlayer = widget.currPlayer;
    if(widget.currPlayer == 'o' && widget.withBot != null){
      List<int> random = [Random().nextInt(3),Random().nextInt(3)];
      arrayOfBorder[random[0]][random[1]] = 'x';
      animationsController[random[0]][random[1]].forward();
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
          animationsController[random[0]][random[1]].forward();
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
