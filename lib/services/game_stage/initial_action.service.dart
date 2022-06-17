import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/services/game_stage/time_start.service.dart';
import 'package:fast_press/widgets/game_stage/ready_modal.widget.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void initialAction(
  BuildContext context,
  ValueNotifier<bool> timerPlayingState,
  ValueNotifier<double> remainingTimeState,
  ThemeItem themeItem,
  AudioCache soundEffect,
  double seVolume,
  int difficulty,
  int previousRecord,
  ValueNotifier<int> recordState,
  int themeNumber,
  int clearQuantity,
) async {
  // カウントダウン表示
  showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const ReadyModal();
    },
  );

  await Future.delayed(
    const Duration(milliseconds: 3650),
  );

  Navigator.pop(context);

  soundEffect.play(
    'sounds/start.mp3',
    isNotification: true,
    volume: seVolume,
  );

  timerPlayingState.value = true;

  timeStart(
    context,
    soundEffect,
    seVolume,
    themeItem,
    timerPlayingState,
    remainingTimeState,
    difficulty,
    previousRecord,
    recordState,
    themeNumber,
    clearQuantity,
  );
}
