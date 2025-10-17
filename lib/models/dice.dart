import 'dart:math';

class Dice {
  int _currentDiceNum = 1;
  final List<int> _currentDiceNums = [];
  int _currentDiceSize = 6;
  int _bonusDice = 0;
  int _multiplier = 1;
  final Random _randomizer = Random();
  final List<int> _diceSizes = [2, 4, 6, 8, 10, 12, 20, 100];
  final List<int> _diceCount = [0, 0, 0, 0, 0, 0, 0, 0];
  final Map<String, List<List<int>>> _diceRolls = {};
  final List<int> _totalRollsList = [];

  // Getters
  int get currentDiceNum => _currentDiceNum;
  List<int> get currentDiceNums => _currentDiceNums;
  int get currentDiceSize => _currentDiceSize;
  int get bonusDice => _bonusDice;
  int get multiplier => _multiplier;
  List<int> get diceSizes => _diceSizes;
  List<int> get diceCount => _diceCount;
  Map<String, List<List<int>>> get diceRolls => _diceRolls;
  List<int> get totalRollsList => _totalRollsList;

  // Methods
  void rollDice() {
    _currentDiceNums.clear();

    for (int i = 0; i < diceCount.length; ++i) {
      if (diceCount[i] > 0) {
        for (int s = 0; s < diceCount[i]; ++s) {
          _currentDiceNums.add(_randomizer.nextInt(diceSizes[i]) + 1);
        }
      }
    }
    _currentDiceNums.sort((a, b) => b.compareTo(a));

    Map<String, List<List<int>>> newRoll = {
      (_diceRolls.length + 1).toString(): [
        [
          diceCount[0],
          diceCount[1],
          diceCount[2],
          diceCount[3],
          diceCount[4],
          diceCount[5],
          diceCount[6],
          diceCount[7],
          _bonusDice,
        ],
        List<int>.from(_currentDiceNums),
      ],
    };

    _diceRolls.addEntries(newRoll.entries);

    _totalRollsList.add(getTotalRoll());
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

  void incrementDiceCount(int pos) {
    _diceCount[pos]++;
  }

  void decrementDiceCount(int pos) {
    if (_diceCount[pos] > 0) {
      _diceCount[pos]--;
    }
  }

  void resetDiceCount() {
    for (int i = 0; i < _diceCount.length; ++i) {
      diceCount[i] = 0;
    }
  }

  int getTypeDicesSelected() {
    int counter = 0;

    for (var i in _diceCount) {
      if (i != 0) counter++;
    }
    return counter;
  }

  int getTotalDiceCount() {
    int counter = 0;

    for (var i in _diceCount) {
      if (i != 0) {
        for (int s = 0; s < i; ++s) {
          counter++;
        }
      }
    }
    return counter;
  }

  int getTotalRoll() {
    int sum = _bonusDice;

    if (getTypeDicesSelected() == 0) {
      return sum;
    }

    for (var i in _currentDiceNums) {
      sum += i;
    }

    return sum;
  }

  String getRollExpression() {
    String expr = '';
    for (int i = 0; i < diceCount.length; ++i) {
      if (diceCount[i] > 0) {
        expr += "${diceCount[i]}d${diceSizes[i]} + ";
      }
    }
    return expr;
  }

  String getCurrentRollExpression(MapEntry<String, List<List<int>>> entry) {
    String curr = '';
    for (int i = 0; i < entry.value[0].length - 1; ++i) {
      if (entry.value[0][i] != 0) {
        curr += '${entry.value[0][i]}d${_diceSizes[i]} + ';
      }
    }
    curr +=
        '${entry.value[0][8]} = ${(entry.value[1].reduce((a, b) => a + b) + entry.value[0][8])}';
    return curr;
  }

  /// Returns only the dice expression part (e.g., "2d6 + 1d20")
  String getDiceExpressionOnly(MapEntry<String, List<List<int>>> entry) {
    List<String> parts = [];

    for (int i = 0; i < entry.value[0].length - 1; i++) {
      if (entry.value[0][i] > 0) {
        parts.add('${entry.value[0][i]}d${_diceSizes[i]}');
      }
    }

    if (parts.isEmpty) {
      return entry.value[0][8] != 0 ? '${entry.value[0][8]}' : 'No dice';
    }

    return parts.join(' + ');
  }

  /// Returns the total for a specific roll entry
  int getRollTotal(MapEntry<String, List<List<int>>> entry) {
    final values = entry.value[1];
    final bonusDice = entry.value[0][8];

    if (values.isEmpty) {
      return bonusDice;
    }

    return values.reduce((a, b) => a + b) + bonusDice;
  }

  /// Returns the bonus/modifier for a specific roll entry
  int getRollBonus(MapEntry<String, List<List<int>>> entry) {
    return entry.value[0][8];
  }

  /// Returns the current dice expression (e.g., "2d6 + 1d20")
  String getCurrentDiceExpression() {
    List<String> parts = [];

    for (int i = 0; i < _diceCount.length; i++) {
      if (_diceCount[i] > 0) {
        parts.add('${_diceCount[i]}d${_diceSizes[i]}');
      }
    }

    if (parts.isEmpty) {
      return _bonusDice != 0 ? '$_bonusDice' : 'No dice';
    }

    return parts.join(' + ');
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
