import 'package:fast_press/providers/common.provider.dart';
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
}
