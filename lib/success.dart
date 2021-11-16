import 'package:flutter/material.dart';
import 'main.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';

class SuccessScreen extends StatefulWidget {
  String name, order;
  @override
  SuccessScreen({required this.name, required this.order});
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  String username = "depression131714@gmail.com", password = "prototype131714";
  @override
  void initState() {
    super.initState();
    sendi();
  }

  Future sendi() async {
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, widget.name)
      ..recipients.add('darkknight131714@gmail.com')
      ..subject = 'New Order from ${widget.name} ${DateTime.now()}'
      ..text = 'The Order is:\n ${widget.order}';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print("HHH");
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

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
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                      child: Text("Go Back")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
