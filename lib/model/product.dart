import 'dart:core';


class Product{
    int serial, currentStock;
    double price;
    String name, description;



  Product({this.name, this.description, this.price,this.currentStock});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'currentStock': currentStock,
    };
  }

}