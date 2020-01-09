import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/components/board.dart';
import 'package:tic_tac/components/customLine.dart';
import 'package:tic_tac/components/o.dart';
import 'package:tic_tac/components/x.dart';

class Game extends StatefulWidget {
  Game({
    Key key,
    this.currPlayer,
    this.withBot
  }): super(key: key);
  final bool withBot;
  final String currPlayer;
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin{
  AudioCache  player = AudioCache();
  int xWins = 0;
  int oWins = 0;
  bool pressed = false;
  AnimationController fController;
  AnimationController sController;
  Animation<Color> firstPlayer;
  Animation<Color> secondPlayer;
  Animation<double> btnAnimation;
  Animation<double> opacityAnimation;
  AnimationController btnController;
  AnimationController lineController;
  Animation<Offset> lineAnimation;
  List<Offset> coords = [];
  @override
  void initState() {
    btnController = AnimationController(vsync: this,duration: Duration(milliseconds: 400));
    btnAnimation = Tween(begin: 0.0,end: 0.16).animate(btnController)..addListener((){setState((){});});
    opacityAnimation = Tween(begin: 0.0,end: 1.0).animate(btnController)..addListener((){setState((){});});
    sController = AnimationController(vsync: this,duration: Duration(milliseconds: 350));
    fController = AnimationController(vsync: this,duration: Duration(milliseconds: 350));
    firstPlayer = ColorTween(begin: Colors.black,end: Colors.green).animate(fController)..addListener((){setState(() {});});
    secondPlayer = ColorTween(begin: Colors.black,end: Colors.green).animate(sController)..addListener((){setState(() {});});
    widget.currPlayer == 'x' ? fController.forward() : sController.forward();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () =>  null,
        child: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: 1,
                  child: Align(
                    alignment: Alignment(-btnAnimation.value,1),
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.home,),
                      color: Colors.black,
                      onPressed: (){
                        player.play("click.mp3");
                        btnController.forward();
                        Navigator.of(context).pop();
                        widget.withBot != null ? Navigator.of(context).pop() : null;
                      },
                    ),
                  ),
                ),
               btnController.status == AnimationStatus.dismissed ? SizedBox() :
                Opacity(
                  opacity: opacityAnimation.value,
                  child: Align(
                    alignment: Alignment(btnAnimation.value,1),
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.replay,),
                      color: Colors.black,
                      onPressed: (){
                        player.play("click.mp3");
                        btnController.reverse();
                        lineController.reverse();
                        setState(() => pressed = true);
                        Future.delayed(Duration(milliseconds: 400), () => setState(() => coords = []));
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 1.0, // has the effect of softening the shadow
                              spreadRadius: 0.3, // has the effect of extending the shadow
                              offset: Offset(
                                1.0, // horizontal, move right 10
                                1.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$xWins',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black.withOpacity(.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          XIcon(
                            size: 30,
                          ),
                          SizedBox(width: 16,),
                          Text(
                            'Player',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: firstPlayer.value,
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Board(
                    clearIsStarted: (){
                      pressed = false;
                    },
                    drawALine: (firstPos, secondPos){
                      coords.insert(0, secondPos);
                      coords.insert(0, firstPos);
                      lineController = AnimationController(vsync: this,duration: Duration(milliseconds: 400));
                      lineAnimation = Tween(begin: firstPos,end: secondPos).animate(lineController)
                        ..addListener(() => setState(() => coords[1] = lineAnimation.value));
                      lineController.forward();
                    },
                    reverse: pressed,
                    currPlayer: widget.currPlayer,
                    withBot: widget.withBot,
                    whoseMove: (move){
                      if(move == 'x'){
                        fController.forward();
                        sController.reverse();
                      } else {
                        fController.reverse();
                        sController.forward();
                      }
                    },
                    winCallback: (x, o){
                      setState(() {
                        xWins = x;
                        oWins = o;
                      });
                      btnController.forward();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          OIcon(
                            size: 30,
                          ),
                          SizedBox(width: 16,),
                          Text(
                            'Player',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: secondPlayer.value,
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 1.0, // has the effect of softening the shadow
                              spreadRadius: 0.3, // has the effect of extending the shadow
                              offset: Offset(
                                1.0, // horizontal, move right 10
                                1.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$oWins',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black.withOpacity(.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            coords.length > 1 ? PainterOfLine(
              start: coords[0],
              end: coords[1],
            ): SizedBox()
          ],
        ),
      ),
    );
  }
}
