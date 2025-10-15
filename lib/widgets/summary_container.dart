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
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        //color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
        //border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total rolls",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                "${widget.dice.diceRolls.isNotEmpty ? widget.dice.diceRolls.length : "-"}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Last roll",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                '${widget.dice.totalRollsList.isNotEmpty ? widget.dice.totalRollsList.last : "-"}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        ],
      ),
    );
  }
}
