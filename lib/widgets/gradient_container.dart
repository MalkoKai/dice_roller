import 'dart:developer';

import 'package:dice_roller/pages/dice_roller_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';

/// Global key for the first showcase widget
final GlobalKey _firstShowcaseWidget = GlobalKey();

/// Global key for the last showcase widget
final GlobalKey _lastShowcaseWidget = GlobalKey();

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.text, this.colors, {super.key});

  final String text;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ShowCaseWidget(
          hideFloatingActionWidgetForShowcase: [_lastShowcaseWidget],
          globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
            left: 16,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: ShowCaseWidget.of(showcaseContext).dismiss,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color( 0xFF444444)
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          onStart: (index, key) {
            log('onStart: $index, $key');
          },
          onComplete: (index, key) {
            log('onComplete: $index, $key');
            if (index == 4) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle.light.copyWith(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.white,
                ),
              );
            }
          },
          blurValue: 1,
          autoPlayDelay: const Duration(seconds: 3),
          builder: (context) => const DiceRollerPage(),
          globalTooltipActionConfig: const TooltipActionConfig(
            position: TooltipActionPosition.inside,
            alignment: MainAxisAlignment.spaceBetween,
            actionGap: 20,
          ),
          globalTooltipActions: [
            // Here we don't need previous action for the first showcase widget
            // so we hide this action for the first showcase widget
            TooltipActionButton(
              type: TooltipDefaultActionType.previous,
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              hideActionWidgetForShowcase: [_firstShowcaseWidget],
            ),
            // Here we don't need next action for the last showcase widget so we
            // hide this action for the last showcase widget
            TooltipActionButton(
              type: TooltipDefaultActionType.next,
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              hideActionWidgetForShowcase: [_lastShowcaseWidget],
            ),
          ],
        ),
    );
  }
}
