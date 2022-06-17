import 'package:fast_press/providers/common.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReadyModal extends HookWidget {
  const ReadyModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final isDisplay = useState<bool>(false);
    final displayWord = useState<String>('3');

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(
          const Duration(milliseconds: 600),
        );
        soundEffect.play(
          'sounds/ready.mp3',
          isNotification: true,
          volume: seVolume,
        );
        isDisplay.value = true;

        await Future.delayed(
          const Duration(milliseconds: 1000),
        );
        soundEffect.play(
          'sounds/ready.mp3',
          isNotification: true,
          volume: seVolume,
        );
        displayWord.value = '2';

        await Future.delayed(
          const Duration(milliseconds: 1000),
        );
        soundEffect.play(
          'sounds/ready.mp3',
          isNotification: true,
          volume: seVolume,
        );
        displayWord.value = '1';

        await Future.delayed(
          const Duration(milliseconds: 1000),
        );
      });
      return null;
    }, const []);

    return Theme(
      data: Theme.of(context)
          .copyWith(dialogBackgroundColor: Colors.white.withOpacity(0.0)),
      child: SimpleDialog(
        children: <Widget>[
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: isDisplay.value ? 1 : 0,
              child: Text(
                displayWord.value,
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KaiseiOpti',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
