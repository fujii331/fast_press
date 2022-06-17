import 'package:audioplayers/audioplayers.dart';
import 'package:fast_press/data/themes.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/screens/game_play.screen.dart';
import 'package:fast_press/screens/stage_select.screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GiveUp extends HookWidget {
  final BuildContext screenContext;
  final AudioCache soundEffect;
  final double seVolume;
  final int difficulty;
  final int themeNumber;
  final ValueNotifier<bool> displayResultState;
  final ValueNotifier<bool> displayGiveUpState;

  const GiveUp({
    Key? key,
    required this.screenContext,
    required this.soundEffect,
    required this.seVolume,
    required this.difficulty,
    required this.themeNumber,
    required this.displayResultState,
    required this.displayGiveUpState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: displayGiveUpState.value ? 1 : 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                '諦めて次の問題へ...',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Text(
                  '短い広告を見てこの問題をスキップしますか？',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'SawarabiGothic',
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
                      onPressed: () async {
                        soundEffect.play(
                          'sounds/cancel.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );

                        displayGiveUpState.value = false;
                        await Future.delayed(
                          const Duration(milliseconds: 100),
                        );
                        displayResultState.value = true;
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 2.5),
                        child: Text('見ない'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 60,
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.only(
                          bottom: 2,
                        ),
                        shape: const StadiumBorder(),
                        side: BorderSide(
                          width: 2,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );

                        // 広告を見せる
                        if (difficulty == 1) {
                          if (context.read(normalRecordsProvider).state.length <
                              themeNumber) {
                            context.read(normalRecordsProvider).state.add('0');
                          }

                          prefs.setStringList('normalRecords',
                              context.read(normalRecordsProvider).state);

                          context.read(normalClearedNumberProvider).state =
                              themeNumber;
                          prefs.setInt('normalClearedNumber', themeNumber);
                        } else if (difficulty == 2) {
                          if (context.read(hardRecordsProvider).state.length <
                              themeNumber) {
                            context.read(hardRecordsProvider).state.add('0');
                          }
                          prefs.setStringList('hardRecords',
                              context.read(hardRecordsProvider).state);

                          context.read(hardClearedNumberProvider).state =
                              themeNumber;
                          prefs.setInt('hardClearedNumber', themeNumber);
                        } else if (difficulty == 3) {
                          if (context
                                  .read(veryHardRecordsProvider)
                                  .state
                                  .length <
                              themeNumber) {
                            context
                                .read(veryHardRecordsProvider)
                                .state
                                .add('0');
                          }
                          prefs.setStringList('veryHardRecords',
                              context.read(veryHardRecordsProvider).state);

                          context.read(veryHardClearedNumberProvider).state =
                              themeNumber;
                          prefs.setInt('veryHardClearedNumber', themeNumber);
                        }

                        context.read(rebuildProvider).state =
                            !context.read(rebuildProvider).state;

                        Navigator.popUntil(
                          screenContext,
                          ModalRoute.withName(
                            StageSelectScreen.routeName,
                          ),
                        );

                        Navigator.of(screenContext).pushNamed(
                          GamePlayScreen.routeName,
                          arguments: [
                            themes[themeNumber],
                            difficulty,
                            0,
                            themeNumber + 1,
                          ],
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 2.5),
                        child: Text(
                          '見る',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
