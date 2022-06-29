import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/services/admob/interstitial_action.service.dart';
import 'package:fast_press/widgets/common/back_image.widget.dart';
import 'package:fast_press/widgets/game_stage/explanation.widget.dart';
import 'package:fast_press/widgets/game_stage/target_display.widget.dart';
import 'package:fast_press/widgets/game_stage/top_row.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

class GamePlayScreen extends HookWidget {
  static const routeName = '/game-play';

  const GamePlayScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List;
    final themeItem = args[0] as ThemeItem;
    final difficulty = args[1] as int;
    final previousRecord = args[2] as int;
    final themeNumber = args[3] as int;

    final isOriginal = themeNumber == 0;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final timerPlayingState = useState<bool>(false);
    final remainingTimeState = useState<double>(30);
    final recordState = useState<int>(0);

    final recordMinusState = useState<bool>(false);

    final ValueNotifier<InterstitialAd?> interstitialAdState = useState(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
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
                ? Colors.blue.shade800
                : difficulty == 2
                    ? Colors.orange.shade800
                    : Colors.purple.shade800,
            width: 2,
          ),
          body: Explanation(
            screenContext: context,
            soundEffect: soundEffect,
            seVolume: seVolume,
            themeItem: themeItem,
            difficulty: difficulty,
            recordState: recordState,
            previousRecord: previousRecord,
            timerPlayingState: timerPlayingState,
            remainingTimeState: remainingTimeState,
            isInitial: true,
            themeNumber: themeNumber,
            interstitialAdState: interstitialAdState,
            isOriginal: isOriginal,
          ),
        ).show();

        // 広告読み込み
        interstitialLoading(
          interstitialAdState,
        );
      });
      return null;
    }, []);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            const BackImage(
              imagePath: 'background.jpg',
            ),
            Container(
              margin: EdgeInsets.only(
                top: Platform.isAndroid ? 30 : 50,
                bottom: 20,
              ),
              child: Column(
                children: [
                  TopRow(
                    soundEffect: soundEffect,
                    seVolume: seVolume,
                    themeItem: themeItem,
                    difficulty: difficulty,
                    previousRecord: previousRecord,
                    timerPlayingState: timerPlayingState,
                    remainingTimeState: remainingTimeState,
                    recordState: recordState,
                    themeNumber: themeNumber,
                    recordMinus: recordMinusState.value,
                    interstitialAdState: interstitialAdState,
                    isOriginal: isOriginal,
                  ),
                  const Spacer(),
                  TargetDisplay(
                    soundEffect: soundEffect,
                    seVolume: seVolume,
                    themeItem: themeItem,
                    difficulty: difficulty,
                    previousRecord: previousRecord,
                    timerPlayingState: timerPlayingState,
                    remainingTimeState: remainingTimeState,
                    recordState: recordState,
                    recordMinusState: recordMinusState,
                  ),
                  const Spacer(),
                  const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
