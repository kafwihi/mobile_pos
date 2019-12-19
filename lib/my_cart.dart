//https://proandroiddev.com/flutter-thursday-02-beautiful-list-ui-and-detail-page-a9245f5ceaf0

import 'dart:async';
import 'package:flutter/material.dart';

import 'database/dbhelper.dart';

import 'model/cart_list.dart';
 Future<List<Cart>> getCartFromDB() async{
    var dbhe= dbhelper();
    Future<List<Cart>> myList =  dbhe.getCartList();
    return myList;
  }

class MyCartList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new MyCartListState();//wifi 23582481

}

class MyCartListState extends State<MyCartList> {

      int serial,currentStock;
        String price,amount,quantity;
      String name, description;
     // Product con = new Product();
      Cart list = new Cart();

    @override
    Widget build(BuildContext context){
          return new Scaffold(
               appBar: new AppBar(
            title: Text('My Cart List'),
                            ),
              body:  new Container(
                padding: EdgeInsets.all(16.0),
                child: FutureBuilder<List<Cart>>(
                  future: getCartFromDB(),
                  builder: (context, snapshot){
                    if(snapshot.data!=null){
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                           return new Card(
                              child: Column(
                          children: <Widget>[
                                ListTile(
                                title: Text('Name: '+snapshot.data[index].name,
                                style: TextStyle(fontSize: 26),
                                ),
                                subtitle:Row(
                              children: <Widget>[
                                //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                                Text(" Desc: "+snapshot.data[index].description, style: TextStyle(fontSize: 14,color: Colors.blue)),
                                Text(" Price: "+snapshot.data[index].price.toString(), style: TextStyle(fontSize: 14,color: Colors.blue)),
                                 Text(" Quan: "+snapshot.data[index].quantity.toString(), style: TextStyle(fontSize: 14,color: Colors.blue)),
                                Text(" Amount: "+snapshot.data[index].amount.toString(), style: TextStyle(fontSize: 14,color: Colors.blue))


                              ],
                            )

                             ),
                              Align(
            alignment: Alignment(1.0, 2.5),
            heightFactor: 0.5,
            child: FloatingActionButton(
              heroTag: snapshot.data[index].name,
                onPressed: (){
                  print(snapshot.data[index].name);
                  },
              child: Icon(Icons.add),
            ),
          )
                          ],
                              ),
                           );
                            });

                        }
                        else if(snapshot.data.length == 0)
                        return Text('No Data Found');
                        }

                        return new Container(
                          alignment: AlignmentDirectional.center,
                          child: new CircularProgressIndicator(),

                );

                },
                ),
              ),
          );
    }

    @override
    void initState(){
      super.initState();
    }


}
