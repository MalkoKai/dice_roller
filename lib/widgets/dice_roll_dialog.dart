import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';

class DiceRollDialog extends StatefulWidget {
  const DiceRollDialog({required this.dice, super.key});

  final Dice dice;

  @override
  State<DiceRollDialog> createState() => _DiceRollDialogState();
}

class _DiceRollDialogState extends State<DiceRollDialog> {
  late final Dice _dice;
  bool _isFormulaLong = false;

  @override
  void initState() {
    super.initState();
    _dice = widget.dice;

    // Calcola se la formula è lunga dopo il primo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFormulaLength();
    });
  }

  void _checkFormulaLength() {
    // Calcola la larghezza approssimativa del testo
    final formula = _dice.getCurrentDiceExpression();
    final modifier = _dice.bonusDice;
    final modifierText =
        modifier != 0 ? ' ${modifier >= 0 ? '+' : ''}$modifier' : '';
    final fullText = formula + modifierText;

    // Stima: circa 10px per carattere al font size 18
    final textWidth = fullText.length * 10.0;
    final maxWidth =
        MediaQuery.of(context).size.width * 0.7; // 70% dello schermo

    setState(() {
      _isFormulaLong = textWidth > maxWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rollValues = _dice.currentDiceNums;
    final total = _dice.getTotalRoll();
    final modifier = _dice.bonusDice;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.purple.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                '🎲 Roll Result 🎲',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // Total Card - Grande e prominente
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade400.withOpacity(0.3),
                      Colors.green.shade600.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.green.shade300.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      total.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Formula Card - Swipeable con indicatore condizionale
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white,
                                  Colors.white,
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.05, 0.95, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _dice.getCurrentDiceExpression(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (modifier != 0) ...[
                                    Text(
                                      ' ${modifier >= 0 ? '+' : ''}$modifier',
                                      style: TextStyle(
                                        color:
                                            modifier >= 0
                                                ? Colors.green.shade300
                                                : Colors.red.shade300,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Icona swipe a destra - solo se la formula è lunga
                        if (_isFormulaLong)
                          Positioned(
                            right: 4,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.white.withOpacity(0.3),
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Hint text - solo se la formula è lunga
                  if (_isFormulaLong) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe,
                          size: 12,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Swipe to see full formula',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 20),

              // Individual Values - Chips stile moderno
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DICE VALUES',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children:
                        rollValues.map((value) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade400.withOpacity(0.4),
                                  Colors.blue.shade600.withOpacity(0.4),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.shade300.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // OK Button - Moderno
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple.shade900,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Got it!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
