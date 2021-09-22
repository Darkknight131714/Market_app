import 'package:flutter/material.dart';
import 'main.dart';
class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        type: MaterialType.transparency,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text("Success")),
                Center(
                  child: TextButton(onPressed: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );}, child: Text("Go Back")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
