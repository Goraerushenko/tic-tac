import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/components/btn.dart';
import 'package:tic_tac/components/logo.dart';
import 'package:tic_tac/pages/game.dart';
import 'package:tic_tac/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'picker.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  AudioCache  player = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.65],
                colors: [
                  MyTheme.orange,
                  MyTheme.red,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Tic Tac',style: TextStyle(fontFamily: 'DancingScript',fontSize: 60,color: Colors.white),),
                      Logo()
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Btn(
                          callBack: (){
                            player.play("click.mp3");
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => PickerPage(),
                              ),
                            );
                          },
                          child: Text(
                            'SINGLE PLAYER',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black.withOpacity(.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Btn(
                          callBack: (){
                            player.play("click.mp3");
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => Game(currPlayer: 'x',),),
                            );
                          },
                          child: Text(
                            'WITH A FRIEND',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black.withOpacity(.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
