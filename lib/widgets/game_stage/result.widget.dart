import 'package:audioplayers/audioplayers.dart';
import 'package:fast_press/data/game_themes.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/screens/game_play.screen.dart';
import 'package:fast_press/screens/stage_select.screen.dart';
import 'package:fast_press/widgets/game_stage/give_up.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Result extends HookWidget {
  final BuildContext screenContext;
  final AudioCache soundEffect;
  final double seVolume;
  final ThemeItem themeItem;
  final int difficulty;
  final int highRecord;
  final int previousRecord;
  final int record;
  final bool isGreaterRecord;
  final int clearQuantity;
  final int themeNumber;
  final bool nextOpen;
  final bool giveUpOk;
  final bool isCleared;
  final int thisWR;
  final bool isWR;
  final bool isOriginal;

  const Result({
    Key? key,
    required this.screenContext,
    required this.soundEffect,
    required this.seVolume,
    required this.themeItem,
    required this.difficulty,
    required this.highRecord,
    required this.previousRecord,
    required this.record,
    required this.isGreaterRecord,
    required this.clearQuantity,
    required this.themeNumber,
    required this.nextOpen,
    required this.giveUpOk,
    required this.isCleared,
    required this.thisWR,
    required this.isWR,
    required this.isOriginal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayResultState = useState<bool>(true);
    final displayGiveUpState = useState<bool>(false);
    final clearWord = isCleared ? 'Cleared!' : 'Not Cleared...';
    final ValueNotifier<RewardedAd?> rewardedAdState = useState(null);

    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 15,
        right: 15,
        bottom: 25,
      ),
      child: displayResultState.value
          ? AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: displayResultState.value ? 1 : 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: <Widget>[
                          Text(
                            clearWord,
                            style: TextStyle(
                              fontSize: 23,
                              fontStyle: FontStyle.italic,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 0.7
                                ..color = isCleared
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                            ),
                          ),
                          Text(
                            clearWord,
                            style: TextStyle(
                              fontSize: 23,
                              fontStyle: FontStyle.italic,
                              color: isCleared
                                  ? Colors.green
                                  : Colors.red.shade300,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'テーマ',
                        style: TextStyle(
                          fontSize: 19,
                          color: isOriginal
                              ? Colors.pink.shade600
                              : difficulty == 1
                                  ? Colors.blue.shade600
                                  : difficulty == 2
                                      ? Colors.deepOrange.shade500
                                      : Colors.deepPurple.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .86 > 550
                            ? 400
                            : MediaQuery.of(context).size.width * .70,
                        child: Center(
                          child: Stack(
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
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'クリア条件',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                '今回記録',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                '最高記録',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              isOriginal
                                  ? Container()
                                  : const Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        '世界記録',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
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
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$record 回',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '$highRecord 回',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isGreaterRecord
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                              isOriginal
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        thisWR != 0 ? '$thisWR 回' : '-　',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              isWR ? Colors.red : Colors.black,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    children: [
                      SizedBox(
                        width: 60,
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
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 2.5),
                            child: Text('戻る'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      SizedBox(
                        width: 90,
                        height: 35,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade700,
                            padding: const EdgeInsets.only(
                              bottom: 2,
                            ),
                            shape: const StadiumBorder(),
                            side: BorderSide(
                              width: 2,
                              color: Colors.orange.shade800,
                            ),
                          ),
                          onPressed: () {
                            soundEffect.play(
                              'sounds/tap.mp3',
                              isNotification: true,
                              volume: seVolume,
                            );

                            Navigator.of(screenContext).pushReplacementNamed(
                              GamePlayScreen.routeName,
                              arguments: [
                                themeItem,
                                difficulty,
                                highRecord,
                                themeNumber,
                              ],
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 2.5),
                            child: Text(
                              'もう一回',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: nextOpen || giveUpOk ? 20 : 0),
                  nextOpen || giveUpOk
                      ? Wrap(
                          children: [
                            Opacity(
                              opacity: nextOpen ? 1 : 0,
                              child: SizedBox(
                                width: 60,
                                height: 35,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue.shade600,
                                    padding: const EdgeInsets.only(
                                      bottom: 2,
                                    ),
                                    shape: const StadiumBorder(),
                                    side: BorderSide(
                                      width: 2,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  onPressed: () {
                                    soundEffect.play(
                                      'sounds/tap.mp3',
                                      isNotification: true,
                                      volume: seVolume,
                                    );

                                    Navigator.popUntil(
                                      screenContext,
                                      ModalRoute.withName(
                                        StageSelectScreen.routeName,
                                      ),
                                    );

                                    Navigator.of(screenContext).pushNamed(
                                      GamePlayScreen.routeName,
                                      arguments: [
                                        gameThemes[themeNumber],
                                        difficulty,
                                        0,
                                        themeNumber + 1,
                                      ],
                                    );
                                  },
                                  child: const Text(
                                    '次へ',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Opacity(
                              opacity: giveUpOk ? 1 : 0,
                              child: SizedBox(
                                width: 90,
                                height: 35,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.purple,
                                    padding: const EdgeInsets.only(
                                      bottom: 2,
                                    ),
                                    shape: const StadiumBorder(),
                                    side: BorderSide(
                                      width: 2,
                                      color: Colors.purple.shade700,
                                    ),
                                  ),
                                  onPressed: () async {
                                    soundEffect.play(
                                      'sounds/tap.mp3',
                                      isNotification: true,
                                      volume: seVolume,
                                    );
                                    displayResultState.value = false;

                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );
                                    displayGiveUpState.value = true;
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 2.5),
                                    child: Text(
                                      'もうだめ',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            )
          : GiveUp(
              screenContext: screenContext,
              soundEffect: soundEffect,
              seVolume: seVolume,
              difficulty: difficulty,
              themeNumber: themeNumber,
              displayResultState: displayResultState,
              displayGiveUpState: displayGiveUpState,
              rewardedAdState: rewardedAdState,
            ),
    );
  }
}
