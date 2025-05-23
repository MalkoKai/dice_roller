import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';

class QuantityInput extends StatefulWidget {
  const QuantityInput({
    required this.dice,
    required this.onChanged,
    required this.type,
    super.key,
  });

  final Dice dice;
  final VoidCallback onChanged;
  final String type;

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  late final Dice _dice;

  @override
  void initState() {
    super.initState();
    _dice = widget.dice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 150,
      height: 40,
      //padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              setState(() {
                if (widget.type == 'bonus') {
                  _dice.minusDice();
                }
                if (widget.type == 'multiplier') {
                  _dice.minusMultiplier();
                }
                widget.onChanged();
              });
            },
            child: Icon(Icons.remove, size: 25, color: Colors.white),
          ),
          SizedBox(
            width: 60,
            child: Center(
              child: Text(
                widget.type == 'bonus'
                    ? _dice.bonusDice.toString()
                    : 'x${_dice.multiplier.toString()}',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (widget.type == 'bonus') {
                  _dice.plusDice();
                }
                if (widget.type == 'multiplier') {
                  _dice.plusMultiplier();
                }
                widget.onChanged();
              });
            },
            child: Icon(Icons.add, size: 25, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
