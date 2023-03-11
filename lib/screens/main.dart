import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:book_library/const/const.dart';
import 'package:book_library/dao/CartDAO.dart';
import 'package:book_library/database/database.dart';
import 'package:book_library/screens/cart_detail.dart';
import 'package:flutter/material.dart';
import 'package:book_library/widgets/book_card.dart';
import 'package:flutter/services.dart' as rootBundle;

import '../entity/cart.dart';
import '../model/book.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('Library_Booking.db')
      .build();
  final dao = database.cartDAO;
  runApp( MyApp(dao:dao));
}

class MyApp extends StatelessWidget {
   final CartDAO dao;
   MyApp({super.key,required this.dao});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/cart":(context) => CartDetail(cartDAO:dao, )
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(title: 'Flutter Demo Home Page',dao:dao),
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key, required this.title, required this.dao});

  final CartDAO dao;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Library'),
      ),
      body: FutureBuilder(
        future:readJSONDatabase(),
        builder: (context,snapshot){
          if(snapshot.hasError)
            return Center(child: Text('${snapshot.error}'),);
          else if(snapshot.hasData)
          {
            List books = snapshot.data! as  List<Book>;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: BookCard(
                      cartDAO: widget.dao,
                      book: books[index],
                    ),
                  );
                },
              ),
            );
          }
          else return Center(child: CircularProgressIndicator(),);
        },
      ),

      floatingActionButton: StreamBuilder(
        stream: widget.dao.getAllItemInCartByUid(UID),
        builder: (BuildContext context, AsyncSnapshot<List<Cart>> snapshot) {
          if(snapshot.hasData)
            {
              var list = snapshot.data as List<Cart>;
              return
                badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 1),
                showBadge: true,
                badgeAnimation:badges.BadgeAnimation.fade
                  (animationDuration: Duration(seconds: 1)
                  ),
                badgeStyle: badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: Colors.lightBlueAccent,


                  ),
                  badgeContent: Text('${list.length > 0 ? list.map<int>((m) => m.quantity).reduce((value, element) => value+element):0
                }'),
                  child: FloatingActionButton(
                    backgroundColor: Colors.orangeAccent,
                    onPressed: (){
                      Navigator.pushNamed(context, "/cart");
                    },
                    child: Icon(Icons.shopping_cart),
                  ),
              );
            }
          else return Container();
        },
      ),
    );
  }

  Future<List<Book>> readJSONDatabase() async{
    final raw_data = await rootBundle.rootBundle.loadString('assets/data/booksList.json');
    final list = json.decode(raw_data) as List<dynamic>;
    return list.map((model) => Book.fromJson(model)).toList();
  }
}
