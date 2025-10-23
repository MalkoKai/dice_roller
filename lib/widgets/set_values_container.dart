import 'package:dice_roller/models/dice.dart';
import 'package:dice_roller/pages/paywall_adapty.dart';
import 'package:dice_roller/widgets/counted_icon_button.dart';
import 'package:dice_roller/widgets/dice_roll_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class SetValuesContainer extends StatefulWidget {
  const SetValuesContainer({
    required this.dice,
    required this.onDiceChanged,
    required this.stopShakeDetection,
    required this.startShakeDetection,
    required this.onStartGuidedTour,
    this.showcaseKeys,
    super.key,
  });

  final Dice dice;
  final VoidCallback onDiceChanged;
  final VoidCallback stopShakeDetection;
  final VoidCallback startShakeDetection;
  final VoidCallback onStartGuidedTour;
  final List<GlobalKey>? showcaseKeys;

  @override
  State<SetValuesContainer> createState() => _SetValuesContainerState();
}

class _SetValuesContainerState extends State<SetValuesContainer> {
  late final Dice _dice;
  var temp = 2.0;
  bool _shakeToRollEnabled = false;

  @override
  void initState() {
    super.initState();
    _dice = widget.dice;
    _loadShakePreference();
  }

  Future<void> _loadShakePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shakeToRollEnabled = prefs.getBool('shake_to_roll_enabled') ?? false;
    });
  }

  Future<void> _saveShakePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shake_to_roll_enabled', value);
    setState(() {
      _shakeToRollEnabled = value;
    });

    // Avvia o ferma il detector in base al valore
    if (value) {
      widget.startShakeDetection();
    } else {
      widget.stopShakeDetection();
    }
  }

  // Add this method inside _SetValuesContainerState class
  Future<void> _simulateDiceRoll() async {
    // Number of vibrations to simulate rolling
    const int vibrationCount = 8;

    // Pattern: start fast, then slow down (like real dice)
    final delays = [
      50, // Fast
      60, //
      80, // Getting slower
      100, //
      120, //
      150, //
      180, //
      220, // Final roll
    ];

    for (int i = 0; i < vibrationCount; i++) {
      HapticFeedback.heavyImpact();
      await Future.delayed(Duration(milliseconds: delays[i]));
    }
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
          Showcase(
            key: widget.showcaseKeys![0],
            description:
                'Tap on the icons to add a dice to your roll.\nHold to remove one.',
            tooltipActionConfig: const TooltipActionConfig(
              alignment: MainAxisAlignment.start,
              position: TooltipActionPosition.outside,
              gapBetweenContentAndAction: 10,
            ),
            tooltipPosition: TooltipPosition.top,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
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
                        width: MediaQuery.of(context).size.width * 0.38,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
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

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CountedIconButton(
                          dice: _dice,
                          index: index,
                          onPressed: () {},
                          onDiceChanged: widget.onDiceChanged,
                          icon: diceIcons[index],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Showcase(
            key: widget.showcaseKeys![1],
            description:
                'Swipe to select the desired modifier, which will be added to or subtracted from your dice roll total.',
            tooltipActionConfig: const TooltipActionConfig(
              alignment: MainAxisAlignment.start,
              position: TooltipActionPosition.outside,
              gapBetweenContentAndAction: 10,
            ),
            tooltipPosition: TooltipPosition.top,
            child: Container(
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
                    itemCount: 5,
                    //itemHeight: 50,
                    itemWidth: MediaQuery.of(context).size.width * 0.13,
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
                    Showcase(
                      key: widget.showcaseKeys![2],
                      description: 'Tap to reset all dice and modifier values.',
                      tooltipActionConfig: const TooltipActionConfig(
                        alignment: MainAxisAlignment.start,
                        position: TooltipActionPosition.outside,
                        gapBetweenContentAndAction: 10,
                      ),
                      tooltipPosition: TooltipPosition.top,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _dice.resetDiceCount();
                            _dice.setBonusDice(0);
                            widget.onDiceChanged();
                          });
                        },
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Showcase(
                      key: widget.showcaseKeys![3],
                      description: 'Tap this button to roll the dice.',
                      tooltipActionConfig: const TooltipActionConfig(
                        alignment: MainAxisAlignment.start,
                        position: TooltipActionPosition.outside,
                        gapBetweenContentAndAction: 10,
                      ),
                      tooltipPosition: TooltipPosition.top,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (widget.dice.getTypeDicesSelected() != 0) {
                              // Stop shake detection before showing dialog
                              widget.stopShakeDetection();

                              setState(() {
                                _dice.rollDice();
                                _simulateDiceRoll();
                                widget.onDiceChanged();
                              });

                              // Show dialog and prevent dismissing by tapping outside
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (context) => DiceRollDialog(dice: _dice),
                              );

                              // Restart shake detection only if enabled
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final enabled =
                                  prefs.getBool('shake_to_roll_enabled') ??
                                  false;
                              if (enabled) {
                                widget.startShakeDetection();
                              }
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
                    ),
                    SizedBox(width: 10),
                    Showcase(
                      key: widget.showcaseKeys![4],
                      description:
                          'Here you can find more settings and information about the app/creator.',
                      tooltipActionConfig: const TooltipActionConfig(
                        alignment: MainAxisAlignment.start,
                        position: TooltipActionPosition.outside,
                        gapBetweenContentAndAction: 10,
                      ),
                      tooltipPosition: TooltipPosition.top,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            showAboutDialog(
                              barrierDismissible: false,
                              context: context,
                              applicationName: 'Dice Roller',
                              applicationVersion: '1.1.3',
                              applicationLegalese:
                                  'Developed with love, passion and Italian hands by malkokai\n\n'
                                  'Contact me at malkokaidev@gmail.com for feedbacks, suggestions or just to say hi!',
                              children: [
                                SizedBox(height: 20),
                                PaywallAdapty(),
                                SizedBox(height: 20),
                                StatefulBuilder(
                                  builder: (context, setDialogState) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: SwitchListTile(
                                        value: _shakeToRollEnabled,
                                        onChanged: (value) async {
                                          await _saveShakePreference(value);
                                          setDialogState(
                                            () {},
                                          ); // Aggiorna il dialog
                                        },
                                        title: Text(
                                          'Shake to Roll',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Enable rolling dice by shaking your device',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        activeColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Need help?',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Start a guided tour',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        //width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            widget.onStartGuidedTour();
                                          },
                                          label: Text('Start Tour'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade700,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                            widget.onDiceChanged();
                          });
                        },
                        icon: Icon(
                          Icons.settings_rounded,
                          size: 40,
                          color: Colors.black,
                        ),
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
