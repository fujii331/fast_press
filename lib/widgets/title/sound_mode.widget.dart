import 'package:fast_press/providers/common.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundMode extends HookWidget {
  final AudioCache soundEffect;

  const SoundMode({
    Key? key,
    required this.soundEffect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double bgmVolume = useProvider(bgmVolumeProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, size: 25, color: Colors.black),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
              bottom: 25,
            ),
            child: Text(
              'スライドして音量調節',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            width: double.infinity,
            child: const Text(
              'BGM音量',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'NotoSansJP',
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                inactiveTickMarkColor: Colors.green.shade100,
                activeTickMarkColor: Colors.green,
                thumbColor: Colors.green.shade600,
                activeTrackColor: Colors.green.shade500,
                inactiveTrackColor: Colors.green.shade100,
                overlayColor: Colors.green.withOpacity(0.15),
              ),
              child: Slider(
                value: bgmVolume * 100,
                min: 0,
                max: 100,
                divisions: 10,
                onChanged: (double value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  context.read(bgmProvider).state.setVolume(value * 0.01);
                  context.read(bgmVolumeProvider).state = value * 0.01;
                  prefs.setDouble('bgmVolume', value * 0.01);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            width: double.infinity,
            child: const Text(
              'SE音量',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'NotoSansJP',
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                inactiveTickMarkColor: Colors.green.shade100,
                activeTickMarkColor: Colors.green,
                thumbColor: Colors.green.shade600,
                activeTrackColor: Colors.green.shade500,
                inactiveTrackColor: Colors.green.shade100,
                overlayColor: Colors.green.withOpacity(0.15),
              ),
              child: Slider(
                value: seVolume * 100,
                min: 0,
                max: 100,
                divisions: 10,
                onChanged: (double value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  context.read(seVolumeProvider).state = value * 0.01;
                  prefs.setDouble('seVolume', value * 0.01);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
