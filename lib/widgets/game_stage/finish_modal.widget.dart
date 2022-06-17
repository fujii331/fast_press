import 'package:fast_press/providers/common.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FinishModal extends HookWidget {
  const FinishModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final isDisplay = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        soundEffect.play(
          'sounds/finish.mp3',
          isNotification: true,
          volume: seVolume,
        );
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        isDisplay.value = true;
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
              duration: const Duration(milliseconds: 200),
              opacity: isDisplay.value ? 1 : 0,
              child: Stack(
                children: <Widget>[
                  Text(
                    '終わり！',
                    style: TextStyle(
                      fontFamily: 'KaiseiOpti',
                      fontSize: 60,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.grey.shade900,
                    ),
                  ),
                  Text(
                    '終わり！',
                    style: TextStyle(
                      fontFamily: 'KaiseiOpti',
                      fontSize: 60,
                      color: Colors.grey.shade200,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
