import 'package:dice_roller/models/dice.dart';
import 'package:dice_roller/widgets/dice_roller.dart';
import 'package:dice_roller/widgets/quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetValuesContainer extends StatefulWidget {
  const SetValuesContainer({
    required this.dice,
    required this.onDiceChanged,
    super.key,
  });

  final Dice dice;
  final VoidCallback onDiceChanged;

  @override
  State<SetValuesContainer> createState() => _SetValuesContainerState();
}

class _SetValuesContainerState extends State<SetValuesContainer> {
  late final Dice _dice;

  @override
  void initState() {
    super.initState();
    _dice = widget.dice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      //height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 20),
              Column(
                children: [
                  SizedBox(width: 30),
                  QuantityInput(
                    dice: _dice,
                    onChanged: widget.onDiceChanged,
                    type: 'multiplier',
                  ),
                  SizedBox(height: 20),
                  QuantityInput(
                    dice: _dice,
                    onChanged: widget.onDiceChanged,
                    type: 'bonus',
                  ),
                  SizedBox(width: 30),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 120,
                height: 140,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _dice.reset();
                      widget.onDiceChanged();
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: Icon(Icons.restart_alt, size: 40),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.1,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _dice.rollDice();
                  HapticFeedback.heavyImpact();
                  widget.onDiceChanged();
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(
                            'Rolled Dice',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.black,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DiceRoller(dice: _dice),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_dice.multiplier}d${_dice.currentDiceSize} + ${_dice.bonusDice} =',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    _dice.getTotalRoll().toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '[ ${_dice.currentDiceNums.join(', ')} ]',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
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
                        ),
                  );
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              child: Text(
                'Roll',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
