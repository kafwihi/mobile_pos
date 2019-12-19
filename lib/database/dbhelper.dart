import 'dart:async';

import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:working_sqlite/model/cart_list.dart';
import 'package:working_sqlite/model/product.dart';
import '../model/contact.dart';

class dbhelper{
  static Database instance;
  final String TABLE_NAME = "contact";
  final String TABLE_PRODUCT = "products";
  final String TABLE_CART = "cart";
  Future<Database> get db async{
        if(instance == null)
        instance = await initDB();
                return instance;
          }

          initDB() async{
              io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
              String path = join(documentsDirectory.path, "LyrnDB.db");
              var db = await openDatabase(path, version: 1, onCreate:onCreateFunc);
              return db;
          }

          Future onCreateFunc(Database db, int version) async {
            //await db.execute('CREATE TABLE $TABLE_NAME(id integer primary key autoincrement, name text, phone text);');
              await db.execute('CREATE TABLE $TABLE_PRODUCT(serial integer primary key autoincrement, name text, description text,price double,currentStock integer);');
              await db.execute('CREATE TABLE $TABLE_CART(name text primary key, description text,price double,quantity integer,amount double);');
          }

          Future<List<contact>> getContacts() async {
            var db_connection = await db;
            List<Map> list = await db_connection.rawQuery('SELECT * FROM $TABLE_NAME');
            List<contact> contacts = new List();
            for(int i = 0;i< list.length;i++){
              contact con = new contact();
              con.id = list[i]['id'];
              con.name = list[i]['name'];
              con.phone = list[i]['phone'];
              contacts.add(con);
            }

            return contacts;
          }

  Future<List<Product>> getAllProducts() async {
            var db_connection = await db;
            List<Map> list = await db_connection.rawQuery('SELECT * FROM $TABLE_PRODUCT');
            List<Product> contacts = new List();
            for(int i = 0;i< list.length;i++){
              Product con = new Product();
              con.serial = list[i]['serial'];
              con.name = list[i]['name'];
              con.description = list[i]['description'];
              con.price = list[i]['price'];
              con.currentStock = list[i]['currentStock'];
              contacts.add(con);
            }

            return contacts;
          }
  Future<List<Cart>> getCartList() async {
            var db_connection = await db;
            List<Map> list = await db_connection.rawQuery('SELECT * FROM $TABLE_CART');
            List<Cart> contacts = new List();
            for(int i = 0;i< list.length;i++){
              Cart con = new Cart();
              con.name = list[i]['name'];
              con.description = list[i]['description'];
              con.price = list[i]['price'];
              con.quantity = list[i]['quantity'];
              con.quantity = list[i]['amount'];
              contacts.add(con);
            }

            return contacts;
          }
          void addNewContact(con) async{
            var db_connection = await db;
            String query = 'INSERT INTO $TABLE_NAME(name,phone) VALUES(\'${con.name}\',\'${con.phone}\')';
            await db_connection.transaction((transaction) async{
              return await transaction.rawInsert(query);
            });
          }

          void addNewProduct(Product con) async{
            var db_connection = await db;print("db reached");
            String query =
             'INSERT INTO $TABLE_PRODUCT(name,description,price,currentStock) VALUES(\'${con.name}\',\'${con.description}\',\'${con.price}\',\'${con.currentStock}\')';
            await db_connection.transaction((transaction) async{
              return await transaction.rawInsert(query);
            });
          }
Future<void> insertDog(Product dog) async {
  // Get a reference to the database. var db_connection = await db;print("db reached");
            final db_connection = await db;

   db_connection.insert(
    'products',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

}

Future<void> addItemToCart(Cart list) async {
  // Get a reference to the database. var db_connection = await db;print("db reached");
            final db_connection = await db;

   db_connection.insert(
    'cart',
    list.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

}
Future<void> updateList(Product dog) async {
  // Get a reference to the database. var db_connection = await db;print("db reached");
            final db_connection = await db;

   db_connection.update(
    'products',
    dog.toMap(), // Ensure that the Dog has a matching id.
    where: "serial = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [dog.serial],
  );

}
          void updateContact(contact con) async{
            var db_connection = await db;
            String query = 'UPDATE $TABLE_NAME SET name =\'${con.name}\', phone=\'${con.phone}\' where id=${con.id}';
            await db_connection.transaction((transaction) async{
              return await transaction.rawInsert(query);
            });
          }

          void updateProduct(Product con) async{
            var db_connection = await db;
            String query = 'UPDATE $TABLE_NAME SET name =\'${con.name}\', description=\'${con.description}\' where serial=${con.serial}';
            await db_connection.transaction((transaction) async{
              return await transaction.rawInsert(query);
            });
          }
          void updateProductPrice(Product con) async{
            var db_connection = await db;
            String query = 'UPDATE $TABLE_NAME SET price =\'${con.price}\' where serial=${con.serial}';
            await db_connection.transaction((transaction) async{
              return await transaction.rawInsert(query);
            });
          }

           void updateProductStock(Product con) async{
            var db_connection = await db;
            String query = 'UPDATE $TABLE_NAME SET currentStock =\'${con.currentStock}\' where serial=${con.serial}';
            await db_connection.transaction((transaction) async{
              return await transaction.rawInsert(query);
            });
          }
          void deleteContact(contact con) async{
            var db_connection = await db;
            String query = 'DELETE FROM $TABLE_NAME WHERE id =${con.id}';
            await db_connection.transaction((transaction) async{
              return await transaction.rawInsert(query);
            });
          }

            void dropProduct(Product con) async{
            var db_connection = await db;
            String query = 'DELETE FROM $TABLE_PRODUCT WHERE serial =${con.serial}';
            await db_connection.transaction((transaction) async{
              return await transaction.rawInsert(query);
            });
          }
}