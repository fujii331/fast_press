import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TitleWord extends HookWidget {
  const TitleWord({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fontSize = MediaQuery.of(context).size.width > 400 ? 40 : 33;

    return Stack(
      children: [
        SizedBox(
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                      width: 135,
                      child: Stack(
                        children: <Widget>[
                          Text(
                            '大人も子供も',
                            style: TextStyle(
                              fontSize: 23,
                              fontFamily: 'YuseiMagic',
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.pink.shade900,
                            ),
                          ),
                          Text(
                            '大人も子供も',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.pink.shade200,
                              fontFamily: 'YuseiMagic',
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Text(
                          '意外と\n頭の体操になる\n　　順番早押し',
                          style: TextStyle(
                            fontFamily: 'KaiseiOpti',
                            fontStyle: FontStyle.italic,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 7
                              ..color = Colors.grey.shade900,
                          ),
                        ),
                        Text(
                          '意外と\n頭の体操になる\n　　順番早押し',
                          style: TextStyle(
                            fontSize: fontSize + 3,
                            fontFamily: 'YuseiMagic',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: <Color>[
                                  Colors.yellow.shade400,
                                  Colors.yellow.shade500,
                                  Colors.red.shade200,
                                ],
                              ).createShader(
                                const Rect.fromLTWH(
                                  0.0,
                                  100.0,
                                  300.0,
                                  50.0,
                                ),
                              ),
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(8.0, 8.0),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
