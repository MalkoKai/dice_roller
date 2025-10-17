import 'package:dice_roller/widgets/dice_roll_dialog.dart';
import 'package:dice_roller/widgets/set_values_container.dart';
import 'package:dice_roller/widgets/summary_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake/shake.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:dice_roller/models/dice.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final double _shakeThreshold = 2;
  final bool _useFilter = false;
  final int _minimumShakeCount = 1;

  final GlobalKey _two = GlobalKey();

  @override
  void initState() {
    super.initState();
    _dice = Dice();
    _loadShakePreference();
  }

  Future<void> _loadShakePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('shake_to_roll_enabled') ?? false;
    if (enabled) {
      _startDetector();
    }
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }

  void _startDetector() async {
    // Check preference before starting
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('shake_to_roll_enabled') ?? false;

    if (!enabled) {
      // Don't start detector if disabled
      _detector?.stopListening();
      return;
    }

    // Stop previous detector if exists
    _detector?.stopListening();
    _detector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) async {
        // Controlla se ci sono dadi selezionati
        if (_dice.getTypeDicesSelected() == 0) {
          // Nessun dado selezionato, non rollare
          return;
        }

        setState(() {
          // Stop detecting shakes
          _detector?.stopListening();

          _dice.rollDice();
          HapticFeedback.heavyImpact();
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
      shakeCountResetTime: 2000,
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
      minHeight: MediaQuery.of(context).size.height * 0.12,
      onPanelOpened: () {
        _detector?.stopListening();
      },
      onPanelClosed: () async {
        // Controlla la preferenza prima di riavviare
        final prefs = await SharedPreferences.getInstance();
        final enabled = prefs.getBool('shake_to_roll_enabled') ?? false;
        if (enabled) {
          _startDetector();
        }
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
                    (_) => ShowCaseWidget.of(context).startShowCase([
                      _firstShowcaseWidget,
                      _two,
                      _lastShowcaseWidget,
                    ]),
                  );
                },
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 10),
          Showcase(
            key: _firstShowcaseWidget,
            description: 'Here there is an overview of the dice roll.',
            onBarrierClick: () {
              ShowCaseWidget.of(context).hideFloatingActionWidgetForKeys([
                _firstShowcaseWidget,
                _lastShowcaseWidget,
              ]);
            },
            tooltipActionConfig: const TooltipActionConfig(
              alignment: MainAxisAlignment.end,
              position: TooltipActionPosition.outside,
              gapBetweenContentAndAction: 10,
            ),
            tooltipActions: [
              TooltipActionButton(
                type: TooltipDefaultActionType.next,
                textStyle: const TextStyle(color: Colors.white),
                backgroundColor: Colors.blueAccent.shade700,
              ),
            ],
            child: SummaryContainer(
              dice: _dice,
              onDiceChanged: () {
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 10),
          Showcase(
            key: _two,
            description:
                'In order, here you can choose the dices to roll by tapping on it or removing it with a long press. Then you can set the Modifier. Tap the "Delete" button to reset the selected dices and the Modifier. Roll the dice by shaking your device or by tapping the "Roll" button.',
            onBarrierClick: () {
              ShowCaseWidget.of(context).hideFloatingActionWidgetForKeys([
                _firstShowcaseWidget,
                _lastShowcaseWidget,
              ]);
            },
            tooltipActionConfig: const TooltipActionConfig(
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        ],
      ),
      panel: Showcase(
        key: _lastShowcaseWidget,
        description:
            'Swipe up this panel to see the history of your dice rolls.',
        onBarrierClick: () {
          ShowCaseWidget.of(context).hideFloatingActionWidgetForKeys([
            _firstShowcaseWidget,
            _lastShowcaseWidget,
          ]);
        },
        tooltipActionConfig: const TooltipActionConfig(
          alignment: MainAxisAlignment.start,
          position: TooltipActionPosition.outside,
          gapBetweenContentAndAction: 10,
        ),
        tooltipPosition: TooltipPosition.top,
        child: Column(
          children: [
            //SizedBox(height: 5),
            Icon(Icons.horizontal_rule, size: 40),
            Text(
              'History',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _dice.diceRolls.length,
                itemBuilder: (context, index) {
                  final entry = _dice.diceRolls.entries.elementAt(index);
                  final rollNumber = entry.key;
                  final values = entry.value[1];
                  final bonusDice = _dice.getRollBonus(entry);
                  final total = _dice.getRollTotal(entry);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with roll number and total
                          Row(
                            children: [
                              // Roll number badge
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '#$rollNumber',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Dice expression
                              Expanded(
                                child: Text(
                                  _dice.getDiceExpressionOnly(entry),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Total result
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.functions,
                                      size: 16,
                                      color: Colors.green.shade700,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$total',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Divider
                          Container(height: 1, color: Colors.grey.shade200),
                          const SizedBox(height: 12),
                          // Individual values
                          Row(
                            children: [
                              Icon(
                                Icons.casino_outlined,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children:
                                      values.map((value) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue.shade100,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            '$value',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ],
                          ),
                          // Bonus modifier if present
                          if (bonusDice != 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Modifier: ${bonusDice > 0 ? '+' : ''}$bonusDice',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
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
