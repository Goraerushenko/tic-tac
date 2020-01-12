import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/pages/game.dart';
import 'package:tic_tac/theme/theme.dart';
import 'package:tic_tac/widgets/btn.dart';
import 'package:tic_tac/widgets/o.dart';
import 'package:tic_tac/widgets/x.dart';

class PickerPage extends StatefulWidget {
  @override
  _PickerPageState createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  AudioCache  player = AudioCache();
  String groupValue = 'x';

  void switchValue(el){
    player.play(el == 'x' ? "x.mp3" : "o.mp3");
    setState(() => groupValue = el);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              iconSize: 30,
              icon: Icon(Icons.home,),
              color: Colors.black,
              onPressed: (){
                player.play("click.mp3");
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
                  mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Pic Your Side',
                      style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            OIcon(
                              size: 100,
                            ),
                            Radio(
                              value: 'o',
                              groupValue: groupValue,
                              onChanged: (el){switchValue(el);},
                              activeColor: MyTheme.green,
                            ),
                            Text(
                              'Second',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            XIcon(
                              size: 100,
                            ),
                            Radio(
                              value: 'x',
                              groupValue: groupValue,
                              onChanged: (el){switchValue(el);},
                              activeColor: MyTheme.orange,
                            ),
                            Text(
                              'First',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ),
                        ),
                      ],
                        ),
                      ],
                    ),
                    Btn(
                      gradient: [MyTheme.red, MyTheme.orange],
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      callBack: (){
                        player.play('click.mp3');
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Game(
                              currPlayer: groupValue,
                              withBot: true,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
