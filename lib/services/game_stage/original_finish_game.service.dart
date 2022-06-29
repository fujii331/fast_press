import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/services/admob/interstitial_action.service.dart';
import 'package:fast_press/widgets/game_stage/result.widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/widgets/game_stage/finish_modal.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void originalFinishGame(
  BuildContext context,
  AudioCache soundEffect,
  double seVolume,
  ThemeItem themeItem,
  int difficulty,
  int previousRecord,
  ValueNotifier<int> recordState,
  int themeNumber,
  int clearQuantity,
  ValueNotifier<InterstitialAd?> interstitialAdState,
) async {
  showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const FinishModal();
    },
  );

  final index = context
      .read(originalThemeTitlesProvider)
      .state
      .indexOf(themeItem.themeWord);

  // クリア判定
  final isGreaterRecord = recordState.value > previousRecord;
  final highRecord = isGreaterRecord ? recordState.value : previousRecord;
  final isCleared = recordState.value >= clearQuantity;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 記録更新判定
  if (isGreaterRecord) {
    if (difficulty == 1) {
      context.read(originalNormalRecordsProvider).state[index] =
          recordState.value.toString();

      prefs.setStringList('originalNormalRecords',
          context.read(originalNormalRecordsProvider).state);
    } else if (difficulty == 2) {
      context.read(originalHardRecordsProvider).state[index] =
          recordState.value.toString();

      prefs.setStringList('originalHardRecords',
          context.read(originalHardRecordsProvider).state);
    } else if (difficulty == 3) {
      context.read(originalVeryHardRecordsProvider).state[index] =
          recordState.value.toString();

      prefs.setStringList('originalVeryHardRecords',
          context.read(originalVeryHardRecordsProvider).state);
    }
  }

  context.read(rebuildProvider).state = !context.read(rebuildProvider).state;

  await Future.delayed(
    const Duration(milliseconds: 2500),
  );

  if (isCleared) {
    soundEffect.play(
      'sounds/clear.mp3',
      isNotification: true,
      volume: seVolume,
    );
  } else {
    if (interstitialAdState.value != null) {
      // 広告を表示する
      showInterstitialAd(
        context,
        interstitialAdState,
      );
    }

    await Future.delayed(
      const Duration(milliseconds: 1000),
    );
  }

  AwesomeDialog(
    context: context,
    dialogType: DialogType.NO_HEADER,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    showCloseIcon: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 500 ? 500 : null,
    borderSide: BorderSide(
      color: difficulty == 1
          ? Colors.blue.shade800
          : difficulty == 2
              ? Colors.orange.shade800
              : Colors.purple.shade800,
      width: 2,
    ),
    body: Result(
      screenContext: context,
      soundEffect: soundEffect,
      seVolume: seVolume,
      themeItem: themeItem,
      difficulty: difficulty,
      highRecord: highRecord,
      previousRecord: previousRecord,
      record: recordState.value,
      isGreaterRecord: isGreaterRecord,
      clearQuantity: clearQuantity,
      themeNumber: themeNumber,
      nextOpen: false,
      giveUpOk: false,
      isCleared: isCleared,
      thisWR: 0,
      isWR: false,
      isOriginal: true,
    ),
  ).show();
}
