import 'package:flutter/material.dart';
import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upi_pay/upi_pay.dart';
import 'error.dart';
import 'success.dart';
final _firestore= FirebaseFirestore.instance;
List<ApplicationMeta> appMetaList=[];
int curr=-1;
String status="",name="",address="",number="",buyid="";
bool upi=true,cod=false;
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
  List<ApplicationMeta> _apps=[];
  void initState(){
    status="";
    name="";
    address="";
    number="";
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Text("Cost:   "+cost.toString()),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Name: "),
                  Flexible(child: TextField(
                    keyboardType: TextInputType.name,
                    onChanged: (value){
                      name=value;
                    },
                  ),)
                ],
              ),
              Row(
                children: [
                  Text("Address: "),
                  Flexible(child: TextField(
                    keyboardType: TextInputType.name,
                    onChanged: (value){
                      address=value;
                    },
                  ),)
                ],
              ),
              Row(
                children: [
                  Text("Number: "),
                  Flexible(child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value){
                      number=value;
                    },
                  ),)
                ],
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Payment Method:   "),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        cod=upi;
                        upi=!upi;
                      });
                    },
                    child: Container(
                      color: (upi==true)?Colors.greenAccent:Colors.blueGrey,
                      height: 50,
                      width: 50,
                      child: Text("UPI"),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        cod=upi;
                        upi=!upi;
                      });
                    },
                    child: Container(
                      color: (cod==true)?Colors.greenAccent:Colors.blueGrey,
                      height: 50,
                      width: 50,
                      child: Text("COD"),
                    ),
                  ),
                ],
              ),
              TextButton(onPressed: ()async {
                sendOrder(cart);
                if(cod==true){
                  _firestore.collection('orders').add(
                      {
                        'name': name,
                        'buyid': "Cash On Delivery",
                        'order': order,
                        'address': address,
                        'number': number,
                        'price' : cost.toString(),
                      }
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SuccessScreen())
                  );
                }
                else{
                  showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
                    title: Text("UPIs"+appMetaList.length.toString()),
                    actions: [
                      Container(
                        height: 300,
                        width: 300,
                        child: (appMetaList.length==0)?Text("No UPI INSTALLED"): ListView.builder(
                            itemCount: appMetaList.length,
                            itemBuilder: (BuildContext context,int index){
                              return Container(
                                child: GestureDetector(
                                    onTap: ()async{
                                      curr=index;
                                      await doUpiTransaction(appMetaList[curr]);
                                      if(status=="UpiTransactionStatus.success"){
                                        _firestore.collection('orders').add(
                                            {
                                              'name': name,
                                              'buyid': buyid,
                                              'order': order,
                                              'address': address,
                                              'number': number,
                                              'price' : cost.toString(),
                                            }
                                        );
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => SuccessScreen())
                                        );
                                      }
                                      else if(status=="UpiTransactionStatus.submitted"){
                                        _firestore.collection('orders').add(
                                            {
                                              'name': name,
                                              'buyid': "Submitted, needs to be verified",
                                              'order': order,
                                              'address': address,
                                              'number': number,
                                              'price' : cost.toString(),
                                            }
                                        );
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => SuccessScreen())
                                        );
                                      }
                                      else{
                                        print("some error:"+status);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ErrorScreen())
                                        );
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            appMetaList[index].iconImage(48),
                                            SizedBox(width: 20,),
                                            Text(appMetaList[index].upiApplication.appName.toString()),
                                          ],
                                        ),

                                        SizedBox(height: 30,),
                                      ],
                                    )

                                ),
                              );
                            }
                        ),
                      )
                    ],
                  )
                  );
                }

              }, child: Text("Buy")),
            ],
          ),
        ),
      ),
    );
  }
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
    amount: '1.00',
    app: appMeta.upiApplication,
    receiverName: 'Divyanshu',
    receiverUpiAddress: 'Divyanshumeena321@okicici',
    transactionRef: 'UPITXREF0001',
    transactionNote: 'A UPI Transaction',
  );
  status=response.status.toString();
  if(status=="UpiTransactionStatus.success"){
    buyid=response.txnId.toString();
  }
  print("yoo"+status);
}