import 'package:fast_press/services/title/first_setting.service.dart';
import 'package:fast_press/widgets/common/back_image.widget.dart';
import 'package:fast_press/widgets/title/title_button.widget.dart';
import 'package:fast_press/widgets/title/title_word.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TitleScreen extends HookWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final bool heightOk = height > 670;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // await shouldUpdate(context);
      });
      return null;
    }, const []);

    firstSetting(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          const BackImage(
            imagePath: 'background.jpg',
          ),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: heightOk ? 150 : 50),
                const TitleWord(),
                const Spacer(),
                const TitleButton(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
