import 'package:flutter/material.dart';
import 'main.dart';
class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        type: MaterialType.transparency,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/error.png"),
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30,),
                  Center(child: Text("The Transaction Was Not successful, Click the button to go back.")),
                  Center(
                    child: TextButton(onPressed: (){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );},child: Text("Menu"),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
