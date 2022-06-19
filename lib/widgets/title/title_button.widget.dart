import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/screens/stage_select.screen.dart';
import 'package:fast_press/widgets/title/sound_mode.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TitleButton extends HookWidget {
  const TitleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Column(
      children: [
        _selectButton(
          context,
          '　遊ぶ　',
          Colors.brown,
          const Icon(Icons.play_arrow),
          soundEffect,
          1,
          seVolume,
        ),
        const SizedBox(height: 25),
        _selectButton(
          context,
          '音量設定　',
          Colors.green,
          const Icon(Icons.music_note),
          soundEffect,
          2,
          seVolume,
        ),
      ],
    );
  }

  Widget _selectButton(
    BuildContext context,
    String label,
    MaterialColor color,
    Icon icon,
    AudioCache soundEffect,
    int buttonPattern,
    double seVolume,
  ) {
    return SizedBox(
      width: 150,
      height: 40,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: color.shade700,
          padding: const EdgeInsets.only(
            bottom: 1,
          ),
          shape: const StadiumBorder(),
          side: BorderSide(
            width: 2,
            color: color.shade900,
          ),
        ),
        onPressed: () async {
          soundEffect.play(
            'sounds/tap.mp3',
            isNotification: true,
            volume: seVolume,
          );
          if (buttonPattern == 1) {
            Navigator.of(context).pushNamed(
              StageSelectScreen.routeName,
            );
          } else if (buttonPattern == 2) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.NO_HEADER,
              headerAnimationLoop: false,
              animType: AnimType.SCALE,
              width: MediaQuery.of(context).size.width * .86 > 500 ? 500 : null,
              body: SoundMode(soundEffect: soundEffect),
            ).show();

            // データ作成用
            // for (String target in ['normal', 'hard', 'veryHard']) {
            //   for (int i = 1; i <= 100; i++) {
            //     DatabaseReference firebaseInstance = FirebaseDatabase.instance
            //         .ref()
            //         .child('worldRecord/$target/$i');

            //     firebaseInstance.set({
            //       'bestRecord': 0,
            //     });
            //   }
            // }
          }
        },
      ),
    );
  }
}
