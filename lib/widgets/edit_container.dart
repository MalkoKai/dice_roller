import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditContainer extends StatefulWidget {
  const EditContainer({
    required this.dice,
    required this.onDiceChanged,
    super.key,
  });

  final Dice dice;
  final VoidCallback onDiceChanged;

  @override
  State<EditContainer> createState() => _EditContainerState();
}

class _EditContainerState extends State<EditContainer> {
  late final Dice _dice;
  bool _showDiceView = true; // true for dice view, false for theme view
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

  Widget showDiceOrTheme() {
    if (_showDiceView) {
      return Padding(
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
                    borderRadius: BorderRadius.circular(10),
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
                    child: Image.asset(diceIcons[index], width: 30, height: 30),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Themes coming soon!',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      //height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 20),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      _showDiceView ? Colors.black : Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _showDiceView = true;
                  });
                  HapticFeedback.lightImpact();
                },
                child: Text(
                  'Dice',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _showDiceView ? Colors.white : Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 10),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      _showDiceView ? Colors.grey.shade300 : Colors.black,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _showDiceView = false;
                  });
                  HapticFeedback.lightImpact();
                },
                child: Text(
                  'Theme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _showDiceView ? Colors.black : Colors.white,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 20),
          showDiceOrTheme(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
