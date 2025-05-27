import 'package:dice_roller/widgets/dice_roller.dart';
import 'package:dice_roller/widgets/edit_container.dart';
import 'package:dice_roller/widgets/quantity_input.dart';
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
          SizedBox(height: 70),
          EditContainer(
            dice: _dice,
            onDiceChanged: () {
              setState(() {});
            },
          ),
          SizedBox(height: 50),
          DiceRoller(dice: _dice),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_dice.getRollExpression()} =',
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
          SizedBox(height: 50),
          Row(
            children: [
              SizedBox(width: 30),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'N. of Dices',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  QuantityInput(
                    dice: _dice,
                    onChanged: () {
                      setState(() {});
                    },
                    type: 'multiplier',
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('', style: TextStyle(color: Colors.white)),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _dice.reset();
                      });
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    icon: Icon(Icons.restart_alt),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Modifier',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  QuantityInput(
                    dice: _dice,
                    onChanged: () {
                      setState(() {});
                    },
                    type: 'bonus',
                  ),
                ],
              ),
              SizedBox(width: 30),
            ],
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _dice.rollDice();
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: Text(
              'Roll',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
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
