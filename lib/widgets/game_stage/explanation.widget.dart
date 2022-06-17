import 'package:audioplayers/audioplayers.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/screens/game_play.screen.dart';
import 'package:fast_press/screens/stage_select.screen.dart';
import 'package:fast_press/services/game_stage/initial_action.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Explanation extends HookWidget {
  final BuildContext screenContext;
  final AudioCache soundEffect;
  final double seVolume;
  final ThemeItem themeItem;
  final int difficulty;
  final int previousRecord;
  final ValueNotifier<int> recordState;
  final ValueNotifier<bool> timerPlayingState;
  final ValueNotifier<double> remainingTimeState;
  final bool isInitial;
  final int themeNumber;

  const Explanation({
    Key? key,
    required this.screenContext,
    required this.soundEffect,
    required this.seVolume,
    required this.themeItem,
    required this.difficulty,
    required this.previousRecord,
    required this.recordState,
    required this.timerPlayingState,
    required this.remainingTimeState,
    required this.isInitial,
    required this.themeNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNormal = difficulty == 1;
    final clearQuantity = themeItem.clearQuantity - 20; // + (isNormal ? 0 : 5);

    return Padding(
      padding: EdgeInsets.only(
        top: isInitial ? 8 : 0,
        left: 15,
        right: 15,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isInitial
                  ? Container()
                  : Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          height: 25,
                          width: 20,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            iconSize: 24,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              timerPlayingState.value = true;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
              Text(
                'テーマ',
                style: TextStyle(
                  fontSize: 19,
                  color: difficulty == 1
                      ? Colors.teal.shade600
                      : difficulty == 2
                          ? Colors.deepOrange.shade500
                          : Colors.deepPurple.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Stack(
                children: <Widget>[
                  Text(
                    themeItem.themeWord,
                    style: TextStyle(
                      fontSize: 21,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.7
                        ..color = Colors.blueGrey.shade800,
                    ),
                  ),
                  Text(
                    themeItem.themeWord,
                    style: const TextStyle(
                      fontSize: 21,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.8,
                          color: Colors.grey.shade700,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        themeItem.themeRule,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'ルール',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'クリア条件',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '最高記録',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$clearQuantity 回',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$previousRecord 回',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Wrap(
            children: [
              SizedBox(
                width: 75,
                height: 35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade500,
                    padding: const EdgeInsets.only(
                      bottom: 2,
                    ),
                    shape: const StadiumBorder(),
                    side: BorderSide(
                      width: 2,
                      color: Colors.red.shade600,
                    ),
                  ),
                  onPressed: () {
                    soundEffect.play(
                      'sounds/cancel.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );

                    Navigator.popUntil(
                      screenContext,
                      ModalRoute.withName(StageSelectScreen.routeName),
                    );

                    if (!isInitial) {
                      // タイマーをストップ
                      remainingTimeState.value = 0;
                      // 広告を入れる

                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 2.5),
                    child: Text('やめる'),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(
                width: isInitial ? 75 : 90,
                height: 35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: isInitial
                        ? Colors.blue.shade600
                        : Colors.orange.shade700,
                    padding: const EdgeInsets.only(
                      bottom: 2,
                    ),
                    shape: const StadiumBorder(),
                    side: BorderSide(
                      width: 2,
                      color: isInitial
                          ? Colors.blue.shade700
                          : Colors.orange.shade800,
                    ),
                  ),
                  onPressed: isInitial
                      ? () {
                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );

                          Navigator.pop(screenContext);

                          initialAction(
                            screenContext,
                            timerPlayingState,
                            remainingTimeState,
                            themeItem,
                            soundEffect,
                            seVolume,
                            difficulty,
                            previousRecord,
                            recordState,
                            themeNumber,
                            clearQuantity,
                          );
                        }
                      : () {
                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );
                          remainingTimeState.value = 0;

                          // 広告を入れる

                          Navigator.of(screenContext).pushReplacementNamed(
                            GamePlayScreen.routeName,
                            arguments: [
                              themeItem,
                              difficulty,
                              previousRecord,
                              themeNumber,
                            ],
                          );
                        },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.5),
                    child: Text(isInitial ? '始める' : 'もう一回'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}