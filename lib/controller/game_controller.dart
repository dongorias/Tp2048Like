import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../utils/sound_player.dart';
enum SoundType { win, lose, swip }
class GameController with ChangeNotifier {
  List<List<int>> board = List.generate(4, (i) => List.filled(4, 0));

   final SoundPlayer _soundPlayer = SoundPlayer();

  int _compteurCoups = 0;

  bool _gameOver = false;
  bool get gameOver => _gameOver;



  bool _gameWinner = false;
  bool get gameWinner => _gameWinner;

  int get compteurCoups => _compteurCoups;

  bool _isRunning = false;

  bool get isRunning => _isRunning;

  late Timer _timer;
  int _currentSeconds = 0;

  int _levelGoal = 2048;

  int get levelGoal => _levelGoal;

  late ConfettiController confettiController;

  bool _showQuitConfirmation = false;
  bool get showQuitConfirmation => _showQuitConfirmation;

  GameController() {
    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    super.dispose();
    confettiController.dispose();
  }

  void checkAndPlayConfetti(bool condition) {
    if (condition) {
      confettiController.play();
    }
  }


  void quitConfirmation() {
    _showQuitConfirmation =true;
    notifyListeners();
  }

  void reset() {
    // Réinitialise toutes les cases à 0
    board = List.generate(4, (i) => List.filled(4, 0));

    // Ajoute une nouvelle tuile pour commencer
    addNewTile();
    addNewTile();
    //resetTimer();
    //startTimer();
    _gameOver = false;
    // Notifie les écouteurs du changement
    notifyListeners();
  }

  void resetCompte(){
    _compteurCoups = 0;
    notifyListeners();
  }

  void setGoal(int goal) {
    _levelGoal = goal;
    reset();
    notifyListeners();
  }

  void increment() {
    if (_gameOver) return;
    _compteurCoups++;
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
        if (board[i][j] == _levelGoal) return true;
      }
    }
    notifyListeners();
    return false;
  }

  void checkIfGameOverOrGameWon() {
    if (isGameOver()) {
      _gameOver = true;
    } else if (isGameWon()) {
      _gameWinner = true;
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
      int randomIndex = emptyPositions[math.Random().nextInt(emptyPositions.length)];
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

  void moveLeft() {
    for (int i = 0; i < 4; i++) {
      board[i] = _mergeRow(board[i]);
    }
    checkIfGameOverOrGameWon();
    addNewTile();
    increment();
    playSound(SoundType.swip);
    notifyListeners();
  }

  void moveRight() {
    for (int i = 0; i < 4; i++) {
      board[i] = _mergeRow(board[i].reversed.toList()).reversed.toList();
    }
    checkIfGameOverOrGameWon();
    addNewTile();
    increment();
    playSound(SoundType.swip);
    notifyListeners();
  }

  void moveUp() {
    _transposeBoard();

    for (int i = 0; i < 4; i++) {
      board[i] = _mergeRow(board[i]);
    }

    _transposeBoard();
    checkIfGameOverOrGameWon();
    addNewTile();
    increment();
    playSound(SoundType.swip);
    notifyListeners();
  }

  void moveDown() {
    _transposeBoard();

    for (int i = 0; i < 4; i++) {
      board[i] = _mergeRow(board[i].reversed.toList()).reversed.toList();
    }

    _transposeBoard();
    checkIfGameOverOrGameWon();
    addNewTile();
    increment();
    playSound(SoundType.swip);
    notifyListeners();
  }

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


  void startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentSeconds++;
      notifyListeners();
      log("_currentSeconds==>$_currentSeconds");
    });
  }

  void stopTimer() {
    _timer.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _currentSeconds = 0;
    _isRunning = false;
    if (!_isRunning) {
      startTimer();
    }
    notifyListeners();
  }

  void pauseTimer() {
    stopTimer();
  }

  String get timeDisplay {
    int minutes = _currentSeconds ~/ 60;
    int seconds = _currentSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }



  bool _isSoundEnabled = true;

  bool get isSoundEnabled => _isSoundEnabled;

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
