import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'item.dart';
import 'buy.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
List<Item> buy=[];
class CartScreen extends StatefulWidget {
  List<Item> cart;
  CartScreen({required this.cart});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    List<Item> cart=widget.cart;
    int buyArea(){
      int cost=0;
      buy.clear();
      for(int i=0;i<cart.length;i++){
        if(cart[i].quantity!=0){
          cost+=(cart[i].quantity)*(cart[i].cost);
          buy.add(cart[i]);
        }
      }
      return cost;
    }
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return MaterialApp(
      theme: ThemeData.light(),
      home: Material(
        type: MaterialType.transparency,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
              children: [
                Flexible(child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Row(
                            children: [
                              Text(cart[index].name,style: TextStyle(fontSize: 20,color: Colors.black),),
                              SizedBox(width: 40,),
                              Text(cart[index].cost.toString(),style: TextStyle(fontSize: 30,color: Colors.black)),
                              TextButton(onPressed: (){setState(() {
                                cart[index].reduceCart();
                                if(cart[index].quantity==0){
                                  cart.remove(cart[index]);
                                  print(cart.length);
                                }
                              });}, child: Icon(CupertinoIcons.minus_circled,color: Colors.orange,)),
                              Text(cart[index].quantity!=0?cart[index].quantity.toString():"  ",style: TextStyle(fontSize: 40,color: Colors.black),),
                              TextButton(onPressed: (){setState(() {
                                cart[index].increaseCart();
                              });}, child: Icon(CupertinoIcons.add_circled,color: Colors.orange,)),
                            ],
                          ),
                        ),
                      );
                    })),
                TextButton(onPressed: (){
                  int val=buyArea();
                  print(val.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuyScreen(cost: val,cart: buy,)),
                  );
                }, child: Text("Buy")),
              ],
          ),
        ),
      ),
    );
  }
}
