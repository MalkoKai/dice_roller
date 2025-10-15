import 'package:dice_roller/models/dice.dart';
import 'package:dice_roller/widgets/counted_icon_button.dart';
import 'package:dice_roller/widgets/dice_roll_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.07,
                      color: Colors.black,
                    ),
                    Text(
                      " Add dices ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.26,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: Text(
                        " ${widget.dice.getTotalDiceCount()} ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    height: 150,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        //childAspectRatio: 1,
                      ),
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
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: /*InkWell(
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
                                ),*/ CountedIconButton(
                                  dice: _dice,
                                  index: index,
                                  onPressed: () {},
                                  onDiceChanged: widget.onDiceChanged,
                                  icon: diceIcons[index],
                                ),
                              ),
                            ],
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
          SizedBox(height: 10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.07,
                      color: Colors.black,
                    ),
                    Text(
                      " Modifier ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                NumberPicker(
                  value: widget.dice.bonusDice,
                  haptics: true,
                  minValue: -100,
                  maxValue: 100,
                  step: 1,
                  itemCount: 7,
                  //itemHeight: 50,
                  itemWidth: MediaQuery.of(context).size.width * 0.11,
                  axis: Axis.horizontal,
                  selectedTextStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textStyle: TextStyle(fontSize: 12),
                  onChanged: (val) {
                    setState(() {
                      widget.dice.setBonusDice(val);
                      widget.onDiceChanged();
                    });
                  },
                ),
                Icon(Icons.arrow_drop_up_rounded),
                //SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            //height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _dice.resetDiceCount();
                          widget.onDiceChanged();
                        });
                      },
                      icon: Icon(
                        Icons.delete_forever_rounded,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (widget.dice.getTypeDicesSelected() != 0) {
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
                          } else {
                            const snackBar = SnackBar(
                              content: Text(
                                'Add at least one die to be able to roll!',
                              ),
                            );

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(snackBar);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                            /*Row(
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
                              Icon(
                                Icons.vibration_rounded,
                                color: Colors.black,
                                size: 15,
                              ),
                              Spacer(),
                            ],
                          ),*/
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _dice.reset();
                          widget.onDiceChanged();
                        });
                      },

                      icon: Icon(
                        Icons.restart_alt,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
