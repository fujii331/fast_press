import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_press/data/themes.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/widgets/game_stage/result.widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/widgets/game_stage/finish_modal.widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void finishGame(
  BuildContext context,
  AudioCache soundEffect,
  double seVolume,
  ThemeItem themeItem,
  int difficulty,
  int previousRecord,
  ValueNotifier<int> recordState,
  int themeNumber,
  int clearQuantity,
) async {
  showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const FinishModal();
    },
  );

  // クリア判定
  final isGreaterRecord = recordState.value > previousRecord;
  final highRecord = isGreaterRecord ? recordState.value : previousRecord;
  final isCleared = recordState.value >= clearQuantity;
  bool nextOpen = false;
  bool giveUpOk = false;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (difficulty == 1) {
    // 記録更新判定
    if (isGreaterRecord) {
      if (context.read(normalRecordsProvider).state.length >= themeNumber) {
        context.read(normalRecordsProvider).state[themeNumber - 1] =
            recordState.value.toString();
      } else {
        context
            .read(normalRecordsProvider)
            .state
            .add(recordState.value.toString());
      }

      prefs.setStringList(
          'normalRecords', context.read(normalRecordsProvider).state);

      // まだクリアしたことない問題でクリアした場合
      if (isCleared &&
          themeNumber > context.read(normalClearedNumberProvider).state) {
        context.read(normalClearedNumberProvider).state = themeNumber;
        prefs.setInt('normalClearedNumber',
            context.read(normalClearedNumberProvider).state);
      }
    }
    final normalClearedNumber = context.read(normalClearedNumberProvider).state;

    if (themeNumber <= normalClearedNumber &&
        normalClearedNumber < themes.length) {
      // 次の問題に進むボタンを出すか判定
      nextOpen = true;
    } else if (themeNumber > normalClearedNumber &&
        previousRecord != 0 &&
        !isCleared) {
      // 諦めるボタンを出すか判定
      giveUpOk = true;
    }
  } else if (difficulty == 2) {
    if (isGreaterRecord) {
      if (context.read(hardRecordsProvider).state.length >= themeNumber) {
        context.read(hardRecordsProvider).state[themeNumber - 1] =
            recordState.value.toString();
      } else {
        context
            .read(hardRecordsProvider)
            .state
            .add(recordState.value.toString());
      }

      prefs.setStringList(
          'hardRecords', context.read(hardRecordsProvider).state);

      if (isCleared &&
          themeNumber > context.read(hardClearedNumberProvider).state) {
        context.read(hardClearedNumberProvider).state = themeNumber;
        prefs.setInt(
            'hardClearedNumber', context.read(hardClearedNumberProvider).state);
      }
    }

    final hardClearedNumber = context.read(hardClearedNumberProvider).state;

    if (themeNumber <= hardClearedNumber && hardClearedNumber < themes.length) {
      nextOpen = true;
    } else if (themeNumber > hardClearedNumber &&
        previousRecord != 0 &&
        !isCleared) {
      giveUpOk = true;
    }
  } else if (difficulty == 3) {
    if (isGreaterRecord) {
      if (context.read(veryHardRecordsProvider).state.length >= themeNumber) {
        context.read(veryHardRecordsProvider).state[themeNumber - 1] =
            recordState.value.toString();
      } else {
        context
            .read(veryHardRecordsProvider)
            .state
            .add(recordState.value.toString());
      }

      prefs.setStringList(
          'veryHardRecords', context.read(veryHardRecordsProvider).state);

      if (isCleared &&
          themeNumber > context.read(veryHardClearedNumberProvider).state) {
        context.read(veryHardClearedNumberProvider).state = themeNumber;
        prefs.setInt('veryHardClearedNumber',
            context.read(veryHardClearedNumberProvider).state);
      }
    }

    final veryHardClearedNumber =
        context.read(veryHardClearedNumberProvider).state;

    if (themeNumber <= veryHardClearedNumber &&
        veryHardClearedNumber < themes.length) {
      nextOpen = true;
    } else if (themeNumber > veryHardClearedNumber &&
        previousRecord != 0 &&
        !isCleared) {
      giveUpOk = true;
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
    // 広告を表示
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
          ? Colors.green.shade800
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
      nextOpen: nextOpen,
      giveUpOk: giveUpOk,
      isCleared: isCleared,
    ),
  ).show();
}
