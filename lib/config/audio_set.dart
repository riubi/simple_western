import 'dart:math';

import 'package:flame_audio/flame_audio.dart';

class AudioSet {
  static const bulletAudio1 = 'bullet-1.mp3';
  static const bulletAudio2 = 'bullet-2.mp3';
  static const bulletAudio3 = 'bullet-3.mp3';
  static const bulletAudioMain = 'bullet-4.mp3';
  static const bulletDelivery = 'bullet-delivery.mp3';
  static const gunTrigger = 'gun-trigger.mp3';
  static const gunReload = 'gun-reload.mp3';
  static const gunEmptyClip = 'gun-empty-clip.mp3';

  static final bulletsAudio = [
    bulletAudio1,
    bulletAudio2,
    bulletAudio3,
    bulletAudioMain
  ];

  static const manDeath = 'man-death.mp3';

  static const match = 'match.mp3';
  static const lobby = 'lobby.mp3';
  static const intro = 'intro.mp3';

  static bool _audioEnabled = true;

  static Future<List<Uri>> preload() async {
    return FlameAudio.audioCache.loadAll([
      manDeath,
      match,
      lobby,
      intro,
      bulletAudio1,
      bulletAudio2,
      bulletAudio3,
      bulletAudioMain,
      bulletDelivery,
    ]);
  }

  static void preloadAndPlayIntro() async {
    await FlameAudio.audioCache.load(intro);
    playIntroAudio();
  }

  static void playMatchAudio() {
    _bgmPlay(match, .35);
  }

  static void playIntroAudio() {
    _bgmPlay(intro, .35);
  }

  static void playLobbyAudio() {
    _bgmPlay(lobby, .25);
  }

  static void playBulletShot() {
    final random = Random().nextInt(bulletsAudio.length * 3);
    if (random >= bulletsAudio.length) {
      play(bulletsAudio.elementAt(bulletsAudio.length - 1));
    } else {
      play(bulletsAudio.elementAt(random));
    }
  }

  static void play(String name, {double volume = 0.8}) {
    if (!_audioEnabled) {
      return;
    }

    FlameAudio.playLongAudio(name, volume: volume);
  }

  static void _bgmPlay(String match, double volume) {
    if (!_audioEnabled) {
      return;
    }

    if (FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.stop();
    }
    FlameAudio.bgm.play(match, volume: volume);
  }

  static bool isEnabled() {
    return _audioEnabled;
  }

  static void disable() {
    print('Audio disabled.');
    FlameAudio.bgm.stop();
    _audioEnabled = false;
  }

  static void enable() {
    print('Audio enabled.');

    _audioEnabled = true;
  }

  static void toogle() {
    isEnabled() ? disable() : enable();
  }
}
