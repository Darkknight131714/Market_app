class Item{
  int cost,quantity,addquantity=1;
  String name,image;
  Item({required this.cost,required this.name,required this.quantity,required this.image});
  void addQuantity(){
    addquantity++;
  }
  void removeQuantity(){
    if(addquantity!=1){
      addquantity--;
    }
  }
  void removeCart(){
    quantity=0;
  }
  void addCart(){
    quantity+=addquantity;
    addquantity=1;
  }
  void reduceCart(){
    if(quantity!=0){
      quantity--;
    }
  }
  void increaseCart(){
    quantity++;
  }
}
List<Item> market=[
  Item(cost: 100,name: "Cadbury",quantity: 0,image: "cadbury.jpg"),
  Item(cost: 1000,name: "Gold",quantity: 0,image: "gold.jpg"),
  Item(cost: 200,name: "Chips",quantity: 0,image: "chips.jpg"),
  Item(cost: 300,name: "Burger",quantity: 0,image: "burger.jpg"),
  Item(cost: 400,name: "Ice Cream",quantity: 0,image: "icecream.jpg"),
  Item(cost: 500,name: "Water",quantity: 0,image: "water.jpg"),
  Item(cost: 600,name: "Pizza",quantity: 0,image: "pizza.jpg"),
  Item(cost: 7000,name: "Diamond",quantity: 0,image: "diamond.jpg"),
];