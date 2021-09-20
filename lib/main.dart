import 'package:flutter/material.dart';
import 'package:market_app/cart.dart';

import 'item.dart';
List<Item> cart=[];
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
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

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2.3;
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(market.length, (index){
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      children: [
                        Text(market[index].name),
                        Container(
                          child: Image.asset("images/"+market[index].image,height: 200,fit: BoxFit.cover,),
                        ),
                        Text(market[index].cost.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(onPressed: (){setState(() {
                              market[index].removeQuantity();
                            });}, child: Text("-")),
                            Text(market[index].quantity!=0?market[index].quantity.toString():"  "),
                            TextButton(onPressed: (){setState(() {
                              market[index].addQuantity();
                            });}, child: Text("+")),
                          ],
                        ),
                        TextButton(onPressed: (){
                          print(index.toString());
                        }, child: Text("Add To Cart")),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          TextButton(onPressed: (){
            makeCart();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
            );
            }, child: Text("Go To Cart")),
        ],
      ),
    );
  }
}
