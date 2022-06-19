// ignore_for_file: use_build_context_synchronously

import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/screens/game_play.screen.dart';
import 'package:fast_press/screens/stage_select.screen.dart';
import 'package:fast_press/screens/title.screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

useWidgetLifecycleObserver(BuildContext context) {
  return use(_WidgetObserver(
    context,
  ));
}

class _WidgetObserver extends Hook<void> {
  final BuildContext context;

  const _WidgetObserver(
    this.context,
  );

  @override
  HookState<void, Hook<void>> createState() {
    return _WidgetObserverState(
      context,
    );
  }
}

class _WidgetObserverState extends HookState<void, _WidgetObserver>
    with WidgetsBindingObserver {
  @override
  final BuildContext context;

  _WidgetObserverState(
    this.context,
  );

  @override
  void build(BuildContext context) {}

  @override
  void initHook() {
    super.initHook();
    Future(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // 音量設定
      final double? bgmVolume = prefs.getDouble('bgmVolume');

      if (bgmVolume != null) {
        context.read(bgmVolumeProvider).state = bgmVolume;
      } else {
        prefs.setDouble('bgmVolume', 0.2);
      }

      context.read(bgmProvider).state =
          await context.read(soundEffectProvider).state.loop(
                'sounds/bgm.mp3',
                isNotification: true,
                volume: context.read(bgmVolumeProvider).state,
              );
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      context.read(bgmProvider).state.pause();
    } else if (state == AppLifecycleState.resumed) {
      context.read(bgmProvider).state.resume();
    }
    super.didChangeAppLifecycleState(state);
  }
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useWidgetLifecycleObserver(
      context,
    );

    return MaterialApp(
      title: 'なんでも早押し',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.grey.shade100,
        fontFamily: 'SawarabiGothic',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
          },
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontFamily: 'MPLUS1p',
              ),
              bodyText2: const TextStyle(
                fontSize: 15.5,
                color: Colors.black,
                fontFamily: 'MPLUS1p',
              ),
              button: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'MPLUS1p',
              ),
            ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const TitleScreen(),
        StageSelectScreen.routeName: (BuildContext context) =>
            const StageSelectScreen(),
        GamePlayScreen.routeName: (BuildContext context) =>
            const GamePlayScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => const TitleScreen(),
        );
      },
    );
  }
}
