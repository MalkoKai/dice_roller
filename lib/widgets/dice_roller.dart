import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';

class DiceRoller extends StatefulWidget {
  const DiceRoller({required this.dice, super.key});

  final Dice dice;

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller> {
  late final Dice _dice;

  @override
  void initState() {
    super.initState();
    _dice = widget.dice;
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      [20, 12, 10, 8, 6, 4, 2].contains(_dice.currentDiceSize)
          ? 'assets/images/dice_images/dice-d${_dice.currentDiceSize}-${_dice.currentDiceNums.isNotEmpty ? _dice.currentDiceNums.last : 1}.png'
          : 'assets/images/dice_icons/icon-d100.png',
      height: MediaQuery.of(context).size.height * 0.18,
    );
  }
}
