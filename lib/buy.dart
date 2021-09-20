import 'package:flutter/material.dart';
import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
final _firestore= FirebaseFirestore.instance;
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
    Firebase.initializeApp();
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Column(
          children: [
            Text("Cost:"),
            Text(cost.toString()),
            TextButton(onPressed: (){
              sendOrder(cart);
              print("HELLO");
              _firestore.collection('orders').add(
                  {
                    'name': "Meenakshi",
                    'buyid': "300",
                    'order': order,
                    'address': 'A wing 1104',
                  }
              );
            }, child: Text("Buy")),
          ],
        ),
      ),
    );
  }
}