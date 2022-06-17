import 'package:fast_press/providers/common.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

class ModalCloseButton extends HookWidget {
  const ModalCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return SizedBox(
      width: 75,
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
          child: Text('閉じる'),
        ),
      ),
    );
  }
}
