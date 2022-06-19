import 'dart:io';

import 'package:fast_press/data/advertising.dart';
import 'package:fast_press/data/game_themes.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/screens/game_play.screen.dart';
import 'package:fast_press/screens/stage_select.screen.dart';
import 'package:fast_press/widgets/common/comment_modal.widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAdState,
  int difficulty,
  int themeNumber,
) {
  if (rewardAdState.value == null) {
    return;
  }
  rewardAdState.value!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      ad.dispose();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 500 ? 500 : null,
        body: const CommentModal(
          topText: '処理失敗',
          secondText: '正常に処理が完了しませんでした。\n再度お試しください。',
          closeButtonFlg: true,
        ),
      ).show();
    },
  );
  rewardAdState.value!.setImmersiveMode(true);
  rewardAdState.value!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (difficulty == 1) {
      if (context.read(normalRecordsProvider).state.length < themeNumber) {
        context.read(normalRecordsProvider).state.add('0');
      }

      prefs.setStringList(
          'normalRecords', context.read(normalRecordsProvider).state);

      context.read(normalClearedNumberProvider).state = themeNumber;
      prefs.setInt('normalClearedNumber', themeNumber);
    } else if (difficulty == 2) {
      if (context.read(hardRecordsProvider).state.length < themeNumber) {
        context.read(hardRecordsProvider).state.add('0');
      }
      prefs.setStringList(
          'hardRecords', context.read(hardRecordsProvider).state);

      context.read(hardClearedNumberProvider).state = themeNumber;
      prefs.setInt('hardClearedNumber', themeNumber);
    } else if (difficulty == 3) {
      if (context.read(veryHardRecordsProvider).state.length < themeNumber) {
        context.read(veryHardRecordsProvider).state.add('0');
      }
      prefs.setStringList(
          'veryHardRecords', context.read(veryHardRecordsProvider).state);

      context.read(veryHardClearedNumberProvider).state = themeNumber;
      prefs.setInt('veryHardClearedNumber', themeNumber);
    }

    context.read(rebuildProvider).state = !context.read(rebuildProvider).state;

    Navigator.popUntil(
      context,
      ModalRoute.withName(
        StageSelectScreen.routeName,
      ),
    );

    Navigator.of(context).pushNamed(
      GamePlayScreen.routeName,
      arguments: [
        gameThemes[themeNumber],
        difficulty,
        0,
        themeNumber + 1,
      ],
    );
  });
  rewardAdState.value = null;
}

void createRewardedAd(
  ValueNotifier<RewardedAd?> rewardAdState,
  int numRewardedLoadAttempts,
) {
  RewardedAd.load(
    adUnitId: Platform.isAndroid ? androidRewardAdvid : iosRewardAdvid,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        rewardAdState.value = ad;
        numRewardedLoadAttempts = 0;
      },
      onAdFailedToLoad: (LoadAdError error) {
        rewardAdState.value = null;
        numRewardedLoadAttempts += 1;
        if (numRewardedLoadAttempts <= 3) {
          createRewardedAd(
            rewardAdState,
            numRewardedLoadAttempts,
          );
        }
      },
    ),
  );
}

Future rewardLoading(
  ValueNotifier<RewardedAd?> rewardedAdState,
) async {
  int numRewardedLoadAttempts = 0;
  createRewardedAd(
    rewardedAdState,
    numRewardedLoadAttempts,
  );
  for (int i = 0; i < 15; i++) {
    if (rewardedAdState.value != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}
