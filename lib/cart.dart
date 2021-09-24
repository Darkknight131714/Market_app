import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'item.dart';
import 'buy.dart';
import 'package:flutter/services.dart';
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
  int t=0;
  void initState(){
    super.initState();
  }

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
    t= buyArea();
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return MaterialApp(
      theme: ThemeData.light(),
      home: Material(
        type: MaterialType.transparency,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("M",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900),),
                Text("y",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900),),
                Text("M",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900),),
                Text("arket",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900),)
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: Column(
              children: [
                Divider(color: Colors.black, thickness: 3,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    border: Border.all(color: Colors.black,width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Your Cart",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),),
                  ),
                ),
                Divider(color: Colors.black, thickness: 3,),
                Flexible(child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(onPressed: (){
                                        setState(() {
                                          cart[index].removeCart();
                                          if(cart[index].quantity==0){
                                            cart.remove(cart[index]);
                                            t=buyArea();
                                          }
                                        });
                                      },padding: EdgeInsets.all(0),
                                          icon: Icon(CupertinoIcons.xmark_circle_fill)),
                                      SizedBox(width: 5,),
                                      Text(cart[index].name,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w700),),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 40,),
                                Text("₹"+cart[index].cost.toString(),style: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.w300)),
                                Container(
                                  child: Row(
                                    children: [
                                      TextButton(onPressed: (){setState(() {
                                        cart[index].reduceCart();
                                        if(cart[index].quantity==0){
                                          cart.remove(cart[index]);
                                        }
                                        t=buyArea();
                                      });}, child: Icon(CupertinoIcons.minus_circled,color: Colors.orange,)),
                                      Text(cart[index].quantity.toString(),style: TextStyle(fontSize: 30,color: Colors.black),),
                                      TextButton(onPressed: (){setState(() {
                                        cart[index].increaseCart();
                                        t=buyArea();
                                      });}, child: Icon(CupertinoIcons.add_circled,color: Colors.orange,)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(""),
                                  Text("Total Cost of Item: ₹ "+ (cart[index].cost*cart[index].quantity).toString(),style: TextStyle(fontSize: 16),),
                                ],
                              ),

                              Divider(thickness: 3,color: Colors.black,),
                            ],
                          ),
                        ),
                      );
                    })),
                Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.orange[400], 
                  //
                  // ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Your Total is ",style: TextStyle(fontSize: 22,fontWeight:FontWeight.w600,color: Colors.green),),
                      Text("₹ "+t.toString(),style: TextStyle(fontSize: 22,fontWeight:FontWeight.w300,color: Colors.red),),
                    ],
                  )
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Proceed To Checkout",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
                      IconButton(
                        onPressed: (){
                          setState(() {
                            HapticFeedback.vibrate();
                            int cost=buyArea();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BuyScreen(cart: buy,cost: cost)),
                            );
                          });
                        },
                        icon: Icon(CupertinoIcons.arrow_turn_down_right,color: Colors.green,),
                      )
                    ],
                  ),
                )
              ],

          ),
        ),
      ),
    );
  }
}
