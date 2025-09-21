import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dice_roller/widgets/gradient_container.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {  
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GradientContainer('It\'s time to roll!', [
          Colors.blueGrey,
          Colors.black,
        ]),
      ),
    );
  }
}
