import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:fast_press/models/theme_item.model.dart';
import 'package:fast_press/providers/common.provider.dart';
import 'package:fast_press/widgets/original_edit/delete_modal.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OriginalEditScreen extends HookWidget {
  static const routeName = '/original-edit';

  const OriginalEditScreen({
    Key? key,
  }) : super(key: key);

  void validate(
    TextEditingController themeWordTextController,
    TextEditingController themeRuleTextController,
    TextEditingController clearQuantityTextController,
    ValueNotifier<List<String>> displayTargetsState,
    ValueNotifier<bool> canUpdateState,
    ValueNotifier<bool> rebuildState,
  ) {
    if (themeWordTextController.text.isNotEmpty &&
        themeRuleTextController.text.isNotEmpty &&
        clearQuantityTextController.text.isNotEmpty &&
        int.parse(clearQuantityTextController.text) > 0) {
      for (String displayTarget in displayTargetsState.value) {
        if (displayTarget.isEmpty) {
          canUpdateState.value = false;
          return;
        }
      }
      canUpdateState.value = true;
    } else {
      canUpdateState.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List;
    final themeItem = args[0] as ThemeItem;
    final isCreate = args[1] as bool;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final themeWordTextController =
        useTextEditingController(text: themeItem.themeWord);

    final themeRuleTextController =
        useTextEditingController(text: themeItem.themeRule);

    final clearQuantityTextController =
        useTextEditingController(text: themeItem.clearQuantity.toString());

    var displayTargetsState = useState<List<String>>(isCreate
        ? ['', '', '', '', '', '', '', '', '']
        : themeItem.displayTargets);

    final displayTargetsWidgetState = useState<Widget?>(null);

    final canUpdateState = useState<bool>(!isCreate);

    final rebuildState = useState<bool>(false);

    // useEffectでstateの構築はできないのでここで50個くらい作る
    // Listにつめてひとつずつ渡していく
    final target1TextController = useTextEditingController(text: '');
    final target2TextController = useTextEditingController(text: '');
    final target3TextController = useTextEditingController(text: '');
    final target4TextController = useTextEditingController(text: '');
    final target5TextController = useTextEditingController(text: '');
    final target6TextController = useTextEditingController(text: '');
    final target7TextController = useTextEditingController(text: '');
    final target8TextController = useTextEditingController(text: '');
    final target9TextController = useTextEditingController(text: '');
    final target10TextController = useTextEditingController(text: '');
    final target11TextController = useTextEditingController(text: '');
    final target12TextController = useTextEditingController(text: '');
    final target13TextController = useTextEditingController(text: '');
    final target14TextController = useTextEditingController(text: '');
    final target15TextController = useTextEditingController(text: '');
    final target16TextController = useTextEditingController(text: '');
    final target17TextController = useTextEditingController(text: '');
    final target18TextController = useTextEditingController(text: '');
    final target19TextController = useTextEditingController(text: '');
    final target20TextController = useTextEditingController(text: '');
    final target21TextController = useTextEditingController(text: '');
    final target22TextController = useTextEditingController(text: '');
    final target23TextController = useTextEditingController(text: '');
    final target24TextController = useTextEditingController(text: '');
    final target25TextController = useTextEditingController(text: '');
    final target26TextController = useTextEditingController(text: '');
    final target27TextController = useTextEditingController(text: '');
    final target28TextController = useTextEditingController(text: '');
    final target29TextController = useTextEditingController(text: '');
    final target30TextController = useTextEditingController(text: '');
    final target31TextController = useTextEditingController(text: '');
    final target32TextController = useTextEditingController(text: '');
    final target33TextController = useTextEditingController(text: '');
    final target34TextController = useTextEditingController(text: '');
    final target35TextController = useTextEditingController(text: '');
    final target36TextController = useTextEditingController(text: '');
    final target37TextController = useTextEditingController(text: '');
    final target38TextController = useTextEditingController(text: '');
    final target39TextController = useTextEditingController(text: '');
    final target40TextController = useTextEditingController(text: '');
    final target41TextController = useTextEditingController(text: '');
    final target42TextController = useTextEditingController(text: '');
    final target43TextController = useTextEditingController(text: '');
    final target44TextController = useTextEditingController(text: '');
    final target45TextController = useTextEditingController(text: '');
    final target46TextController = useTextEditingController(text: '');
    final target47TextController = useTextEditingController(text: '');
    final target48TextController = useTextEditingController(text: '');
    final target49TextController = useTextEditingController(text: '');
    final target50TextController = useTextEditingController(text: '');

    final targetTextControllerList = [
      target1TextController,
      target2TextController,
      target3TextController,
      target4TextController,
      target5TextController,
      target6TextController,
      target7TextController,
      target8TextController,
      target9TextController,
      target10TextController,
      target11TextController,
      target12TextController,
      target13TextController,
      target14TextController,
      target15TextController,
      target16TextController,
      target17TextController,
      target18TextController,
      target19TextController,
      target20TextController,
      target21TextController,
      target22TextController,
      target23TextController,
      target24TextController,
      target25TextController,
      target26TextController,
      target27TextController,
      target28TextController,
      target29TextController,
      target30TextController,
      target31TextController,
      target32TextController,
      target33TextController,
      target34TextController,
      target35TextController,
      target36TextController,
      target37TextController,
      target38TextController,
      target39TextController,
      target40TextController,
      target41TextController,
      target42TextController,
      target43TextController,
      target44TextController,
      target45TextController,
      target46TextController,
      target47TextController,
      target48TextController,
      target49TextController,
      target50TextController
    ];

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        displayTargetsWidgetState.value = null;

        final List<Widget> targetsLabelColumn = [];
        final List<Widget> targetsContentColumn = [];

        int index = 1;

        for (String target in displayTargetsState.value) {
          targetsLabelColumn.add(_displayTargetLabel(index));

          targetTextControllerList[index - 1].text = target;
          targetsContentColumn.add(
            _displayTargetContent(
              context,
              themeWordTextController,
              themeRuleTextController,
              clearQuantityTextController,
              displayTargetsState,
              canUpdateState,
              rebuildState,
              targetTextControllerList[index - 1],
              index,
            ),
          );

          displayTargetsWidgetState.value = Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: targetsLabelColumn,
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: targetsContentColumn,
                  ),
                ],
              ),
              targetsContentColumn.length < 50
                  ? _addButton(
                      displayTargetsState,
                      rebuildState,
                      canUpdateState,
                    )
                  : Container(),
            ],
          );

          index++;
        }
      });
      return null;
    }, [rebuildState.value]);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background/background.jpg'),
          fit: BoxFit.cover,
          opacity: 0.95,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          title: const Text(
            '問題編集',
            style: TextStyle(
              fontFamily: 'MPLUS1p',
              fontSize: 22,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.pink.shade900.withOpacity(0.95),
          actions: <Widget>[
            isCreate
                ? Container()
                : SizedBox(
                    width: 49,
                    child: TextButton(
                      child: Text(
                        "削除",
                        style: TextStyle(
                          color: Colors.red.shade200,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.NO_HEADER,
                          headerAnimationLoop: false,
                          showCloseIcon: true,
                          animType: AnimType.SCALE,
                          width: MediaQuery.of(context).size.width * .86 > 550
                              ? 550
                              : null,
                          body: DeleteModal(
                            themeWord: themeItem.themeWord,
                            soundEffect: soundEffect,
                            seVolume: seVolume,
                          ),
                        ).show();
                      },
                    ),
                  ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              width: 59,
              child: TextButton(
                onPressed: canUpdateState.value
                    ? () async {
                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        final themeWord = themeItem.themeWord;

                        final updatedThemeWord = themeWordTextController.text;

                        if (context
                                .read(originalThemeTitlesProvider)
                                .state
                                .contains(updatedThemeWord) &&
                            updatedThemeWord != themeWord) {
                          EasyLoading.showToast(
                            'すでに存在するテーマは登録できません',
                            duration: const Duration(milliseconds: 3000),
                            toastPosition: EasyLoadingToastPosition.center,
                            dismissOnTap: false,
                          );

                          return;
                        }

                        final themeItemContents = [
                          themeRuleTextController.text,
                          clearQuantityTextController.text,
                        ];

                        themeItemContents.addAll(displayTargetsState.value);

                        prefs.setStringList(
                            'original-$updatedThemeWord', themeItemContents);

                        if (isCreate) {
                          context
                              .read(originalThemeTitlesProvider)
                              .state
                              .add(themeWordTextController.text);

                          prefs.setStringList('originalThemeTitles',
                              context.read(originalThemeTitlesProvider).state);

                          context
                              .read(originalNormalRecordsProvider)
                              .state
                              .add('0');

                          prefs.setStringList(
                              'originalNormalRecords',
                              context
                                  .read(originalNormalRecordsProvider)
                                  .state);

                          context
                              .read(originalHardRecordsProvider)
                              .state
                              .add('0');

                          prefs.setStringList('originalHardRecords',
                              context.read(originalHardRecordsProvider).state);

                          context
                              .read(originalVeryHardRecordsProvider)
                              .state
                              .add('0');

                          prefs.setStringList(
                              'originalVeryHardRecords',
                              context
                                  .read(originalVeryHardRecordsProvider)
                                  .state);

                          context.read(originalThemeItemsProvider).state.add(
                                ThemeItem(
                                  themeWord: updatedThemeWord,
                                  themeRule: themeItemContents[0],
                                  clearQuantity:
                                      int.parse(themeItemContents[1]),
                                  displayTargets: themeItemContents
                                      .getRange(2, themeItemContents.length)
                                      .toList(),
                                  isImage: false,
                                ),
                              );

                          EasyLoading.showToast(
                            '新たな問題を登録しました',
                            duration: const Duration(milliseconds: 3000),
                            toastPosition: EasyLoadingToastPosition.center,
                            dismissOnTap: false,
                          );
                        } else {
                          final index = context
                              .read(originalThemeTitlesProvider)
                              .state
                              .indexOf(themeItem.themeWord);

                          if (themeWord != updatedThemeWord) {
                            context
                                .read(originalThemeTitlesProvider)
                                .state[index] = themeWordTextController.text;

                            prefs.setStringList(
                                'originalThemeTitles',
                                context
                                    .read(originalThemeTitlesProvider)
                                    .state);

                            await prefs.remove('original-$themeWord');
                          }

                          context
                              .read(originalNormalRecordsProvider)
                              .state[index] = '0';

                          prefs.setStringList(
                              'originalNormalRecords',
                              context
                                  .read(originalNormalRecordsProvider)
                                  .state);

                          context
                              .read(originalHardRecordsProvider)
                              .state[index] = '0';

                          prefs.setStringList('originalHardRecords',
                              context.read(originalHardRecordsProvider).state);

                          context
                              .read(originalVeryHardRecordsProvider)
                              .state[index] = '0';

                          prefs.setStringList(
                              'originalVeryHardRecords',
                              context
                                  .read(originalVeryHardRecordsProvider)
                                  .state);

                          context
                              .read(originalThemeItemsProvider)
                              .state[index] = ThemeItem(
                            themeWord: updatedThemeWord,
                            themeRule: themeItemContents[0],
                            clearQuantity: int.parse(themeItemContents[1]),
                            displayTargets: themeItemContents
                                .getRange(2, themeItemContents.length)
                                .toList(),
                            isImage: false,
                          );

                          EasyLoading.showToast(
                            '問題を更新しました',
                            duration: const Duration(milliseconds: 3000),
                            toastPosition: EasyLoadingToastPosition.center,
                            dismissOnTap: false,
                          );
                        }

                        context.read(rebuildProvider).state =
                            !context.read(rebuildProvider).state;

                        Navigator.pop(context);
                      }
                    : () {},
                child: Text(
                  isCreate ? "登録" : "更新",
                  style: TextStyle(
                    color: canUpdateState.value
                        ? Colors.green.shade300
                        : Colors.grey,
                    fontSize: 15,
                    fontWeight: canUpdateState.value ? FontWeight.bold : null,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                right: 10,
                left: 10,
                bottom: 25,
              ),
              width: MediaQuery.of(context).size.width * .86 > 500 ? 500 : null,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(
                            height: 48,
                            child: Center(
                              child: Text(
                                'テーマ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            height: 48,
                            child: Center(
                              child: Text(
                                'ルール',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            height: 48,
                            child: Center(
                              child: Text(
                                'クリア条件',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 35),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .86 > 500
                            ? 300
                            : MediaQuery.of(context).size.width * .86 - 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              controller: themeWordTextController,
                              onChanged: (target) {
                                validate(
                                  themeWordTextController,
                                  themeRuleTextController,
                                  clearQuantityTextController,
                                  displayTargetsState,
                                  canUpdateState,
                                  rebuildState,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: '9字以内',
                                hintStyle: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue.shade100,
                                    width: 1,
                                  ),
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(9),
                              ],
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue.shade100,
                                    width: 1,
                                  ),
                                ),
                                hintText: '50字以内',
                                hintStyle: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              controller: themeRuleTextController,
                              onChanged: (target) {
                                validate(
                                  themeWordTextController,
                                  themeRuleTextController,
                                  clearQuantityTextController,
                                  displayTargetsState,
                                  canUpdateState,
                                  rebuildState,
                                );
                              },
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(50),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: TextFormField(
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    controller: clearQuantityTextController,
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue.shade100,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    onChanged: (target) {
                                      validate(
                                        themeWordTextController,
                                        themeRuleTextController,
                                        clearQuantityTextController,
                                        displayTargetsState,
                                        canUpdateState,
                                        rebuildState,
                                      );
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(3),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  '回',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.pink.shade700,
                    thickness: 2,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '連続する9個以上の答えを設定',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.pink.shade100,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: displayTargetsWidgetState.value ?? Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayTargetLabel(
    int targetNumber,
  ) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.5),
      child: SizedBox(
        height: 32.5,
        width: 50,
        child: Center(
          child: Text(
            '$targetNumber番目',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayTargetContent(
    BuildContext context,
    TextEditingController themeWordTextController,
    TextEditingController themeRuleTextController,
    TextEditingController clearQuantityTextController,
    ValueNotifier<List<String>> displayTargetsState,
    ValueNotifier<bool> canUpdateState,
    ValueNotifier<bool> rebuildState,
    TextEditingController textController,
    int targetNumber,
  ) {
    final defaultDisplay = targetNumber < 10;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .86 > 500
                ? 200
                : MediaQuery.of(context).size.width * .86 - 170,
            height: 33,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: Colors.blueGrey.shade700,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.4, left: 5),
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                controller: textController,
                onChanged: (target) {
                  final preValue = displayTargetsState.value[targetNumber - 1];
                  displayTargetsState.value[targetNumber - 1] = target;

                  if ((preValue != '' && target == '') ||
                      (preValue == '' && target != '')) {
                    validate(
                      themeWordTextController,
                      themeRuleTextController,
                      clearQuantityTextController,
                      displayTargetsState,
                      canUpdateState,
                      rebuildState,
                    );
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0),
                    ),
                  ),
                  hintText: '9字以内',
                  hintStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade400,
                  ),
                ),
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(9),
                ],
              ),
            ),
          ),
          !defaultDisplay
              ? Container(
                  padding: const EdgeInsets.only(
                    left: 5,
                  ),
                  height: 32.5,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 28,
                    icon: Icon(
                      Icons.close,
                      color: Colors.red.shade200,
                    ),
                    onPressed: () async {
                      displayTargetsState.value.removeAt(targetNumber - 1);

                      validate(
                        themeWordTextController,
                        themeRuleTextController,
                        clearQuantityTextController,
                        displayTargetsState,
                        canUpdateState,
                        rebuildState,
                      );
                      rebuildState.value = !rebuildState.value;
                    },
                  ),
                )
              : const SizedBox(width: 53)
        ],
      ),
    );
  }

  Widget _addButton(
    ValueNotifier<List<String>> displayTargetsState,
    ValueNotifier<bool> rebuildState,
    ValueNotifier<bool> canUpdateState,
  ) {
    return IconButton(
      iconSize: 28,
      icon: Icon(
        Icons.add_circle_outlined,
        color: Colors.green.shade100,
      ),
      onPressed: () async {
        displayTargetsState.value.add('');
        canUpdateState.value = false;
        rebuildState.value = !rebuildState.value;
      },
    );
  }
}
