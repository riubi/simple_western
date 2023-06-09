import 'dart:async';
import 'dart:io';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/ui/menu_builder.dart';

class Menu extends Component with HasGameRef, KeyboardHandler {
  static const lobbyAsset = 'assets/images/ui/logo.png';
  static const creditsAsset = 'assets/images/ui/credits.gif';

  final void Function() _duelInit;
  final void Function() _teamBattleInit;
  final void Function() _gameStop;
  bool _isMenuHiddable = false;

  Menu(this._duelInit, this._teamBattleInit, this._gameStop);

  @override
  FutureOr<void> onLoad() {
    gameRef.overlays
      ..addEntry(
        'LobbyMenu',
        (context, game) => MenuBuilder.buildMenu({
          'DUEL': _duelStart,
          'BATTLE': _battleStart,
          'OPTIONS': _menuSwitcher('Options'),
          'CREDITS': _menuSwitcher('Credits'),
        },
            header: Image.asset(
              lobbyAsset,
              fit: BoxFit.cover,
              color: Colors.black,
              colorBlendMode: BlendMode.softLight,
              width: 600,
            )),
      )
      ..addEntry(
        'PauseMenu',
        (context, game) => MenuBuilder.buildMenu({
          'NEW DUEL': _duelStart,
          'NEW BATTLE': _battleStart,
          'TO LOBBY': openLobbyMenu,
        }, title: 'PAUSED'),
      )
      ..addEntry(
        'Options',
        _optionsMenuBuilder,
      )
      ..addEntry(
        'Credits',
        _creditsMenuBuilder,
      )
      ..add('LobbyMenu');

    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      toogleMenu();
    }

    return true;
  }

  void openLobbyMenu() {
    _isMenuHiddable = false;
    _gameStop();

    gameRef
      ..resumeEngine()
      ..overlays.clear()
      ..overlays.add('LobbyMenu');
  }

  void openEndGameMenu() {
    _isMenuHiddable = false;

    gameRef
      ..overlays.clear()
      ..overlays.add('PauseMenu')
      ..pauseEngine();
  }

  void toogleMenu() {
    if (!_isMenuHiddable) {
      return;
    }

    if (gameRef.overlays.isActive('PauseMenu')) {
      gameRef
        ..resumeEngine()
        ..overlays.clear();
    } else {
      gameRef
        ..overlays.clear()
        ..overlays.add('PauseMenu')
        ..pauseEngine();
    }
  }

  void Function() _menuSwitcher(String title) => () => gameRef.overlays
    ..clear()
    ..add(title);

  void _duelStart() {
    _gameStart(_duelInit);
  }

  void _battleStart() {
    _gameStart(_teamBattleInit);
  }

  void _gameStart(void Function() gameInit) {
    _isMenuHiddable = true;
    gameRef.overlays.clear();
    gameInit();
    if (gameRef.paused) {
      gameRef.resumeEngine();
    }
  }

  void _exit(BuildContext context) {
    try {
      exit(0);
    } catch (e) {
      Navigator.of(context).pop(true);
    }
  }

  Widget _creditsMenuBuilder(context, game) => MenuBuilder.buildMenu(
        {'BACK': _menuSwitcher('LobbyMenu')},
        title: 'CREDITS',
        header: Column(
          textDirection: TextDirection.ltr,
          children: [
            Padding(
              padding: const EdgeInsets.all(60),
              child: Image.asset(creditsAsset, width: 700),
            ),
            _prepareCreditsText(),
          ],
        ),
      );

  Widget _optionsMenuBuilder(context, game) {
    String audioSwitcher =
        AudioSet.isEnabled() ? 'DISABLE AUDIO' : 'ENABLE AUDIO';

    return MenuBuilder.buildMenu({
      audioSwitcher: () {
        AudioSet.toogle();

        gameRef.overlays
          ..addEntry(
            'Options',
            _optionsMenuBuilder,
          )
          ..remove('Options')
          ..add('Options');
      },
      'BACK': _menuSwitcher('LobbyMenu')
    }, title: 'OPTIONS');
  }

  Text _prepareCreditsText() {
    return Text.rich(
      TextSpan(
        text: '',
        style: MenuBuilder.buildStyle(false, fontSize: 18, fontFamily: null),
        children: [
          const TextSpan(text: 'Contacts: clu@tut.by, '),
          MenuBuilder.buildUrl(
              'LinkedIn', 'https://www.linkedin.com/in/ruslan-papina/'),
          const TextSpan(text: ', '),
          MenuBuilder.buildUrl(
              'Github', 'https://github.com/riubi/simple_western'),
          const TextSpan(text: '\n'),
          const TextSpan(text: 'Assets created by: '),
          MenuBuilder.buildUrl('@dara90', 'https://www.fiverr.com/dara90'),
          const TextSpan(text: ', '),
          MenuBuilder.buildUrl(
              '@surajrenuka', 'https://www.fiverr.com/surajrenuka'),
        ],
      ),
    );
  }
}
