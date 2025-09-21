import 'package:dice_roller/widgets/dice_roll_dialog.dart';
import 'package:dice_roller/widgets/set_values_container.dart';
import 'package:dice_roller/widgets/summary_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:dice_roller/models/dice.dart';

/// Global key for the first showcase widget
final GlobalKey _firstShowcaseWidget = GlobalKey();

/// Global key for the last showcase widget
final GlobalKey _lastShowcaseWidget = GlobalKey();

class DiceRollerPage extends StatefulWidget {
  const DiceRollerPage({super.key});

  @override
  State<DiceRollerPage> createState() {
    return _DiceRollerPageState();
  }
}

class _DiceRollerPageState extends State<DiceRollerPage> {
  Dice _dice = Dice();

  ShakeDetector? _detector;
  String _lastShakeInfo = 'No shake detected yet';
  final double _shakeThreshold = 1.5;
  final bool _useFilter = false;
  final int _minimumShakeCount = 2;

  final GlobalKey _two = GlobalKey();

  @override
  void initState() {
    super.initState();
    _dice = Dice();

    _startDetector();
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }

  void _startDetector() {
    // Stop previous detector if exists
    _detector?.stopListening();
    _detector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) async {
        setState(() {
          // Stop detecting shakes
          _detector?.stopListening();

          _dice.rollDice();
          HapticFeedback.heavyImpact();

          _lastShakeInfo =
              'Shake detected:\n'
              'Direction: ${event.direction}\n'
              'Force: ${event.force.toStringAsFixed(2)}\n'
              'Time: ${event.timestamp.toString()}';
        });
        await showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing by tapping outside
          builder: (context) {
            return DiceRollDialog(dice: _dice);
          },
        );

        // Restart shake detection after dialog is closed
        _startDetector();
      },
      minimumShakeCount: _minimumShakeCount,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: _shakeThreshold,
      useFilter: _useFilter,
    );
  }

  @override
  Widget build(context) {
    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      parallaxEnabled: true,
      backdropEnabled: true,
      onPanelOpened: () {
        _detector?.stopListening();
      },
      onPanelClosed: () {
        _startDetector();
      },
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      body: Column(
        children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 30),
              IconButton(
                icon: Icon(Icons.help_outline, color: Colors.white),
                tooltip: 'Guided Tour',
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => ShowCaseWidget.of(context).startShowCase(
                        [_firstShowcaseWidget, _two, _lastShowcaseWidget]),
                  );
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.white),
                tooltip: 'Info',
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Dice Roller',
                    applicationVersion: '1.0.1',
                    applicationLegalese:
                        'Developed with love, passion and Italian hands by MalkoKai\n\n'
                        'Contact me at malkokaidev@gmail.com for feedbacks, suggestions or just to say hi!',
                  );
                },
              ),
              SizedBox(width: 30),
            ],
          ),
          Spacer(),
          Showcase(
            key: _firstShowcaseWidget,
            description: 'Here there is a summary of your current dice settings, with:\n - Dice size (D2, D4, ...)\n - Multiplier (how many dice to roll)\n - Modifier (a value to add or subtract to the final result).',
            onBarrierClick: () {
              ShowCaseWidget.of(context)
                  .hideFloatingActionWidgetForKeys([
                _firstShowcaseWidget,
                _lastShowcaseWidget
              ]);
            },
            tooltipActionConfig:
                const TooltipActionConfig(
              alignment: MainAxisAlignment.end,
              position: TooltipActionPosition.outside,
              gapBetweenContentAndAction: 10,
            ),
            tooltipActions: [
              TooltipActionButton(
                type: TooltipDefaultActionType.next,
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
            child: SummaryContainer(
              dice: _dice,
              onDiceChanged: () {
                setState(() {});
              },
            ),  
          ),        
          Spacer(),
          Showcase(
            key: _two,
            description: 'In order, here you can set the Dice size (tapping the dice icons), the Multiplier, the Modifier or reset all values to default.\nHold the + and - buttons to set the maximum and minimum values.\nRoll the dice by shaking your device or by tapping the "Roll" button.',
            onBarrierClick: () {
              ShowCaseWidget.of(context)
                  .hideFloatingActionWidgetForKeys([
                _firstShowcaseWidget,
                _lastShowcaseWidget
              ]);
            },
            tooltipActionConfig:
                const TooltipActionConfig(
              alignment: MainAxisAlignment.start,
              position: TooltipActionPosition.outside,
              gapBetweenContentAndAction: 10,
            ),
            tooltipPosition: TooltipPosition.top,
            child: SetValuesContainer(
              dice: _dice,
              onDiceChanged: () {
                setState(() {});
              },
              stopShakeDetection: () => _detector?.stopListening(),
              startShakeDetection: _startDetector,
            ),
          ), 
          SizedBox(height: 150),
        ],
      ),
      panel: Showcase(
            key: _lastShowcaseWidget,
            description: 'Swipe up this panel to see the history of your dice rolls.',
            onBarrierClick: () {
              ShowCaseWidget.of(context)
                  .hideFloatingActionWidgetForKeys([
                _firstShowcaseWidget,
                _lastShowcaseWidget
              ]);
            },
            tooltipActionConfig:
                const TooltipActionConfig(
              alignment: MainAxisAlignment.start,
              position: TooltipActionPosition.outside,
              gapBetweenContentAndAction: 10,
            ),
            tooltipPosition: TooltipPosition.top,
            child: Column(
              children: [
                SizedBox(height: 5),
                Icon(Icons.horizontal_rule, size: 40),
                Text(
                  'Dice Rolls',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _dice.diceRolls.length,
                    itemBuilder: (context, index) {
                      final entry = _dice.diceRolls.entries.elementAt(index);
                      return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                'N.${entry.key}: ${entry.value[0][0]}d${entry.value[0][1]} + ${entry.value[0][2]} = ${(entry.value[1].reduce((a, b) => a + b) + entry.value[0][2])}',
                              ),
                              subtitle: Text('Values: ${entry.value[1].join(', ')}'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ), 
    );
  }
}
