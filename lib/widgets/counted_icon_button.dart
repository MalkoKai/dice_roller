import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountedIconButton extends StatefulWidget {
  final Dice dice;
  final int index;
  final VoidCallback onPressed;
  final VoidCallback onDiceChanged;
  final String icon;

  const CountedIconButton({
    super.key,
    required this.dice,
    required this.index,
    required this.onPressed,
    required this.onDiceChanged,
    required this.icon,
  });

  @override
  State<CountedIconButton> createState() => _CountedIconButtonState();
}

class _CountedIconButtonState extends State<CountedIconButton> {
  late final Dice _dice;
  late final int _index;
  var temp = 2.0;

  static int maxPerType = 99;

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
  void initState() {
    super.initState();
    _dice = widget.dice;
    _index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //IconButton(icon: ImageIcon(AssetImage(icon)), onPressed: onPressed),
        Center(
          child: InkWell(
            onTap: () {
              if (_dice.diceCount[_index] < maxPerType) {
                setState(() {
                  _dice.incrementDiceCount(_index);
                  widget.onDiceChanged();
                });
                HapticFeedback.lightImpact();
              } else {
                final snackBar = SnackBar(
                  content: Text(
                    'The maximum number of dice for each type is $maxPerType.',
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  snackBar,
                  snackBarAnimationStyle: AnimationStyle(),
                );
              }
            },
            child: Image.asset(widget.icon, width: 40, height: 40),
          ),
        ),
        if (_dice.diceCount[_index] > 0)
          Positioned(
            right: 0,
            top: 0,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.blueAccent.shade700,
              child: Text(
                _dice.diceCount[_index].toString(),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
