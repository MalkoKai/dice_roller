import 'dart:math';

class Dice {
  int _currentDiceNum = 1;
  final List<int> _currentDiceNums = [];
  int _currentDiceSize = 6;
  int _bonusDice = 0;
  int _multiplier = 1;
  final Random _randomizer = Random();
  final List<int> _diceSizes = [2, 4, 6, 8, 10, 12, 20, 100];
  final Map<String, List<List<int>>> _diceRolls = {};

  // Getters
  int get currentDiceNum => _currentDiceNum;
  List<int> get currentDiceNums => _currentDiceNums;
  int get currentDiceSize => _currentDiceSize;
  int get bonusDice => _bonusDice;
  int get multiplier => _multiplier;
  List<int> get diceSizes => _diceSizes;
  Map<String, List<List<int>>> get diceRolls => _diceRolls;

  // Methods
  void rollDice() {
    _currentDiceNums.clear();

    for (int i = 0; i < _multiplier; i++) {
      _currentDiceNums.add(_randomizer.nextInt(_currentDiceSize) + 1);
    }

    _currentDiceNums.sort();

    Map<String, List<List<int>>> newRoll = {
      (_diceRolls.length + 1).toString(): [
        [_multiplier, _currentDiceSize, _bonusDice],
        List<int>.from(_currentDiceNums),
      ],
    };

    _diceRolls.addEntries(newRoll.entries);
  }

  void changeDice(int index) {
    if (_diceSizes[index] != 100) {
      _currentDiceSize = _diceSizes[index];
      _currentDiceNum = 1;
    }
  }

  void setCustomDiceSize(int size) {
    _currentDiceSize = size;
    _currentDiceNum = 1;
  }

  void plusDice() {
    if (_bonusDice <= 100) {
      _bonusDice++;
    }
  }

  void minusDice() {
    _bonusDice--;
  }

  void reset() {
    _bonusDice = 0;
    _multiplier = 1;
  }

  void setBonusDice(int value) {
    _bonusDice = value;
  }

  void setMultiplier(int value) {
    _multiplier = value;
  }

  int getTotalRoll() {
    if (_currentDiceNums.isEmpty) {
      return _bonusDice;
    }
    return _currentDiceNums.reduce((a, b) => a + b) + _bonusDice;
  }

  String getRollExpression() {
    return '${_multiplier}d$_currentDiceSize $_currentDiceNums + $_bonusDice';
  }

  void plusMultiplier() {
    if (_multiplier < 10) {
      _multiplier++;
    }
  }

  void minusMultiplier() {
    if (_multiplier > 1) {
      _multiplier--;
    }
  }
}
