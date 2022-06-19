import 'package:flutter/material.dart';

class BackImage extends StatelessWidget {
  final String imagePath;

  const BackImage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/common_back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Opacity(
          opacity: 0.65,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background/$imagePath'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
