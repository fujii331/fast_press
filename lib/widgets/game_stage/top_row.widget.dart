import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/widgets/game_stage/explanation.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TopRow extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final ThemeItem themeItem;
  final int difficulty;
  final int previousRecord;
  final ValueNotifier<bool> timerPlayingState;
  final ValueNotifier<double> remainingTimeState;
  final ValueNotifier<int> recordState;
  final int themeNumber;
  final bool recordMinus;
  final ValueNotifier<InterstitialAd?> interstitialAdState;
  final bool isOriginal;

  const TopRow({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
    required this.themeItem,
    required this.difficulty,
    required this.previousRecord,
    required this.timerPlayingState,
    required this.remainingTimeState,
    required this.recordState,
    required this.themeNumber,
    required this.recordMinus,
    required this.interstitialAdState,
    required this.isOriginal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width > 450
        ? 400
        : MediaQuery.of(context).size.width * 0.95;
    return Container(
      color: Colors.grey.shade900.withOpacity(0.8),
      width: width,
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Icon(
            Icons.circle_outlined,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            recordState.value.toString(),
            style: TextStyle(
              color: recordMinus ? Colors.red.shade300 : Colors.white,
              fontSize: 23,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.timer_outlined,
            color: Colors.white,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            remainingTimeState.value.toStringAsFixed(1),
            style: TextStyle(
              color: remainingTimeState.value < 5
                  ? Colors.red.shade300
                  : Colors.white,
              fontSize: 23,
            ),
          ),
          const Spacer(),
          IconButton(
            iconSize: 30,
            icon: Icon(
              Icons.pause_circle,
              color: Colors.orange.shade300,
            ),
            onPressed: timerPlayingState.value
                ? () {
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    timerPlayingState.value = false;

                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      headerAnimationLoop: false,
                      dismissOnTouchOutside: false,
                      dismissOnBackKeyPress: false,
                      showCloseIcon: false,
                      animType: AnimType.SCALE,
                      width: MediaQuery.of(context).size.width * .86 > 550
                          ? 550
                          : null,
                      body: Explanation(
                        screenContext: context,
                        soundEffect: soundEffect,
                        seVolume: seVolume,
                        themeItem: themeItem,
                        difficulty: difficulty,
                        recordState: recordState,
                        previousRecord: previousRecord,
                        timerPlayingState: timerPlayingState,
                        remainingTimeState: remainingTimeState,
                        isInitial: false,
                        themeNumber: themeNumber,
                        interstitialAdState: interstitialAdState,
                        isOriginal: isOriginal,
                      ),
                    ).show();
                  }
                : () {},
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
