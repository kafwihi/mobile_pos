import 'dart:core';


class Cart{
    int serial, quantity;
    double price,amount;
    String name, description;

  Cart({this.name, this.description, this.price,this.quantity,this.amount});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'amount': amount,
    };
  }

}