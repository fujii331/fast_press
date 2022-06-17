import 'package:fast_press/widgets/common/modal_close_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CommentModal extends HookWidget {
  final String topText;
  final String secondText;
  final bool closeButtonFlg;

  const CommentModal({
    Key? key,
    required this.topText,
    required this.secondText,
    required this.closeButtonFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: closeButtonFlg ? 23 : 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            topText,
            style: const TextStyle(
              fontSize: 20.0,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            secondText,
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'NotoSansJP',
            ),
          ),
          const SizedBox(height: 30),
          closeButtonFlg ? const ModalCloseButton() : Container(),
        ],
      ),
    );
  }
}
