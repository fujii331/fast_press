import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/models/word_record.model.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void firstSetting(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  context.read(normalClearedNumberProvider).state =
      prefs.getInt('normalClearedNumber') ?? 0;

  context.read(hardClearedNumberProvider).state =
      prefs.getInt('hardClearedNumber') ?? 0;

  context.read(veryHardClearedNumberProvider).state =
      prefs.getInt('veryHardClearedNumber') ?? 0;

  context.read(normalRecordsProvider).state =
      prefs.getStringList('normalRecords') ?? [];

  context.read(hardRecordsProvider).state =
      prefs.getStringList('hardRecords') ?? [];

  context.read(veryHardRecordsProvider).state =
      prefs.getStringList('veryHardRecords') ?? [];

  context.read(originalNormalRecordsProvider).state =
      prefs.getStringList('originalNormalRecords') ?? [];

  context.read(originalHardRecordsProvider).state =
      prefs.getStringList('originalHardRecords') ?? [];

  context.read(originalVeryHardRecordsProvider).state =
      prefs.getStringList('originalVeryHardRecords') ?? [];

  // 音量設定
  final double? bgmVolume = prefs.getDouble('bgmVolume');
  final double? seVolume = prefs.getDouble('seVolume');

  if (bgmVolume != null) {
    context.read(bgmVolumeProvider).state = bgmVolume;
  } else {
    prefs.setDouble('bgmVolume', 0.2);
  }
  if (seVolume != null) {
    context.read(seVolumeProvider).state = seVolume;
  } else {
    prefs.setDouble('seVolume', 0.5);
  }

  context
      .read(bgmProvider)
      .state
      .setVolume(context.read(bgmVolumeProvider).state);

  // タイトル一覧からprefsにアクセス
  // タイトルをキーにして作成していく
  final titles = context.read(originalThemeTitlesProvider).state =
      prefs.getStringList('originalThemeTitles') ?? [];

  final themeItems = <ThemeItem>[];

  for (String title in titles) {
    final themeItemContents = prefs.getStringList('original-$title') ?? [];

    if (themeItemContents.isNotEmpty) {
      themeItems.add(
        ThemeItem(
          themeWord: title,
          themeRule: themeItemContents[0],
          clearQuantity: int.parse(themeItemContents[1]),
          displayTargets:
              themeItemContents.getRange(2, themeItemContents.length).toList(),
          isImage: false,
        ),
      );
    }
  }

  context.read(originalThemeItemsProvider).state = themeItems;

  context.read(soundEffectProvider).state.loadAll([
    'sounds/cancel.mp3',
    'sounds/change.mp3',
    'sounds/clear.mp3',
    'sounds/false.mp3',
    'sounds/finish.mp3',
    'sounds/ready.mp3',
    'sounds/start.mp3',
    'sounds/tap.mp3',
    'sounds/true.mp3',
  ]);

  // WRを設定
  DatabaseReference firebaseInstance =
      FirebaseDatabase.instance.ref().child('worldRecord/');

  await firebaseInstance.get().then((DataSnapshot? snapshot) async {
    if (snapshot != null) {
      Map snapshotData = snapshot.value as Map;

      // Normal
      final Map<int, int> normalWR = {};
      int key = 1;
      snapshotData['normal']
          .where((data) => data != null)
          .toList()
          .forEach((value) {
        normalWR[key] = value['bestRecord'];

        key++;
      });

      // Hard
      final Map<int, int> hardWR = {};
      key = 1;
      snapshotData['hard']
          .where((data) => data != null)
          .toList()
          .forEach((value) {
        hardWR[key] = value['bestRecord'];

        key++;
      });

      // VeryHard
      final Map<int, int> veryHardWR = {};
      key = 1;
      snapshotData['veryHard']
          .where((data) => data != null)
          .toList()
          .forEach((value) {
        veryHardWR[key] = value['bestRecord'];

        key++;
      });

      // WRのリストを設定
      context.read(wordRecordProvider).state = WorldRecord(
        normal: normalWR,
        hard: hardWR,
        veryHard: veryHardWR,
      );
    }
  }).catchError((_) {
    // 何もしない
  });
}
