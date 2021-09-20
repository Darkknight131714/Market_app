import 'package:flutter/material.dart';
import 'item.dart';
import 'buy.dart';
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
    return Material(
      type: MaterialType.transparency,
      child: Column(
          children: [
            Flexible(child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Row(
                        children: [
                          Text(cart[index].name,style: TextStyle(fontSize: 20,color: Colors.white),),
                          SizedBox(width: 40,),
                          Text(cart[index].cost.toString(),style: TextStyle(fontSize: 30,color: Colors.white)),
                          TextButton(onPressed: (){setState(() {
                            cart[index].removeQuantity();
                          });}, child: Text("-")),
                          Text(cart[index].quantity!=0?cart[index].quantity.toString():"  ",style: TextStyle(fontSize: 40,color: Colors.white)),
                          TextButton(onPressed: (){setState(() {
                            cart[index].addQuantity();
                          });}, child: Text("+")),
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
    );
  }
}
