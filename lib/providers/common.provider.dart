import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

final soundEffectProvider = StateProvider((ref) => AudioCache());
final bgmProvider = StateProvider((ref) => AudioPlayer());
final bgmVolumeProvider = StateProvider((ref) => 0.2);
final seVolumeProvider = StateProvider((ref) => 0.5);
final normalClearedNumberProvider = StateProvider((ref) => 0);
final hardClearedNumberProvider = StateProvider((ref) => 0);
final veryHardClearedNumberProvider = StateProvider((ref) => 0);
final normalRecordsProvider = StateProvider((ref) => <String>[]);
final hardRecordsProvider = StateProvider((ref) => <String>[]);
final veryHardRecordsProvider = StateProvider((ref) => <String>[]);
final rebuildProvider = StateProvider((ref) => false);
