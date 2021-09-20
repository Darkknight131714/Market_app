import 'package:flutter/material.dart';
import 'item.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
final _firestore= Firestore.instance;
class BuyScreen extends StatefulWidget {
  @override
  int cost;
  List<Item> cart;
  BuyScreen({required this.cost,required this.cart});
  _BuyScreenState createState() => _BuyScreenState();
}
String order="";
void sendOrder(List<Item> cart)async{
  order="";
  for(int i=0;i<cart.length;i++){
    order+=" ";
    order+= cart[i].name;
    order+=" ";
    order+=cart[i].quantity.toString();
    order+="\n";
  }
  // final Email email = Email(
  //   body:order,
  //   subject: "New Order",
  //   recipients: ["darkknight131714@gmail.com"],
  //   isHTML: true,
  // );
  // await FlutterEmailSender.send(email);
  print("Mail Sent");
}
class _BuyScreenState extends State<BuyScreen> {
  @override
  Widget build(BuildContext context) {
    int cost=widget.cost;
    List<Item> cart=widget.cart;
    print(cost.toString());
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Column(
          children: [
            Text("Cost:"),
            Text(cost.toString()),
            TextButton(onPressed: (){
              sendOrder(cart);
              _firestore.collection('orders').add(
                  {
                    'name': "Meenakshi",
                    'buyid': "300",
                    'order': order,
                    'address': 'A wing 1104',
                  }
              );
              sendEmail();
            }, child: Text("Buy")),
          ],
        ),
      ),
    );
  }
}
void sendEmail() async{
  final email='darkknight131714@gmail.com';
  String username='dakdr131714@gmail.com';
  String password='prototype131714';
  final smtpServer=gmail(email,password);
  final message=Message()
    ..from=Address(email,'Gautam')
    ..recipients=['darkknight131714@gmail.com']
    ..subject='New Order'
    ..text='New Order Is placed on Firebase';
  try{
    await send(message,smtpServer);
    print("Mail Sent");
  }
  on MailerException catch(e){
    print(e);
  }
}