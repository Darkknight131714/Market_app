import 'package:flutter/material.dart';
import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upi_india/upi_india.dart';
import 'package:upi_pay/upi_pay.dart';
final _firestore= FirebaseFirestore.instance;
UpiIndia _upiIndia = UpiIndia();
List<ApplicationMeta> appMetaList=[];

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
}

class _BuyScreenState extends State<BuyScreen> {
  UpiApp app = UpiApp.googlePay;
  List<ApplicationMeta> _apps=[];
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 0),()async{
      _apps = await UpiPay.getInstalledUpiApplications(statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
      print("KK");
      for(int i=0;i<_apps.length;i++){
        print(_apps[i].upiApplication);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    int cost=widget.cost;
    List<Item> cart=widget.cart;
    print(cost.toString());
    Firebase.initializeApp();
    getApps();
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
              doUpiTransaction(appMetaList[0]);
            }, child: Text("Buy")),
          ],
        ),
      ),
    );
  }
}
Future<UpiResponse> initiateTransaction(UpiApp app) async {
  return _upiIndia.startTransaction(
    app: app,
    receiverUpiId: "Divyanshumeena321@okicici",
    receiverName: 'Divyanshu',
    transactionRefId: 'Testing',
    transactionNote: 'Not actual. Just an example.',
    amount: 1.00,
  );
}
Future<void> getApps() async{
  appMetaList = await UpiPay.getInstalledUpiApplications(statusType: UpiApplicationDiscoveryAppStatusType.all);
  print("Bye");
  for(int i=0;i<appMetaList.length;i++){
    print(appMetaList[i].upiApplication);
  }
}
Future doUpiTransaction(ApplicationMeta appMeta) async {
  final UpiTransactionResponse response = await UpiPay.initiateTransaction(
    amount: '10.00',
    app: appMeta.upiApplication,
    receiverName: 'Divyanshu',
    receiverUpiAddress: 'Divyanshumeena321@okicici',
    transactionRef: 'UPITXREF0001',
    transactionNote: 'A UPI Transaction',
  );
  print(response.status);
}