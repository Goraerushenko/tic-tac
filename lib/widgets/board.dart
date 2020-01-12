import 'package:flutter/material.dart';
import 'package:tic_tac/models/board-model.dart';
import 'package:tic_tac/widgets/cell.dart';
import 'dart:math';

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
  List<AnimationController> _animationsController = [];
  List<Animation<dynamic>> _animatedIcon = [];

  Board _board = Board();
  String _currentPlayer = 'x';

  void clearBoard(){
    widget.clearIsStarted();
    _currentPlayer = widget.currPlayer;
    for(int i = 0; i < 9; i++) {
      if (_animationsController[i].status == AnimationStatus.completed) {
        _animationsController[i].reverse();
      }
    }
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _board = Board();
        _board.currentPlayer = widget.currPlayer;
      });
    });
  }

  bool draw() => _board.isDraw;


  void _onTap(int i) {
    final _randomNum = Random().nextInt(9);
    _controller.forward();
    if(_board[i].isEmptyCell) {
      _animationsController[i].forward();
      if(widget.withBot != null) {
        _board.currentSound;
        setState(() {
          _board.currentPlayer = _currentPlayer;
          _board[i].cell = _currentPlayer;
        });
        while(!draw()) {
          if(_board[_randomNum].isEmptyCell){
            setState(() =>
              _board[_randomNum].cell = widget.currPlayer == 'x' ? 'o' : 'x'
            );
            _animationsController[_randomNum].forward();
            break;
          }
        }
      } else {
        setState(() {
          _board[i].cell = _currentPlayer;
          _currentPlayer == 'x' ? _currentPlayer = 'o' : _currentPlayer = 'x';
          _board.currentPlayer = _currentPlayer;
        });
      }
      widget.whoseMove(_currentPlayer);
    }
    final _isWinner = _board.isWinner(_currentPlayer);
    if(_isWinner != null) {
      _currentPlayer == 'x' ? _xWins++ : _oWins++;
      widget.winCallback(_xWins, _oWins);
      widget.drawALine(_isWinner[0], _isWinner[1]);
    } else if(draw()) {
      widget.winCallback(_xWins, _oWins);

      if (widget.currPlayer == 'o' && widget.withBot != null) {
        _board[_randomNum].cell = 'x';
      }
    }
  }

  void _isOPlayer() {
    if(widget.currPlayer == 'o' && widget.withBot != null){
      int _random1 = Random().nextInt(9);

      _board[_random1].cell = 'x';
      _animationsController[_random1].forward();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400)
    );
      for(int j = 0; j < 9; j++){
        _animationsController.add(
          AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 400)
          )
        );
        _animatedIcon.add(Tween(
          begin: 0.0,
          end: 1.0
        ).animate(_animationsController[j])
        ..addListener((){setState(() {});}));
      }
    _currentPlayer = widget.currPlayer;
    _isOPlayer();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.reverse){
      clearBoard();
      Future.delayed(Duration(milliseconds: 500), (){
        _isOPlayer();
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
                      CellWidget(
                        onTap: () => _onTap(0),
                        cell: _board[0],
                        animatedIcon: _animatedIcon[0],
                      ),
                      CellWidget(
                        onTap: () => _onTap(1),
                        cell: _board[1],
                        animatedIcon: _animatedIcon[1],
                        left: true,
                        right: true,
                      ),
                      CellWidget(
                        onTap: () => _onTap(2),
                        cell: _board[2],
                        animatedIcon: _animatedIcon[2],
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      CellWidget(
                        onTap: () => _onTap(3),
                        cell: _board[3],
                        animatedIcon: _animatedIcon[3],
                      ),
                      CellWidget(
                        onTap: () => _onTap(4),
                        cell: _board[4],
                        animatedIcon: _animatedIcon[4],
                        left: true,
                        right: true,
                      ),
                      CellWidget(
                        onTap: () => _onTap(5),
                        cell: _board[5],
                        animatedIcon: _animatedIcon[5],
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      CellWidget(
                        onTap: () => _onTap(6),
                        cell: _board[6],
                        animatedIcon: _animatedIcon[6],
                        bottom: false,
                      ),
                      CellWidget(
                        onTap: () => _onTap(7),
                        cell: _board[7],
                        animatedIcon: _animatedIcon[7],
                        left: true,
                        right: true,
                        bottom: false,
                      ),
                      CellWidget(
                        onTap: () => _onTap(8),
                        cell: _board[8],
                        animatedIcon: _animatedIcon[8],
                        bottom: false,
                      ),
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
