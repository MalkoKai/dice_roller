import 'package:dice_roller/models/dice.dart';
import 'package:flutter/material.dart';

class SummaryContainer extends StatefulWidget {
  const SummaryContainer({
    required this.dice,
    required this.onDiceChanged,
    super.key,
  });

  final Dice dice;
  final VoidCallback onDiceChanged;
  @override
  State<SummaryContainer> createState() => _SummaryContainerState();
}

class _SummaryContainerState extends State<SummaryContainer> {
  int counter = 0;

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Widget per gli indicatori a pallini
  Widget _buildPageIndicator(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                _currentPage == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // Pagina 1: Tutte le statistiche - Design moderno
  Widget _buildStatsPage() {
    final hasRolls = widget.dice.totalRollsList.isNotEmpty;

    final totalRolls = widget.dice.diceRolls.length;
    final lastRoll =
        widget.dice.totalRollsList.isNotEmpty
            ? widget.dice.totalRollsList.last
            : 0;

    final avg =
        hasRolls
            ? widget.dice.totalRollsList.reduce((a, b) => a + b) /
                widget.dice.totalRollsList.length
            : 0.0;

    final highest =
        hasRolls
            ? widget.dice.totalRollsList.reduce((a, b) => a > b ? a : b)
            : 0;

    final lowest =
        hasRolls
            ? widget.dice.totalRollsList.reduce((a, b) => a < b ? a : b)
            : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Riga principale: Total e Last Roll (più prominenti)
          Row(
            children: [
              Expanded(
                child: _buildMainStatCard(
                  icon: Icons.format_list_numbered_rounded,
                  label: "Total Rolls",
                  value: hasRolls ? "$totalRolls" : "-",
                  color: Colors.blue.shade400,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMainStatCard(
                  icon: Icons.casino_outlined,
                  label: "Last Roll",
                  value: hasRolls ? "$lastRoll" : "-",
                  color: Colors.green.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Riga secondaria: Avg, High, Low (più compatti)
          Row(
            children: [
              Expanded(
                child: _buildSecondaryStatCard(
                  label: "Avg",
                  value: hasRolls ? avg.toStringAsFixed(1) : "-",
                  icon: Icons.trending_flat_rounded,
                ),
              ),
              Expanded(
                child: _buildSecondaryStatCard(
                  label: "High",
                  value: hasRolls ? "$highest" : "-",
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
              Expanded(
                child: _buildSecondaryStatCard(
                  label: "Low",
                  value: hasRolls ? "$lowest" : "-",
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Card moderna per le statistiche principali
  Widget _buildMainStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Stat compatte per riga secondaria
  Widget _buildSecondaryStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          //Icon(icon, size: 16, color: Colors.white70),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  // Pagina 2: Riassunto dadi selezionati con formula smart
  Widget _buildDiceSelectionPage() {
    final totalDice = widget.dice.getTotalDiceCount();
    final hasSelection = totalDice > 0;
    final modifier = widget.dice.bonusDice;

    if (!hasSelection) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.casino_outlined,
                size: 32,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "No dice selected",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      );
    }

    // Calcola range min-max
    final minRoll = totalDice + modifier;
    int maxRoll = modifier;
    for (int i = 0; i < widget.dice.diceCount.length; i++) {
      maxRoll += widget.dice.diceCount[i] * widget.dice.diceSizes[i];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header con titolo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.style_outlined,
                      size: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Current Setup",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade400.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.casino, size: 11, color: Colors.white),
                    const SizedBox(width: 3),
                    Text(
                      "$totalDice",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Formula smart con scroll orizzontale
          _buildSmartFormulaScroll(),

          const SizedBox(height: 10),

          // Barra range con min/max
          _buildRangeVisualization(minRoll, maxRoll),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Formula compatta e intelligente
  String _buildCompactFormula() {
    List<String> parts = [];

    for (int i = 0; i < widget.dice.diceCount.length; i++) {
      if (widget.dice.diceCount[i] > 0) {
        final count = widget.dice.diceCount[i];
        final sides = widget.dice.diceSizes[i];

        // Se count = 1, non mostrare "1×"
        parts.add(count > 1 ? '${count}d$sides' : 'd$sides');
      }
    }

    String formula = parts.join(' + ');

    // Aggiungi modificatore
    final mod = widget.dice.bonusDice;
    if (mod != 0) {
      formula += ' ${mod > 0 ? '+ ' : ''}$mod';
    }

    return formula.isEmpty ? 'No dice' : formula;
  }

  // Widget per la formula con scroll e fade edges
  Widget _buildSmartFormulaScroll() {
    final formula = _buildCompactFormula();

    return SizedBox(
      height: 28,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: const [0.0, 0.1, 0.9, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Text(
              formula,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  // Visualizzazione range con barra e media
  Widget _buildRangeVisualization(int minRoll, int maxRoll) {
    final range = maxRoll - minRoll;

    // Calcola la media attesa
    double expectedAvg = widget.dice.bonusDice.toDouble();
    for (int i = 0; i < widget.dice.diceCount.length; i++) {
      if (widget.dice.diceCount[i] > 0) {
        // Media di un dado = (min + max) / 2 = (1 + sides) / 2
        final diceSides = widget.dice.diceSizes[i];
        final avgPerDie = (1 + diceSides) / 2;
        expectedAvg += widget.dice.diceCount[i] * avgPerDie;
      }
    }

    // Calcola la posizione della media nella barra (0.0 - 1.0)
    final percentage = range > 0 ? (expectedAvg - minRoll) / range : 0.5;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: [
          // Barra progresso con media
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Labels min/max
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRangeLabel("Min", minRoll, Icons.arrow_downward_rounded),
              Text(
                "Expected: ${expectedAvg.toStringAsFixed(1)}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildRangeLabel("Max", maxRoll, Icons.arrow_upward_rounded),
            ],
          ),
        ],
      ),
    );
  }

  // Label per min/max
  Widget _buildRangeLabel(String label, int value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white.withOpacity(0.6)),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 8,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "$value",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        //border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          // PageView per le diverse pagine
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [_buildDiceSelectionPage(), _buildStatsPage()],
            ),
          ),

          // Indicatori dei pallini
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildPageIndicator(2),
          ),
        ],
      ),
    );
  }
}
