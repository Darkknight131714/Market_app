import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_app/cart.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'item.dart';
import 'package:flutter/services.dart';
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
    final double itemWidth = size.width / 2.75;
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
            TextButton(onPressed: (){setState(() {
              makeCart();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
              );
            });},child: Icon(CupertinoIcons.cart,color: Colors.black,))
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
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(onPressed: (){setState(() {
                              market[index].removeQuantity();
                            });},
                                style: TextButton.styleFrom(
                                  primary: Colors.orange,
                                ),
                                child: Icon(CupertinoIcons.minus_circled)),
                            Text(market[index].addquantity.toString()),
                            TextButton(onPressed: (){setState(() {
                              market[index].addQuantity();
                            });},
                                style: TextButton.styleFrom(
                                  primary: Colors.orange,
                                ),child: Icon(CupertinoIcons.add_circled)),
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
                          market[index].addCart();
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
