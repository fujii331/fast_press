import 'package:audioplayers/audioplayers.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/screens/original_making_list.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteModal extends HookWidget {
  final String themeWord;
  final AudioCache soundEffect;
  final double seVolume;

  const DeleteModal({
    Key? key,
    required this.themeWord,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 23,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '削除確認',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'テーマ：$themeWordを削除しますか？',
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'NotoSansJP',
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            children: [
              SizedBox(
                width: 80,
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

                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 2.5),
                    child: Text('やめる'),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(
                width: 70,
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
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );

                    final index = context
                        .read(originalThemeTitlesProvider)
                        .state
                        .indexOf(themeWord);

                    context
                        .read(originalThemeTitlesProvider)
                        .state
                        .removeAt(index);

                    prefs.setStringList('originalThemeTitles',
                        context.read(originalThemeTitlesProvider).state);

                    context
                        .read(originalNormalRecordsProvider)
                        .state
                        .removeAt(index);

                    prefs.setStringList('originalNormalRecords',
                        context.read(originalNormalRecordsProvider).state);

                    context
                        .read(originalHardRecordsProvider)
                        .state
                        .removeAt(index);

                    prefs.setStringList('originalHardRecords',
                        context.read(originalHardRecordsProvider).state);

                    context
                        .read(originalVeryHardRecordsProvider)
                        .state
                        .removeAt(index);

                    prefs.setStringList('originalVeryHardRecords',
                        context.read(originalVeryHardRecordsProvider).state);

                    context
                        .read(originalThemeItemsProvider)
                        .state
                        .removeAt(index);

                    await prefs.remove('original-$themeWord');

                    context.read(rebuildProvider).state =
                        !context.read(rebuildProvider).state;

                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(OriginalMakingListScreen.routeName),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 2.5),
                    child: Text(
                      '削除',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
