import 'dart:io';

import 'package:fast_press/data/game_themes.dart';
import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/models/word_record.model.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/screens/game_play.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

class StageSelectScreen extends HookWidget {
  static const routeName = '/stage-select';

  const StageSelectScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int normalClearedNumber =
        useProvider(normalClearedNumberProvider).state;
    final int hardClearedNumber = useProvider(hardClearedNumberProvider).state;
    final int veryHardClearedNumber =
        useProvider(veryHardClearedNumberProvider).state;

    final List<String> normalRecords = useProvider(normalRecordsProvider).state;
    final List<String> hardRecords = useProvider(hardRecordsProvider).state;
    final List<String> veryHardRecords =
        useProvider(veryHardRecordsProvider).state;

    final bool rebuild = useProvider(rebuildProvider).state;

    final double height = MediaQuery.of(context).size.height - 230 > 660
        ? 660
        : MediaQuery.of(context).size.height - 230;
    final double width = MediaQuery.of(context).size.width > 400
        ? 360
        : MediaQuery.of(context).size.width * 0.9;

    final normalItemsState = useState<List<Widget>>([]);
    final hardItemsState = useState<List<Widget>>([]);
    final veryHardItemsState = useState<List<Widget>>([]);

    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);

    final WorldRecord worldRecord = useProvider(wordRecordProvider).state;
    final Map<int, int> normalWR = worldRecord.normal;
    final Map<int, int> hardWR = worldRecord.hard;
    final Map<int, int> veryHardWR = worldRecord.veryHard;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Normalを設定
        normalItemsState.value = [];

        for (int i = 0; i < normalRecords.length; i++) {
          final themeItem = gameThemes[i];
          final int thisWR = normalWR[i + 1] ?? 0;
          normalItemsState.value.insert(
            0,
            _block(
              context,
              soundEffect,
              seVolume,
              1,
              int.parse(normalRecords[i]),
              themeItem,
              i + 1,
              thisWR,
            ),
          );
        }
        for (int i = normalRecords.length; i < normalRecords.length + 3; i++) {
          if (i == gameThemes.length) {
            // これ以上問題がない場合
            normalItemsState.value.insert(0, _preparationBlock());
            break;
          } else if (i == normalRecords.length && i == normalClearedNumber) {
            final themeItem = gameThemes[i];
            normalItemsState.value.insert(
                0,
                _block(
                  context,
                  soundEffect,
                  seVolume,
                  1,
                  0,
                  themeItem,
                  i + 1,
                  0,
                ));
          } else {
            final themeItem = gameThemes[i];
            normalItemsState.value.insert(
              0,
              _cannotPlayBlock(themeItem),
            );
            break;
          }
        }

        final normalRemainingWIdth = width - normalItemsState.value.length * 70;

        if (normalRemainingWIdth > 70) {
          final double normalBoxWidth = 70.0 * (normalRemainingWIdth ~/ 70);
          normalItemsState.value.add(SizedBox(width: normalBoxWidth));
        }

        // Hardを設定
        hardItemsState.value = [];

        for (int i = 0; i < hardRecords.length; i++) {
          final themeItem = gameThemes[i];
          final int thisWR = hardWR[i + 1] ?? 0;
          hardItemsState.value.insert(
            0,
            _block(
              context,
              soundEffect,
              seVolume,
              2,
              int.parse(hardRecords[i]),
              themeItem,
              i + 1,
              thisWR,
            ),
          );
        }
        for (int i = hardRecords.length; i < hardRecords.length + 3; i++) {
          if (i == gameThemes.length) {
            // これ以上問題がない場合
            hardItemsState.value.insert(0, _preparationBlock());
            break;
          } else if (i == hardRecords.length && i == hardClearedNumber) {
            final themeItem = gameThemes[i];
            hardItemsState.value.insert(
                0,
                _block(
                  context,
                  soundEffect,
                  seVolume,
                  2,
                  0,
                  themeItem,
                  i + 1,
                  0,
                ));
          } else {
            final themeItem = gameThemes[i];
            hardItemsState.value.insert(
              0,
              _cannotPlayBlock(themeItem),
            );
            break;
          }
        }

        final hardRemainingWIdth = width - hardItemsState.value.length * 70;

        if (hardRemainingWIdth > 70) {
          final double hardBoxWidth = 70.0 * (hardRemainingWIdth ~/ 70);
          hardItemsState.value.add(SizedBox(width: hardBoxWidth));
        }

        // Very Hardを設定
        veryHardItemsState.value = [];

        for (int i = 0; i < veryHardRecords.length; i++) {
          final themeItem = gameThemes[i];
          final int thisWR = veryHardWR[i + 1] ?? 0;
          veryHardItemsState.value.insert(
            0,
            _block(
              context,
              soundEffect,
              seVolume,
              3,
              int.parse(veryHardRecords[i]),
              themeItem,
              i + 1,
              thisWR,
            ),
          );
        }
        for (int i = veryHardRecords.length;
            i < veryHardRecords.length + 3;
            i++) {
          if (i == gameThemes.length) {
            // これ以上問題がない場合
            veryHardItemsState.value.insert(0, _preparationBlock());
            break;
          } else if (i == veryHardRecords.length &&
              i == veryHardClearedNumber) {
            final themeItem = gameThemes[i];
            veryHardItemsState.value.insert(
                0,
                _block(
                  context,
                  soundEffect,
                  seVolume,
                  3,
                  0,
                  themeItem,
                  i + 1,
                  0,
                ));
          } else {
            final themeItem = gameThemes[i];
            veryHardItemsState.value.insert(
              0,
              _cannotPlayBlock(themeItem),
            );
            break;
          }
        }

        final veryHardRemainingWIdth =
            width - veryHardItemsState.value.length * 70;

        if (veryHardRemainingWIdth > 70) {
          final double veryHardBoxWidth = 70.0 * (veryHardRemainingWIdth ~/ 70);
          veryHardItemsState.value.add(SizedBox(width: veryHardBoxWidth));
        }
      });
      return null;
    }, [rebuild]);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background/background.jpg'),
          fit: BoxFit.cover,
          opacity: 0.65,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0x15555555),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          title: const Text(
            'ステージ選択',
            style: TextStyle(
              fontFamily: 'KaiseiOpti',
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.teal.shade900.withOpacity(0.95),
        ),
        body: PageView(
          controller: pageController,
          // ページ切り替え時に実行する処理
          onPageChanged: (index) {
            screenNo.value = index;
          },
          children: [
            _page(height, width, normalItemsState.value),
            _page(height, width, hardItemsState.value),
            _page(height, width, veryHardItemsState.value),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            FloatingNavbar(
              backgroundColor: Colors.brown.shade800,
              // type: BottomNavigationBarType.fixed,
              currentIndex: screenNo.value,
              selectedItemColor: Colors.teal.shade900,
              unselectedItemColor: Colors.grey.shade200,
              onTap: (int selectIndex) {
                screenNo.value = selectIndex;
                pageController.animateToPage(
                  selectIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              items: [
                FloatingNavbarItem(
                  icon: Icons.sunny,
                  title: 'Normal',
                ),
                FloatingNavbarItem(
                  icon: Icons.cloud,
                  title: 'Hard',
                ),
                FloatingNavbarItem(
                  icon: Icons.thunderstorm, // hotel_class_sharp
                  title: 'Very Hard',
                ),
                // tooltip: '3✖︎3のブロックが表示される。\n間違えても減点はなし。'),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.sentiment_satisfied_alt),
                //     label: 'ノーマル',
                //     tooltip: '3✖︎3のブロックが表示される。\n間違えても減点はなし。'),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.sentiment_satisfied),
                //     label: 'ハード',
                //     tooltip: '4✖︎4のブロックが表示される。\n間違えると減点。\nノルマも高い。'),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.sentiment_dissatisfied_rounded),
                //     label: 'ベリーハード',
                //     tooltip: '18個のブロックが表示される。\n間違えると減点。\nさらにノルマが高い。'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _page(
    double height,
    double width,
    List<Widget> items,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: Platform.isAndroid ? 90 : 120),
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Wrap(
              children: items,
            ),
          ),
        ),
      ),
    );
  }

  Widget _block(
    BuildContext context,
    AudioCache soundEffect,
    double seVolume,
    int difficulty,
    int previousRecord,
    ThemeItem themeItem,
    int themeNumber,
    int thisWR,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: difficulty == 1
                    ? Colors.green.shade50
                    : difficulty == 2
                        ? Colors.orange.shade50
                        : Colors.purple.shade50,
                border: Border.all(
                  color: difficulty == 1
                      ? Colors.green.shade700
                      : difficulty == 2
                          ? Colors.orange.shade700
                          : Colors.purple.shade700,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  soundEffect.play(
                    'sounds/tap.mp3',
                    isNotification: true,
                    volume: seVolume,
                  );

                  Navigator.of(context).pushNamed(
                    GamePlayScreen.routeName,
                    arguments: [
                      themeItem,
                      difficulty,
                      previousRecord,
                      themeNumber,
                    ],
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      themeItem.themeWord,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MPLUS1p',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            previousRecord >= themeItem.clearQuantity
                ? previousRecord == thisWR
                    ? const Padding(
                        padding: EdgeInsets.only(
                          left: 37,
                        ),
                        child: Text(
                          'WR',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MPLUS1p',
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          left: 43,
                          top: 2,
                        ),
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage('assets/images/check.png'),
                            ),
                          ),
                        ),
                      )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _cannotPlayBlock(
    ThemeItem themeItem,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade700,
            width: 2,
          ),
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Text(
              themeItem.themeWord,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'MPLUS1p',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _preparationBlock() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade900,
            width: 2,
          ),
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            '準備中',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'MPLUS1p',
            ),
          ),
        ),
      ),
    );
  }
}
