import 'package:audioplayers/audioplayers.dart';
import 'package:fast_press/models/target_info.model.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/widgets/game_stage/target_block.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TargetDisplay extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final ThemeItem themeItem;
  final int difficulty;
  final int previousRecord;
  final ValueNotifier<bool> timerPlayingState;
  final ValueNotifier<double> remainingTimeState;
  final ValueNotifier<int> recordState;
  final ValueNotifier<bool> recordMinusState;

  const TargetDisplay({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
    required this.themeItem,
    required this.difficulty,
    required this.previousRecord,
    required this.timerPlayingState,
    required this.remainingTimeState,
    required this.recordState,
    required this.recordMinusState,
  }) : super(key: key);

  void updateCandidateTargets(
    ValueNotifier<int> changedCountState,
    int separationNumber,
    int lastTargetOrder,
    ValueNotifier<List<TargetInfo>> candidateTargets,
    List<TargetInfo> targetList,
    ValueNotifier<int> nextListInitialOrderState,
  ) {
    int lackCount =
        nextListInitialOrderState.value + separationNumber - lastTargetOrder;

    // 問題が一周した場合は先頭に戻って取得
    if (lackCount > 0) {
      final list1 = targetList
          .getRange(nextListInitialOrderState.value, lastTargetOrder)
          .toList();
      if (lackCount <= lastTargetOrder) {
        // 問題数の範囲を超えない場合
        final list2 = targetList.getRange(0, lackCount).toList();
        list1.addAll(list2);
      } else {
        // 問題数の範囲を超える場合、もう一周する
        final list2 = targetList.getRange(0, lastTargetOrder).toList();
        list1.addAll(list2);
        lackCount -= lastTargetOrder;
        final list3 = targetList.getRange(0, lackCount).toList();
        list1.addAll(list3);
      }

      candidateTargets.value = list1;

      nextListInitialOrderState.value = lackCount;
    } else {
      candidateTargets.value = targetList
          .getRange(nextListInitialOrderState.value,
              nextListInitialOrderState.value + separationNumber)
          .toList();

      nextListInitialOrderState.value =
          nextListInitialOrderState.value + separationNumber == lastTargetOrder
              ? 0
              : nextListInitialOrderState.value + separationNumber;
    }

    candidateTargets.value.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final changedCountState = useState<int>(0);

    final displayTargets = themeItem.displayTargets;
    final isImage = themeItem.isImage;

    final isNormal = difficulty == 1;
    final isHard = difficulty == 2;
    final separationNumber = isNormal
        ? 9
        : isHard
            ? 16
            : 18;

    final targetList = <TargetInfo>[];
    final lastTargetOrder = displayTargets.length;

    final double threeBlockSize = MediaQuery.of(context).size.width > 450
        ? 120
        : MediaQuery.of(context).size.width * 0.26;

    final double fourBlockSize = MediaQuery.of(context).size.width > 450
        ? 90
        : MediaQuery.of(context).size.width * 0.2;

    final double middleThreeBlockSize = MediaQuery.of(context).size.width > 450
        ? 100
        : MediaQuery.of(context).size.width * 0.24;

    // ターゲットの作成
    for (int i = 0; i < lastTargetOrder; i++) {
      targetList.add(
        TargetInfo(targetOrder: i + 1, targetContent: displayTargets[i]),
      );
    }

    final correctOrderState = useState<int>(0);
    final nextListInitialOrderState = useState<int>(0);

    // タップごとに更新するターゲットを保持
    final candidateTargets = useState<List<TargetInfo>>([]);

    // useEffectで初期値を設定するのでダミーを入れておく
    const dummy = TargetInfo(targetOrder: 0, targetContent: '');
    final nextTargetState = useState<TargetInfo>(dummy);
    final target1State = useState<TargetInfo>(dummy);
    final target2State = useState<TargetInfo>(dummy);
    final target3State = useState<TargetInfo>(dummy);
    final target4State = useState<TargetInfo>(dummy);
    final target5State = useState<TargetInfo>(dummy);
    final target6State = useState<TargetInfo>(dummy);
    final target7State = useState<TargetInfo>(dummy);
    final target8State = useState<TargetInfo>(dummy);
    final target9State = useState<TargetInfo>(dummy);
    final target10State = useState<TargetInfo>(dummy);
    final target11State = useState<TargetInfo>(dummy);
    final target12State = useState<TargetInfo>(dummy);
    final target13State = useState<TargetInfo>(dummy);
    final target14State = useState<TargetInfo>(dummy);
    final target15State = useState<TargetInfo>(dummy);
    final target16State = useState<TargetInfo>(dummy);
    final target17State = useState<TargetInfo>(dummy);
    final target18State = useState<TargetInfo>(dummy);

    List<ValueNotifier<TargetInfo>> targets = [
      target1State,
      target2State,
      target3State,
      target4State,
      target5State,
      target6State,
      target7State,
      target8State,
      target9State,
      target10State,
      target11State,
      target12State,
      target13State,
      target14State,
      target15State,
      target16State,
      target17State,
      target18State,
    ];

    if (isNormal) {
      targets = targets.getRange(0, 9).toList();
    } else if (isHard) {
      targets = targets.getRange(0, 16).toList();
    }

    final List<Widget> displayColumn = [];
    List<Widget> displayRow = [];

    for (ValueNotifier<TargetInfo> target in targets) {
      final blockSize = isNormal
          ? threeBlockSize
          : isHard
              ? fourBlockSize
              : displayColumn.length % 2 == 0
                  ? fourBlockSize
                  : middleThreeBlockSize;

      final double fontSize = isNormal
          ? (blockSize > 90 ? 28 : 24)
          : isHard
              ? (blockSize > 70 ? 21 : 18)
              : displayColumn.length % 2 == 0
                  ? (blockSize > 70 ? 21 : 18)
                  : (blockSize > 80 ? 23 : 21);
      displayRow.add(TargetBlock(
        soundEffect: soundEffect,
        seVolume: seVolume,
        blockSize: blockSize,
        isImage: isImage,
        targetState: target,
        nextTarget: nextTargetState.value,
        changedCountState: changedCountState,
        recordState: recordState,
        correctOrder: correctOrderState.value,
        difficulty: difficulty,
        recordMinusState: recordMinusState,
        fontSize: fontSize,
      ));

      if (displayRow.length ==
          (isNormal
              ? 3
              : isHard
                  ? 4
                  : displayColumn.length % 2 == 0
                      ? 4
                      : 3)) {
        displayColumn.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: displayRow,
          ),
        );
        displayRow = [];
      }
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // 初回のみ起動
        if (nextTargetState.value.targetOrder == 0) {
          updateCandidateTargets(
            changedCountState,
            separationNumber,
            lastTargetOrder,
            candidateTargets,
            targetList,
            nextListInitialOrderState,
          );

          target1State.value = candidateTargets.value[0];
          target2State.value = candidateTargets.value[1];
          target3State.value = candidateTargets.value[2];
          target4State.value = candidateTargets.value[3];
          target5State.value = candidateTargets.value[4];
          target6State.value = candidateTargets.value[5];
          target7State.value = candidateTargets.value[6];
          target8State.value = candidateTargets.value[7];
          target9State.value = candidateTargets.value[8];
          target10State.value = isNormal ? dummy : candidateTargets.value[9];
          target11State.value = isNormal ? dummy : candidateTargets.value[10];
          target12State.value = isNormal ? dummy : candidateTargets.value[11];
          target13State.value = isNormal ? dummy : candidateTargets.value[12];
          target14State.value = isNormal ? dummy : candidateTargets.value[13];
          target15State.value = isNormal ? dummy : candidateTargets.value[14];
          target16State.value = isNormal ? dummy : candidateTargets.value[15];
          target17State.value =
              isNormal || isHard ? dummy : candidateTargets.value[16];
          target18State.value =
              isNormal || isHard ? dummy : candidateTargets.value[17];

          candidateTargets.value = [];
        }
        // 次の正解を更新
        correctOrderState.value = 1 +
            changedCountState.value -
            (changedCountState.value ~/ lastTargetOrder) * lastTargetOrder;

        // 候補のリストを更新
        if (candidateTargets.value.isEmpty) {
          updateCandidateTargets(
            changedCountState,
            separationNumber,
            lastTargetOrder,
            candidateTargets,
            targetList,
            nextListInitialOrderState,
          );
        }

        nextTargetState.value = candidateTargets.value.first;
        candidateTargets.value.removeAt(0);
      });
      return null;
    }, [changedCountState.value]);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 50),
        opacity: timerPlayingState.value ? 1 : 0,
        child: Column(
          children: displayColumn,
        ),
      ),
    );
  }
}
