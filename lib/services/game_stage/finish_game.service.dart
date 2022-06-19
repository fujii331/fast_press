import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_press/data/game_themes.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/models/word_record.model.dart';
import 'package:fast_press/services/admob/interstitial_action.service.dart';
import 'package:fast_press/widgets/game_stage/result.widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  ValueNotifier<InterstitialAd?> interstitialAdState,
) async {
  showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const FinishModal();
    },
  );

  bool isWR = false;

  final WorldRecord worldRecord = context.read(wordRecordProvider).state;
  Map<int, int> difficultyWR = difficulty == 1
      ? worldRecord.normal
      : difficulty == 2
          ? worldRecord.hard
          : worldRecord.veryHard;
  int thisWR = difficultyWR[themeNumber] ?? 0;
  final String targetDifficulty = difficulty == 1
      ? 'normal'
      : difficulty == 2
          ? 'hard'
          : 'veryHard';

  // WRを超えていた場合
  if (recordState.value > thisWR) {
    DatabaseReference firebaseInstance = FirebaseDatabase.instance
        .ref()
        .child('worldRecord/$targetDifficulty/$themeNumber');

    await firebaseInstance.get().then((DataSnapshot? snapshot) {
      if (snapshot != null) {
        final Map firebaseData = snapshot.value as Map;

        final int bestRecord = firebaseData['bestRecord'] as int;

        if (recordState.value > bestRecord) {
          firebaseInstance.set({
            'bestRecord': recordState.value,
          });

          thisWR = recordState.value;
          isWR = true;

          difficultyWR[themeNumber] = thisWR;
          context.read(wordRecordProvider).state = WorldRecord(
            normal: difficulty == 1 ? difficultyWR : worldRecord.normal,
            hard: difficulty == 2 ? difficultyWR : worldRecord.hard,
            veryHard: difficulty == 3 ? difficultyWR : worldRecord.veryHard,
          );
        } else {
          thisWR = bestRecord;
        }
      }
    }).onError((error, stackTrace) =>
        // 何もしない
        null);
  }

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
        normalClearedNumber < gameThemes.length) {
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

    if (themeNumber <= hardClearedNumber &&
        hardClearedNumber < gameThemes.length) {
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
        veryHardClearedNumber < gameThemes.length) {
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
      thisWR: thisWR,
      isWR: isWR,
    ),
  ).show();
}
