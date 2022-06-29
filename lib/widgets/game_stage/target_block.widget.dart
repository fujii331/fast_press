import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:fast_press/models/target_info.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TargetBlock extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final double blockSize;
  final bool isImage;
  final ValueNotifier<TargetInfo> targetState;
  final TargetInfo nextTarget;
  final ValueNotifier<int> changedCountState;
  final ValueNotifier<int> recordState;
  final int correctOrder;
  final int difficulty;
  final ValueNotifier<bool> recordMinusState;
  final double fontSize;

  const TargetBlock({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
    required this.blockSize,
    required this.isImage,
    required this.targetState,
    required this.nextTarget,
    required this.changedCountState,
    required this.recordState,
    required this.correctOrder,
    required this.difficulty,
    required this.recordMinusState,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final targetContent = targetState.value.targetContent;
    final targetOrder = targetState.value.targetOrder;
    final isNormal = difficulty == 1;
    final isVeryHard = difficulty == 3;
    final isDisplaying = useState(true);
    final displayColorNumber = useState(isVeryHard ? Random().nextInt(5) : 0);
    final displayColors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.pink,
    ];

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: isDisplaying.value ? 1 : 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isNormal ? 8 : 5, vertical: isNormal ? 8 : 5),
        child: Container(
          height: blockSize,
          width: blockSize,
          decoration: BoxDecoration(
            color: displayColors[displayColorNumber.value].shade100,
            border: Border.all(
              color: displayColors[displayColorNumber.value].shade500,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () async {
              if (targetOrder == correctOrder) {
                soundEffect.play(
                  'sounds/true.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                recordState.value++;
                final nextItem = nextTarget;
                changedCountState.value++;

                isDisplaying.value = false;

                await Future.delayed(
                  const Duration(milliseconds: 200),
                );

                targetState.value = nextItem;
                if (isVeryHard) {
                  displayColorNumber.value = Random().nextInt(5);
                } else {
                  displayColorNumber.value +=
                      displayColorNumber.value == 4 ? -4 : 1;
                }

                isDisplaying.value = true;
              } else {
                soundEffect.play(
                  'sounds/false.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                if (!isNormal && recordState.value > 0) {
                  recordState.value--;
                  recordMinusState.value = true;

                  await Future.delayed(
                    const Duration(milliseconds: 400),
                  );

                  recordMinusState.value = false;
                }
              }
            },
            child: isImage
                ? Container(
                    height: blockSize,
                    width: blockSize,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/theme/$targetContent'),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: targetContent.length < 7 ? 6 : 1),
                      // color: Colors.blue,
                      width: fontSize * 3,
                      height: fontSize * 2.86,
                      child: Center(
                        child: Text(
                          targetContent,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
