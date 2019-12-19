

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'database/dbhelper.dart';

import 'model/product.dart';
 Future<List<Product>> getProductsFromDB() async{
    var dbhelp = dbhelper();
    Future<List<Product>> contacts =  dbhelper().getAllProducts();
    return contacts;
  }

class MyProductsList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new MyProductsListState();

}

class MyProductsListState extends State<MyProductsList> {

    final controller_name = new TextEditingController();
    final controller_phone = new TextEditingController();

    final controller_description = new TextEditingController();

    final controller_price = new TextEditingController();

    final controller_currentStock = new TextEditingController();

    @override
    Widget build(BuildContext context){
          return new Scaffold(
              appBar: AppBar(
                title: Text('Products List'),
              ),
              body:  new Container(
                padding: EdgeInsets.all(16.0),
                child: FutureBuilder<List<Product>>(
                  future: getProductsFromDB(),
                  builder: (context, snapshot){
                    if(snapshot.data!=null){
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return new Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:<Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          snapshot.data[index].name,
                                          style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                                        ),
                                      ),
                                      Text(
                                          snapshot.data[index].description,
                                          style:TextStyle(
                                            color: Colors.grey[500],fontSize: 20
                                          ),
                                        ),
                                    Text(
                                          snapshot.data[index].price.toString(),
                                          style:TextStyle(
                                            color: Colors.grey[500],fontSize: 20
                                          ),
                                        ),

                                    Text(
                                          snapshot.data[index].currentStock.toString(),
                                          style:TextStyle(
                                            color: Colors.grey[500],fontSize: 20
                                          ),
                                        ),
                                    ],
                                    ),
                                  ),

                                    GestureDetector(
                                          onTap:() {
                                            showDialog(context: context, builder: (_)=> new AlertDialog(contentPadding: const EdgeInsets.all(16.0),
                                            content: new Row(children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    TextFormField(
                                                      autofocus: true,
                                                      style: new TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 25.0,fontFamily: "Poppins"
                                                    ),
                                                      decoration: InputDecoration(
                                                        fillColor:Colors.white,

                                                        hintText: '${snapshot.data[index].name}'),
                                                      controller: controller_name,
                                                    ),
                                                    TextFormField(
                                                      autofocus: false,
                                                      style: new TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 25.0,fontFamily: "Poppins"
                                                    ),
                                                      decoration: InputDecoration(hintText: '${snapshot.data[index].description}'),
                                                      controller: controller_description,
                                                    ),
                                                    TextFormField(

                                                     keyboardType: TextInputType.number,
                                                      autofocus: false,
                                                      style: new TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 25.0,fontFamily: "Poppins"
                                                    ),
                                                      decoration: InputDecoration(hintText: '${snapshot.data[index].price}'),
                                                      controller: controller_price,
                                                    ),
                                                    TextFormField(
                                                    keyboardType: TextInputType.number,
                                                      autofocus: false,
                                                      style: new TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 25.0,fontFamily: "Poppins"
                                                    ),
                                                      decoration: InputDecoration(hintText: '${snapshot.data[index].currentStock}'),
                                                      controller: controller_currentStock,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(onPressed: () {
                                                Navigator.pop(context);
                                              }, child: Text('CANCEL')),
                                               new FlatButton(onPressed: () {
                                                var dbHelper = dbhelper();
                                                Product cont = new Product();
                                                cont.serial = snapshot.data[index].serial;

                                                cont.name =
                                                controller_name.text!=''?controller_name.text:snapshot.data[index].name;

                                              cont.description =
                                                controller_description.text!=''?controller_description.text:snapshot.data[index].description;

                                                String pr=controller_price.text!=''?controller_price.text:snapshot.data[index].price;
                                                cont.price =num.tryParse(pr)?.toDouble() ;

                                                String st=controller_price.text!=''?controller_currentStock.text:snapshot.data[index].currentStock;
                                                cont.currentStock =num.tryParse(st)?.toInt() ;

                                                dbHelper.updateList(cont);
                                                Navigator.pop(context);

                                                    Fluttertoast.showToast(msg:'Product Updated', toastLength: Toast.LENGTH_SHORT,
                                            );
                                             setState(() {
                                                  getProductsFromDB();
                                                });

                                              }, child: Text('UPDATE'))
                                            ],
                                            ));

                                          },
                                          child: Icon(
                                            Icons.update,
                                            color:Colors.red
                                          ),
                                        ),
                                            GestureDetector(
                                          onTap:() {
                                            var dbhelp = dbhelper();
                                            dbhelp.dropProduct(snapshot.data[index]);
                                            Fluttertoast.showToast(msg:'Product Deleted', toastLength: Toast.LENGTH_SHORT,
                                            );
                                             setState(() {
                                                  getProductsFromDB();
                                                });

                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color:Colors.red
                                          ),
                                        ),
                                        new Divider(),
                                ],

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
