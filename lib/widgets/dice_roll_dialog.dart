import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';

class DiceRollDialog extends StatefulWidget {
  const DiceRollDialog({required this.dice, super.key});

  final Dice dice;

  @override
  State<DiceRollDialog> createState() => _DiceRollDialogState();
}

class _DiceRollDialogState extends State<DiceRollDialog> {
  late final Dice _dice;

  @override
  void initState() {
    super.initState();
    _dice = widget.dice;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rolled Dice', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          //DiceRoller(dice: _dice),
          Text(
            "Total",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w200,
            ),
          ),
          Text(
            _dice.getTotalRoll().toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Expression",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w200,
            ),
          ),
          FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _dice.getRollExpression(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '(${_dice.bonusDice})',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Values",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w200,
            ),
          ),
          Text(
            '[ ${_dice.currentDiceNums.join(', ')} ]',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: Text(
              'Ok',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
