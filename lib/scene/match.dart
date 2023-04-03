import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/scene/battle.dart';
import 'package:simple_western/object/player.dart';

class Match extends Component {
  static final battlePosition = Vector2(230, 510);
  static final battleSize = Vector2(800, 320);

  final Set<Player> _players;
  late final Sprite _backgroundSprite;

  Match(this._players) {
    debugMode = GlobalConfig.debugMode;
  }

  @override
  Future<void> onLoad() async {
    await add(Battle(_players, battleSize, battlePosition));

    _backgroundSprite = await Sprite.load('backgrounds/background-1.png');

    await super.onLoad();

    // AudioSet.playMatchAudio();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = Colors.black;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1280, 840), paint);

    _backgroundSprite.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(1280, 840),
    );
  }
}