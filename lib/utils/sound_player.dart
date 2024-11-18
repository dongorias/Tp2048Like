import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playWinSound() async {
    await _audioPlayer.play(AssetSource('/sounds/winner.wav'));
  }

  Future<void> playLoseSound() async {
    await _audioPlayer.play(AssetSource('sounds/lose.mp3'));
  }

  Future<void> playSwipSound() async {
    await _audioPlayer.play(AssetSource('sounds/swipe.mp3'));
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}