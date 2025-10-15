import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  //late final Dice _dice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 60,
      //padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
        //border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              setState(() {
                if (widget.type == 'bonus' && widget.dice.bonusDice > -100) {
                  HapticFeedback.lightImpact();
                  widget.dice.minusDice();
                }
                if (widget.type == 'multiplier' && widget.dice.multiplier > 1) {
                  HapticFeedback.lightImpact();
                  widget.dice.minusMultiplier();
                }
                widget.onChanged();
              });
            },
            onLongPress: () {
              setState(() {
                if (widget.type == 'bonus') {
                  HapticFeedback.lightImpact();
                  widget.dice.setBonusDice(-100);
                }
                if (widget.type == 'multiplier') {
                  HapticFeedback.lightImpact();
                  widget.dice.setMultiplier(1);
                }
                widget.onChanged();
              });
            },
            child: Icon(Icons.remove, size: 35, color: Colors.black),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.12,
            child: Center(
              child: Text(
                widget.type == 'bonus'
                    ? widget.dice.bonusDice.toString()
                    : 'x${widget.dice.multiplier.toString()}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (widget.type == 'bonus' && widget.dice.bonusDice < 100) {
                  HapticFeedback.lightImpact();
                  widget.dice.plusDice();
                }
                if (widget.type == 'multiplier' &&
                    widget.dice.multiplier < 10) {
                  HapticFeedback.lightImpact();
                  widget.dice.plusMultiplier();
                }
                widget.onChanged();
              });
            },
            onLongPress: () {
              setState(() {
                if (widget.type == 'multiplier') {
                  HapticFeedback.lightImpact();
                  widget.dice.setMultiplier(10);
                }
                if (widget.type == 'bonus') {
                  HapticFeedback.lightImpact();
                  widget.dice.setBonusDice(100);
                }
                widget.onChanged();
              });
            },
            child: Icon(Icons.add, size: 35, color: Colors.black),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
