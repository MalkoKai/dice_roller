import 'package:dice_roller/models/dice.dart';
import 'package:dice_roller/widgets/dice_roll_dialog.dart';
import 'package:dice_roller/widgets/quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetValuesContainer extends StatefulWidget {
  const SetValuesContainer({
    required this.dice,
    required this.onDiceChanged,
    required this.stopShakeDetection,
    required this.startShakeDetection,
    super.key,
  });

  final Dice dice;
  final VoidCallback onDiceChanged;
  final VoidCallback stopShakeDetection;
  final VoidCallback startShakeDetection;

  @override
  State<SetValuesContainer> createState() => _SetValuesContainerState();
}

class _SetValuesContainerState extends State<SetValuesContainer> {
  late final Dice _dice;
  int _selectedDiceIndex = 2; // Track selected dice size
  var temp = 2.0;

  @override
  void initState() {
    super.initState();
    _dice = widget.dice;
  }

  void customDice() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Custom Dice'),
            content: Text('Enter the number of sides for your custom dice.'),
            actions: [
              StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      Slider(
                        value: temp,
                        min: 2,
                        max: 100,
                        onChanged: (value) {
                          setState(() {
                            temp = value;
                          });
                        },
                      ),
                      Text('${temp.toInt()} sides'),
                    ],
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _dice.setCustomDiceSize(temp.toInt());
                    widget.onDiceChanged();
                  });
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Text('Confirm'),
              ),
            ],
          ),
    );
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
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            //height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                //long right arrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 30),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.black,
                    ),
                    Icon(Icons.arrow_forward, size: 30),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final diceIcons = [
                          'assets/images/dice_icons/icon-d2.png',
                          'assets/images/dice_icons/icon-d4.png',
                          'assets/images/dice_icons/icon-d6.png',
                          'assets/images/dice_icons/icon-d8.png',
                          'assets/images/dice_icons/icon-d10.png',
                          'assets/images/dice_icons/icon-d12.png',
                          'assets/images/dice_icons/icon-d20.png',
                          'assets/images/dice_icons/icon-d100.png',
                        ];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border.all(
                                color:
                                    _selectedDiceIndex == index
                                        ? Colors.black
                                        : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedDiceIndex = index;
                                  if (index == _dice.diceSizes.length - 1) {
                                    customDice();
                                  } else {
                                    _dice.changeDice(index);
                                    widget.onDiceChanged();
                                  }
                                });
                                HapticFeedback.lightImpact();
                              },
                              child: Image.asset(
                                diceIcons[index],
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
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
              onPressed: () async {
                // Stop shake detection before showing dialog
                widget.stopShakeDetection();

                setState(() {
                  _dice.rollDice();
                  HapticFeedback.heavyImpact();
                  widget.onDiceChanged();
                });

                // Show dialog and prevent dismissing by tapping outside
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => DiceRollDialog(dice: _dice),
                );

                // Restart shake detection after dialog is closed
                widget.startShakeDetection();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Column(
                children: [ 
                  Spacer(),
                  Text(
                    'ROLL',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        'or SHAKE YOUR DEVICE TO ROLL',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: 7),
                      Icon(Icons.vibration_rounded, color: Colors.black, size: 15),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
