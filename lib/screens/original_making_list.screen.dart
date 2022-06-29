import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/screens/original_edit.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

class OriginalMakingListScreen extends HookWidget {
  static const routeName = '/original-making-list';

  const OriginalMakingListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final bool rebuild = useProvider(rebuildProvider).state;

    final double height = MediaQuery.of(context).size.height - 230 > 660
        ? 660
        : MediaQuery.of(context).size.height - 230;
    final double width = MediaQuery.of(context).size.width > 400
        ? 360
        : MediaQuery.of(context).size.width * 0.9;
    final originalThemeItems = useProvider(originalThemeItemsProvider).state;

    final originalItemsState = useState<List<Widget>>([]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        originalItemsState.value = [];

        for (int i = 0; i < originalThemeItems.length; i++) {
          final themeItem = originalThemeItems[i];
          originalItemsState.value.insert(
            0,
            _block(
              context,
              soundEffect,
              seVolume,
              themeItem,
            ),
          );
        }

        if (originalItemsState.value.isNotEmpty) {
          final originalThemeWidth =
              width - originalItemsState.value.length * 70;

          if (originalThemeWidth > 70) {
            final double veryHardBoxWidth = 70.0 * (originalThemeWidth ~/ 70);
            originalItemsState.value.add(SizedBox(width: veryHardBoxWidth));
          }
        }
      });
      return null;
    }, [rebuild]);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background/background.jpg'),
          fit: BoxFit.cover,
          opacity: 0.9,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.4),
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          title: const Text(
            '問題作成',
            style: TextStyle(
              fontFamily: 'MPLUS1p',
              fontSize: 22,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.pink.shade900.withOpacity(0.95),
          actions: <Widget>[
            IconButton(
              iconSize: 28,
              icon: Icon(
                Icons.add,
                color: Colors.yellow.shade50,
              ),
              onPressed: () async {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                Navigator.of(context).pushNamed(
                  OriginalEditScreen.routeName,
                  arguments: [
                    const ThemeItem(
                      themeWord: '',
                      themeRule: '',
                      clearQuantity: 1,
                      displayTargets: ['', '', '', '', '', '', '', '', ''],
                      isImage: false,
                    ),
                    true,
                  ],
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: height,
            width: width,
            margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 15,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: originalItemsState.value.isEmpty
                    ? const Text(
                        '右上の+ボタンから作成！',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MPLUS1p',
                        ),
                      )
                    : Wrap(
                        children: originalItemsState.value,
                      ),
              ),
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
    ThemeItem themeItem,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: SizedBox(
        height: 60,
        width: 60,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            border: Border.all(
              color: Colors.pink.shade700,
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
                OriginalEditScreen.routeName,
                arguments: [
                  themeItem,
                  false,
                ],
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
              child: Center(
                child: Text(
                  themeItem.themeWord,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MPLUS1p',
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
