import 'dart:io';

import 'package:fast_press/data/advertising.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

void showInterstitialAd(
  BuildContext context,
  ValueNotifier<InterstitialAd?> interstitialAdState,
) async {
  if (interstitialAdState.value == null) {
    return;
  }
  interstitialAdState.value!.fullScreenContentCallback =
      FullScreenContentCallback(
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
    },
  );
  interstitialAdState.value!.show();
  interstitialAdState.value = null;
}

void createInterstitialAd(
  ValueNotifier<InterstitialAd?> interstitialAdState,
  int numInterstitialLoadAttempts,
) {
  InterstitialAd.load(
    adUnitId:
        Platform.isAndroid ? androidInterstitalAdvid : iosInterstitalAdvid,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        interstitialAdState.value = ad;
        numInterstitialLoadAttempts = 0;
        interstitialAdState.value!.setImmersiveMode(true);
      },
      onAdFailedToLoad: (LoadAdError error) {
        numInterstitialLoadAttempts += 1;
        interstitialAdState.value = null;
        if (numInterstitialLoadAttempts <= 3) {
          createInterstitialAd(
            interstitialAdState,
            numInterstitialLoadAttempts,
          );
        }
      },
    ),
  );
}

Future interstitialLoading(
  ValueNotifier<InterstitialAd?> interstitialAdState,
) async {
  int numInterstitialLoadAttempts = 0;
  createInterstitialAd(
    interstitialAdState,
    numInterstitialLoadAttempts,
  );
  for (int i = 0; i < 10; i++) {
    if (i > 2 && interstitialAdState.value != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}
