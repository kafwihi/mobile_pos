

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'database/dbhelper.dart';
import 'model/product.dart';
import 'my_cart.dart';
import 'product_list.dart';

void main() => runApp(MyApp());

final routes = <String, WidgetBuilder> {
  /*LoginPage.tag: (context) => LoginPage(),
  HomePage.tag: (context) => HomePage(),
  StkPushPage.tag: (context) => StkPushPage(),
  RegisterPage.tag: (context) => RegisterPage(),*/
  //ForgotPasswordPage.tag: (context) => ForgotPasswordPage(),
   '/cart':(BuildContext context) => new MyCartList(),
   '/products':(BuildContext context) => new MyProductsList()
};
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
  routes: routes,
    );
  }

}

  class MyHomePage extends StatefulWidget{
   MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
  }

 class _MyHomePageState extends State<MyHomePage>{
        int serial,currentStock;
        String price;
      String name, description;
      Product con = new Product();

      final scaffoldKey = new GlobalKey<ScaffoldState>();
      final formKey = new GlobalKey<FormState>();

      @override
      Widget build(BuildContext context){
        return new Scaffold(

      resizeToAvoidBottomPadding: false,
          key:scaffoldKey,
          appBar: new AppBar(
            title: Text('ADD PRODUCT'),
            actions: <Widget>[
              IconButton(
                icon:const Icon(Icons.view_list),
                tooltip: 'View Product List',
                onPressed: (){
                  startProductList();
                                  },
                                )
                              ]
                            ),
                            body: new Padding(padding: const EdgeInsets.all(16.0),
                            child: new Form(
                              key: formKey,
                              child: new Column(
                                children: <Widget>[
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(labelText: "Name"),
                                    validator: (val) => val.length == 0? "Enter Product Name": null,
                                    onSaved: (val) => this.name = val,
                                  ),
                                   TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(labelText: "Description"),
                                    validator: (val) => val.length == 0? "Enter Prodcut Description": null,
                                    onSaved: (val) => this.description = val,
                                  ),
                                   TextFormField(
                                    keyboardType: TextInputType.number,
                                   // inputFormatters: <TextInputFormatter>[
                                    //WhitelistingTextInputFormatter.digitsOnly
                              // ],
                                    decoration: new InputDecoration(labelText: "Price"),
                                     validator: (val) => val.length == 0? "Enter Product Price": null,
                                    onSaved: (val) => this.price = val   ,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    //inputFormatters: <TextInputFormatter>[
                                      //WhitelistingTextInputFormatter.digitsOnly
                                 // ],
                                    decoration: new InputDecoration(labelText: "Quantity"),
                                    validator: (val) => val.length == 0? "Enter Quantity": null,
                                    onSaved: (val) => this.currentStock =  num.tryParse(val)?.toInt()   ,
                                  ),
                                  new Container(
                                    margin: const EdgeInsets.only(top:10.0),
                                    child: new RaisedButton(

                                      onPressed: submitProduct,
                                      //print("skip"),
                                      child: Text('ADD NEW PRODUCT'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            )
                          );
                        }
String numberValidator(String value) {
  if(value == null) {
    return null;
  }
  final n = num.tryParse(value);
  if(n == null) {
    return '"$value" is not a valid number';
  }
  return null;
}

                    void startProductList() {
                      //Navigator.push(context, new MaterialPageRoute(builder: (context)=> new MyProductsList()));
                      Navigator.pushNamed(context, '/products');
                     // Navigator.push(context, new MaterialPageRoute(builder: (context)=> new MyContactList()));

                    }
                     void submitProduct() {
                       print("start");
                       if(this.formKey.currentState.validate()){
                         formKey.currentState.save();print("good");
                       }else
                       {print("baad");return null;}


                     con.name = name;
                     con.description = description;//var long2 = num.tryParse($group1)?.toDouble();
                     con.price  =  num.tryParse(price)?.toDouble()   ;
                     con.currentStock =currentStock  ;

                     var dbHelp = dbhelper();print("skip");
                     dbHelp.insertDog(con);
                     Fluttertoast.showToast(msg:'Product was saved', toastLength: Toast.LENGTH_SHORT);

                     }

  }
