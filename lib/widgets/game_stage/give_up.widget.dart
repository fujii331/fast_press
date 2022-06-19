import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_press/services/admob/reward_action.service.dart';
import 'package:fast_press/widgets/common/comment_modal.widget.dart';
import 'package:fast_press/widgets/common/loading_modal.widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GiveUp extends HookWidget {
  final BuildContext screenContext;
  final AudioCache soundEffect;
  final double seVolume;
  final int difficulty;
  final int themeNumber;
  final ValueNotifier<bool> displayResultState;
  final ValueNotifier<bool> displayGiveUpState;
  final ValueNotifier<RewardedAd?> rewardedAdState;

  const GiveUp({
    Key? key,
    required this.screenContext,
    required this.soundEffect,
    required this.seVolume,
    required this.difficulty,
    required this.themeNumber,
    required this.displayResultState,
    required this.displayGiveUpState,
    required this.rewardedAdState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: displayGiveUpState.value ? 1 : 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                '諦めて次の問題へ...',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SawarabiGothic',
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Text(
                  '短い広告を見てこの問題をスキップしますか？',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'SawarabiGothic',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                children: [
                  SizedBox(
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
                      onPressed: () async {
                        soundEffect.play(
                          'sounds/cancel.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );

                        displayGiveUpState.value = false;
                        await Future.delayed(
                          const Duration(milliseconds: 100),
                        );
                        displayResultState.value = true;
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 2.5),
                        child: Text('見ない'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 60,
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.only(
                          bottom: 2,
                        ),
                        shape: const StadiumBorder(),
                        side: BorderSide(
                          width: 2,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      onPressed: () async {
                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );

                        // ロード中モーダルの表示
                        showDialog<int>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const LoadingModal();
                          },
                        );
                        // 広告のロード
                        await rewardLoading(
                          rewardedAdState,
                        );
                        if (rewardedAdState.value != null) {
                          showRewardedAd(
                            screenContext,
                            rewardedAdState,
                            difficulty,
                            themeNumber,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            headerAnimationLoop: false,
                            dismissOnTouchOutside: true,
                            dismissOnBackKeyPress: true,
                            showCloseIcon: true,
                            animType: AnimType.SCALE,
                            width: MediaQuery.of(context).size.width * .86 > 550
                                ? 550
                                : null,
                            body: const CommentModal(
                              topText: '取得失敗',
                              secondText:
                                  '動画の読み込みに失敗しました。\n電波の良いところで再度お試しください。',
                              closeButtonFlg: true,
                            ),
                          ).show();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 2.5),
                        child: Text(
                          '見る',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
