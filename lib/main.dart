import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_app/cart.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'item.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:delayed_display/delayed_display.dart';
List<Item> cart=[];
void main() {
  runApp(const MyApp());
}
String val="";
bool isBot=false;
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void makeCart(){
    cart.clear();
    for(int i=0;i<market.length;i++){
      if(market[i].quantity>0){
        cart.add(market[i]);
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2.85;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(CupertinoIcons.ant),
            Container(
              child: Row(
                children: [
                  Text("M",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900),),
                  Text("y",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900),),
                  Text("M",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900),),
                  Text("arket",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900),)
                ],
              )
            ),
            IconButton(onPressed: (){setState(() {
              makeCart();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
              );
            });},icon: Icon(CupertinoIcons.cart,color: Colors.black,))
          ],
        )
      ),
      body: Column(
        children: [
          Flexible(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(market.length, (index){
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Image.asset("images/"+market[index].image,height: 200,fit: BoxFit.contain,),
                        ),
                      ),
                      Text(market[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      Text("₹"+market[index].cost.toString(),style: TextStyle(color: Colors.green,fontSize: 22,fontWeight: FontWeight.w500),),
                      Container(
                        width: size.width/3.2,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(onPressed: (){setState(() {
                              HapticFeedback.vibrate();
                              market[index].removeQuantity();
                            });},
                                icon: Icon(CupertinoIcons.minus_circled,color: Colors.orange,)),
                            Text(market[index].addquantity.toString()),
                            IconButton(onPressed: (){setState(() {
                              market[index].addQuantity();
                              HapticFeedback.vibrate();
                            });},
                                icon: Icon(CupertinoIcons.add_circled),color: Colors.orange,),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                        ),
                        child: TextButton(onPressed: (){
                          HapticFeedback.vibrate();
                          setState(() {
                            market[index].addCart();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              backgroundColor: Colors.green,
                              content: Text(market[index].name + " Added to Your Cart",style: TextStyle(color: Colors.white,),),
                            ),
                          );
                        },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                            ),
                            child: Text("    Add To Cart    ")),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}