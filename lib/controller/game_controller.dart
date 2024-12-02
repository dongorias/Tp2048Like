import 'dart:async';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../ui/game/game_screen.dart';
import '../utils/sound_player.dart';

enum SoundType { win, lose, swip }

class GameController with ChangeNotifier {
  List<List<int>> board = List.generate(4, (i) => List.filled(4, 0));

  final SoundPlayer _soundPlayer = SoundPlayer();


  bool _gameOver = false;
  bool get gameOver => _gameOver;

  final ValueNotifier<bool> _timerReset = ValueNotifier(false);
  ValueNotifier<bool> get timerReset => _timerReset;

  final ValueNotifier<bool> _timerRestart = ValueNotifier(false);
  ValueNotifier<bool> get timerRestart => _timerRestart;


  StreamSubscription<int>? timerSubscription;

  bool _gameWinner = false;
  bool get gameWinner => _gameWinner;

  int _moveCount = 0;
  int get moveCount => _moveCount;


  But _levelGoal = But.b2048;
  But get levelGoal => _levelGoal;

  late ConfettiController confettiController;

  bool _showQuitConfirmation = false;

  bool get showQuitConfirmation => _showQuitConfirmation;

  bool _isSoundEnabled = true;
  bool get isSoundEnabled => _isSoundEnabled;

  GameController() {
    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timerSubscription?.cancel();
    confettiController.dispose();
  }

  void checkAndPlayConfetti(bool condition) {
    if (condition) {
      confettiController.play();
    }
  }

void winnerFinish(){
  _gameWinner = false;
  _moveCount = 0;
  reset();
  notifyListeners();
}

void gameOverReset(){
  _gameWinner = false;
  _moveCount = 0;
  resetTimer(true);
  reset();
  notifyListeners();
}

  void handleValueChanged(But? newValue) {
    if (newValue == null) return;
    _levelGoal = newValue;
    reset();
    resetTimer(true);
    _moveCount = 0;
    notifyListeners();
  }

  void quitConfirmation() {
    _showQuitConfirmation = true;
    notifyListeners();
  }

  void reset() {
    // Réinitialise toutes les cases à 0
    board = List.generate(4, (i) => List.filled(4, 0));

    // Ajoute une nouvelle tuile pour commencer
    addNewTile();
    addNewTile();
    _gameOver = false;
    notifyListeners();
  }


  void _incrementMove() {
    if (_gameOver) return;
    _moveCount++;
    notifyListeners();
  }

  bool isGameOver() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) return false; // Il y a encore des cases vides

        // Vérifier si des mouvements sont possibles (fusion)
        if ((i > 0 && board[i][j] == board[i - 1][j]) || // Vers le haut
            (i < 3 && board[i][j] == board[i + 1][j]) || // Vers le bas
            (j > 0 && board[i][j] == board[i][j - 1]) || // Vers la gauche
            (j < 3 && board[i][j] == board[i][j + 1])) {
          // Vers la droite
          return false;
        }
      }
    }
    return true; // Pas de cases vides ni de fusions possibles
  }

  bool isGameWon() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == _levelGoal.value) return true;
      }
    }
    notifyListeners();
    return false;
  }

  void checkIfGameOverOrGameWon() {
    if (isGameOver()) {
      _gameOver = true;
      resetTimer(true);();
    } else if (isGameWon()) {
      _gameWinner = true;
      resetTimer(true);();
      checkAndPlayConfetti(true);
    }
    notifyListeners();
  }

  void addNewTile() {
    List<int> emptyPositions = [];
    // Trouver toutes les cases vides
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          emptyPositions
              .add(i * 4 + j); // Enregistre la position comme un index unique
        }
      }
    }

    if (emptyPositions.isNotEmpty) {
      // Choisir une position vide aléatoire
      int randomIndex =
          emptyPositions[math.Random().nextInt(emptyPositions.length)];
      int row = randomIndex ~/ 4; // Divise par 4 pour obtenir la ligne
      int col = randomIndex % 4; // Modulo 4 pour obtenir la colonne

      board[row][col] = 2;

      // // Ajouter une nouvelle tuile de valeur 2 ou 4
      // board[row][col] = Random().nextInt(10) < 9
      //     ? 2
      //     : 4; // 90% de chance pour un 2, 10% pour un 4
    }

    notifyListeners();
  }

  // Movement methods with shared logic
  void _performMove(void Function() movementLogic) {
    movementLogic();
    checkIfGameOverOrGameWon();
    addNewTile();
    _incrementMove();
    _restartTimer();
    playSound(SoundType.swip);
    notifyListeners();
  }

  void moveLeft() =>_performMove((){
    for (int i = 0; i < 4; i++) {
      board[i] = _mergeRow(board[i]);
    }
  });

  void moveRight() =>_performMove((){
    for (int i = 0; i < 4; i++) {
      board[i] = _mergeRow(board[i].reversed.toList()).reversed.toList();
    }
  });

  void moveUp() =>_performMove((){
    _transposeBoard();
    for (int i = 0; i < 4; i++) {
      board[i] = _mergeRow(board[i]);
    }
    _transposeBoard();
  });

  void moveDown() =>_performMove((){
    _transposeBoard();

    for (int i = 0; i < 4; i++) {
      board[i] = _mergeRow(board[i].reversed.toList()).reversed.toList();
    }

    _transposeBoard();
  });

  List<int> _mergeRow(List<int> row) {
    List<int> newRow = [];

    List<int> nonZeroTiles = row.where((tile) => tile != 0).toList();

    int skip = -1;

    for (int i = 0; i < nonZeroTiles.length; i++) {
      if (i == skip) continue;

      if (i + 1 < nonZeroTiles.length &&
          nonZeroTiles[i] == nonZeroTiles[i + 1]) {
        newRow.add(nonZeroTiles[i] * 2);

        skip = i + 1;
      } else {
        newRow.add(nonZeroTiles[i]);
      }
    }

    while (newRow.length < 4) {
      newRow.add(0);
    }

    return newRow;
  }

  void _transposeBoard() {
    for (int i = 0; i < 4; i++) {
      for (int j = i + 1; j < 4; j++) {
        int temp = board[i][j];
        board[i][j] = board[j][i];
        board[j][i] = temp;
      }
    }
  }


  void resetTimer(bool value) {
    _timerReset.value = value;
    notifyListeners();
  }
  void _restartTimer() {
    _timerRestart.value = true;
    notifyListeners();
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();

  }

  void playSound(SoundType soundType) {
    if (_isSoundEnabled) {
      switch (soundType) {
        case SoundType.win:
          _soundPlayer.playWinSound();
          break;
        case SoundType.lose:
          _soundPlayer.playLoseSound();
          break;
        case SoundType.swip:
          _soundPlayer.playSwipSound();
          break;
      }
    }
  }

}
