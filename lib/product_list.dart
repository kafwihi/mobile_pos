//https://proandroiddev.com/flutter-thursday-02-beautiful-list-ui-and-detail-page-a9245f5ceaf0

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'database/dbhelper.dart';

import 'model/cart_list.dart';
import 'model/product.dart';
import 'my_cart.dart';
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
      int serial,currentStock;
        String price,amount,quantity;
      String name, description;
      Product con = new Product();
      Cart list = new Cart();

    @override
    Widget build(BuildContext context){
          return new Scaffold(
               appBar: new AppBar(
            title: Text('Products List'),
            actions: <Widget>[
              IconButton(
                icon:const Icon(Icons.view_list),
                tooltip: 'My Cart Items',
                onPressed: (){
                  goToCartList();
                                  },
                                )
                              ]
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
                           return new Container(
                             width: 400,
                             height: 90,
                             //new Expanded(
                             child:Card(

                                color:Colors.amberAccent,
                              child: Column(
                               // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                                ListTile(

                                title: Text(snapshot.data[index].name,
                                style: TextStyle(fontSize: 18,color: Colors.blue),
                                ),
                                subtitle:Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                       new Align(alignment: Alignment.centerLeft,
                                        child: new Text("Desc:"+truncateWithEllipsis(15,snapshot.data[index].description),
                                       // child: new Text("Desc: "+snapshot.data[index].description,

                                        style: TextStyle(fontSize: 12,color: Colors.blue),textAlign: TextAlign.left,
                                        //softWrap: false,
                                       // overflow: TextOverflow.ellipsis,
                                        )),
                                       new Align(alignment: Alignment.centerLeft,
                                        child: new Text("Price:"+truncateWithEllipsis(6,snapshot.data[index].price.toString()),
                                         style: TextStyle(fontSize: 12,color: Colors.blue),textAlign: TextAlign.left,
                                          //softWrap: true,
                                        //overflow: TextOverflow.ellipsis,

                                         )),

                                  ],),


                                ),

                                                  VerticalDivider(),

                                                         GestureDetector(
                              onTap: (){
                                  print('adding '+snapshot.data[index].name);
                                                    addToCart(list,snapshot.data[index].name,snapshot.data[index].description,
                                                    snapshot.data[index].price.toString(),snapshot.data[index].price.toString());
                                            Fluttertoast.showToast(msg:snapshot.data[index].name+' Added to cart', toastLength: Toast.LENGTH_SHORT);

                                            },
                                              child: Icon(
                                            Icons.shopping_cart,
                                            color:Colors.green,
                                            size:40.0
                                          ),

                            ),



                              ],
                            ),

                            leading:
                                   GestureDetector(
                              onTap: (){
                                 showAlertDialog(context,snapshot.data[index].name,snapshot.data[index].price.toString(),snapshot.data[index].description);
                                print("object "+snapshot.data[index].name);
                                },
                               child: Image.asset(
                                            "assets/products/"+snapshot.data[index].name+".png",
                                            fit: BoxFit.cover,
                                            width: 70.0,height: 50.0,
                                          ),

                            ),

                             ),

                          ],
                              ),
                           ),
                          // ),

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

                      void goToCartList() {
                      Navigator.push(context, new MaterialPageRoute(builder: (context)=> new MyCartList()));
                                   Navigator.pushNamed(context, '/cart');
                      //Navigator.push(context, new MaterialPageRoute(builder: (context)=> new MyProductsList()));

                    }

}
String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
    ? myString
    : '${myString.substring(0, cutoff)}...';
}
void addToCart(list,String name,String description,String price,String amount) {

                     list.name = name;
                     list.description = description;//var long2 = num.tryParse($group1)?.toDouble();
                     list.price  =  num.tryParse(price)?.toDouble()   ;
                     list.quantity =1 ;
                     list.amount  =  num.tryParse(amount)?.toDouble()   ;


                     var dbHelp = dbhelper();print("addded to cart");
                     dbHelp.addItemToCart(list);
                     Fluttertoast.showToast(msg:'Product Added To Cart', toastLength: Toast.LENGTH_SHORT);

                     }
class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 30.0,
      width: 12.0,
      color: Colors.white30,
      margin: const EdgeInsets.only(left: 1.0, right: 60.0),
    );
  }
}
showAlertDialog(BuildContext context,String productName, String price,String desc) {

  Color _color = Color.fromARGB(220, 117, 218 ,255);
      Cart list = new Cart();

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {Navigator.pop(context);},
  );
  Widget launchButton = FlatButton(
    child: Text("Add To Cart"),
    onPressed:  () {
    print('adding '+productName);
    addToCart(list,productName,desc,price,price);
Fluttertoast.showToast(msg:productName+' Added to cart', toastLength: Toast.LENGTH_SHORT);
Navigator.pop(context);

},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(productName),

    backgroundColor: Colors.tealAccent,shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),

    content: Column( mainAxisSize: MainAxisSize.min,
      children: <Widget>[
           Text("Price:KSHs. "+price,textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20.0,//fontWeight: FontWeight.w700,
        ),),
          Text("Description:"+desc,textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20.0,//fontWeight: FontWeight.w700,
        ),),

      ],
    ),
    contentPadding: EdgeInsets.all(60.0),

    actions: [
     // remindButton,
      cancelButton,
      launchButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {

      return alert;
    },
  );
}
