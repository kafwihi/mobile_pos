

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'database/dbhelper.dart';

import 'model/contact.dart';
 Future<List<contact>> getContactsFromDB() async{
    var dbhelp = dbhelper();
    Future<List<contact>> contacts =  dbhelper().getContacts();
    return contacts;
  }

class MyContactList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new MyContactListState();

}

class MyContactListState extends State<MyContactList> {

    final controller_name = new TextEditingController();
    final controller_phone = new TextEditingController();

    @override
    Widget build(BuildContext context){
          return new Scaffold(
              appBar: AppBar(
                title: Text('Contact List'),
              ),
              body:  new Container(
                padding: EdgeInsets.all(16.0),
                child: FutureBuilder<List<contact>>(
                  future: getContactsFromDB(),
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
                                          style:TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                          snapshot.data[index].phone,
                                          style:TextStyle(
                                            color: Colors.grey[500]
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
                                                      decoration: InputDecoration(hintText: '${snapshot.data[index].name}'),
                                                      controller: controller_name,
                                                    ),
                                                    TextFormField(
                                                      autofocus: false,
                                                      decoration: InputDecoration(hintText: '${snapshot.data[index].phone}'),
                                                      controller: controller_phone,
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
                                                contact cont = new contact();
                                                cont.id = snapshot.data[index].id;

                                                cont.name =
                                                controller_name.text!=''?controller_name.text:snapshot.data[index].name;

                                              cont.phone =
                                                controller_phone.text!=''?controller_phone.text:snapshot.data[index].phone;
                                                dbHelper.updateContact(cont);
                                                Navigator.pop(context);

                                                    Fluttertoast.showToast(msg:'Contact Updated', toastLength: Toast.LENGTH_SHORT,
                                            );
                                             setState(() {
                                                  getContactsFromDB();
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
                                            dbhelp.deleteContact(snapshot.data[index]);
                                            Fluttertoast.showToast(msg:'Contact Deleted', toastLength: Toast.LENGTH_SHORT,
                                            );
                                             setState(() {
                                                  getContactsFromDB();
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
