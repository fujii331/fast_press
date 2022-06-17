import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_press/widgets/common/comment_modal.widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateVersionModal extends StatelessWidget {
  final BuildContext context;

  const UpdateVersionModal({
    Key? key,
    required this.context,
  }) : super(key: key);

  void _launchURL(
    String url,
  ) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
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
          topText: '読み込み失敗！',
          secondText: '申し訳ありません。ストア情報が取得できませんでした。直接ストアより更新をお願いします。',
          closeButtonFlg: true,
        ),
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String storeUrl = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=io.github.naoto613.fast_press'
        : 'https://apps.apple.com/app/id1606486849';

    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                "バージョン更新のお知らせ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansJP',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 10,
              ),
              child: Text(
                "新しいバージョンのアプリが利用可能です。\nストアより更新版を入手してご利用下さい。",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'NotoSansJP',
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.orange.shade800,
                  ),
                  onPressed: () => _launchURL(storeUrl),
                  child: const Text("今すぐ更新"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
