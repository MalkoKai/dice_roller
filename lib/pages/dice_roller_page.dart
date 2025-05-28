import 'package:dice_roller/widgets/set_values_container.dart';
import 'package:dice_roller/widgets/summary_container.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:dice_roller/models/dice.dart';

class DiceRollerPage extends StatefulWidget {
  const DiceRollerPage({super.key});

  @override
  State<DiceRollerPage> createState() {
    return _DiceRollerPageState();
  }
}

class _DiceRollerPageState extends State<DiceRollerPage> {
  Dice _dice = Dice();

  @override
  void initState() {
    super.initState();
    _dice = Dice();
  }

  @override
  Widget build(context) {
    return SlidingUpPanel(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      parallaxEnabled: true,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      body: Column(
        children: [
          Spacer(),
          SummaryContainer(
            dice: _dice,
            onDiceChanged: () {
              setState(() {});
            },
          ),
          Spacer(),
          SetValuesContainer(
            dice: _dice,
            onDiceChanged: () {
              setState(() {});
            },
          ),
          SizedBox(height: 150),
        ],
      ),
      panel: Column(
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
    );
  }
}
