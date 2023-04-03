import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/behavioral/obstaclable.dart';
import 'package:simple_western/behavioral/damagable.dart';

class Bullet extends PositionComponent with CollisionCallbacks {
  static const _strength = 1;
  static const _speed = 7;
  static const _distance = 400;
  static const _extraDistance = 250;
  static final _defaultSize = Vector2(5, 3);

  final double _directionModifier;
  late int _maxDistance;

  static final Paint paint = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0);
  static final Paint paint1 = Paint()
    ..color = const Color.fromARGB(255, 255, 212, 144);

  late Rect rect;
  late Rect rect1;

  final PositionComponent owner;

  Bullet(position, this._directionModifier, this.owner)
      : super(position: position, size: _defaultSize) {
    debugMode = GlobalConfig.debugMode;

    _maxDistance = Random().nextInt(_extraDistance) + _distance;
    if (_directionModifier < 0) {
      anchor = Anchor.topRight;
    }
  }

  @override
  Future<void> onLoad() async {
    // @TODO move position offset to player control.
    position.y += 46;
    if (_directionModifier > 0) {
      position.x += 72;
    } else {
      position.x += 3;
    }

    if (_directionModifier > 0) {
      rect = const Rect.fromLTWH(0, 0, 5, 3);
      rect1 = const Rect.fromLTWH(-28, 0, 28, 3);
    } else {
      rect = const Rect.fromLTWH(0, 0, 5, 3);
      rect1 = const Rect.fromLTWH(5, 0, 28, 3);
    }

    AudioSet.playBulletShot();
    add(RectangleHitbox(size: Vector2.all(10)));

    return super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (owner == other) {
      return;
    }

    if (other is Damagable) {
      AudioSet.play(AudioSet.bulletDelivery);
      other.damage(_strength);
    }

    if (other is Obstaclable) {
      parent?.remove(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x += _speed * _directionModifier;
    _maxDistance -= _speed;
    if (_maxDistance < 0) {
      parent?.remove(this);
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect1, paint1);
    canvas.drawRect(rect, paint);
  }
}
