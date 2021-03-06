import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/services/game_stage/finish_game.service.dart';
import 'package:fast_press/services/game_stage/original_finish_game.service.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void timeStart(
  BuildContext context,
  AudioCache soundEffect,
  double seVolume,
  ThemeItem themeItem,
  ValueNotifier<bool> timerPlayingState,
  ValueNotifier<double> remainingTimeState,
  int difficulty,
  int previousRecord,
  ValueNotifier<int> recordState,
  int themeNumber,
  int clearQuantity,
  ValueNotifier<InterstitialAd?> interstitialAdState,
  bool isOriginal,
) {
  Timer.periodic(
    const Duration(milliseconds: 100),
    (Timer timer) async {
      if (remainingTimeState.value <= 0.1 && remainingTimeState.value > 0) {
        // 終了
        if (isOriginal) {
          originalFinishGame(
            context,
            soundEffect,
            seVolume,
            themeItem,
            difficulty,
            previousRecord,
            recordState,
            themeNumber,
            clearQuantity,
            interstitialAdState,
          );
        } else {
          finishGame(
            context,
            soundEffect,
            seVolume,
            themeItem,
            difficulty,
            previousRecord,
            recordState,
            themeNumber,
            clearQuantity,
            interstitialAdState,
          );
        }

        timer.cancel();
        remainingTimeState.value = 0.100011;
      }

      if (timerPlayingState.value) {
        remainingTimeState.value -= 0.10001;

        if (remainingTimeState.value < 5 &&
            remainingTimeState.value > 0.1 &&
            ((remainingTimeState.value * 10).round() % 10 == 0)) {
          soundEffect.play(
            'sounds/time_limit.mp3',
            isNotification: true,
            volume: seVolume,
          );
        }
      }

      if (timer.isActive && remainingTimeState.value == 0) {
        timer.cancel();
      }
    },
  );
}
