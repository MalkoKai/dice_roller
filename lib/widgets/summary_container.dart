import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';

class SummaryContainer extends StatefulWidget {
  const SummaryContainer({
    required this.dice,
    required this.onDiceChanged,
    super.key,
  });

  final Dice dice;
  final VoidCallback onDiceChanged;
  @override
  State<SummaryContainer> createState() => _SummaryContainerState();
}

class _SummaryContainerState extends State<SummaryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        //color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              Spacer(),
              Column(
                children: [
                  Text(
                    'D${widget.dice.currentDiceSize}',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Text(
                    'Dice',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              Container(width: 1, height: 40, color: Colors.white),
              Spacer(),
              Column(
                children: [
                  Text(
                    'x${widget.dice.multiplier}',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Text(
                    'Multiplier',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              Container(width: 1, height: 40, color: Colors.white),
              Spacer(),
              Column(
                children: [
                  Text(
                    '${widget.dice.bonusDice}',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Text(
                    'Modifier',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
