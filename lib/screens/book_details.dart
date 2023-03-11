
import 'package:book_library/model/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:book_library/dao/CartDAO.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../const/const.dart';
import '../entity/cart.dart';


class Details extends StatelessWidget{
  const Details({super.key, required this.book, required this.cartDAO});

  final Book book;
  final CartDAO cartDAO;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name!),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0), // specify the padding here
            child: SizedBox(
              width:  MediaQuery.of(context).size.width,
              height:  300,
              child: Image.network(
                book.imageUrl!,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Expanded(
           child:Container(
            padding:  const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Text('${book.name}',
                  style: const TextStyle(fontSize: 18.0,fontWeight:FontWeight.bold),),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text.rich(TextSpan(children:
                          [TextSpan(text: int.parse(book.oldPrice!)==0 ? '': '${book.oldPrice} Dt',
                              style: const TextStyle(color: Colors.red,decoration: TextDecoration.lineThrough,fontSize: 18.0,)),
                             TextSpan(text: '   ${book.price} Dt  ',
                                style: const TextStyle(color: Colors.greenAccent,fontSize: 18.0,)),
                          ])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Description :',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${book.category}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15.0,fontStyle: FontStyle.italic),
                  ),
                ),


                GestureDetector(onTap: () async {
                  var cartBook = await cartDAO.getItemInCartByUid(UID ,book.id!);
                  if(cartBook != null)
                  {
                    cartBook.quantity+=1;
                    await cartDAO.updateCart(cartBook);
                  }
                  else
                  {
                    Cart cart = Cart(
                        id:book.id!,
                        price: book.price!,
                        category: book.category!,
                        imageUrl: book.imageUrl!,
                        quantity: 1,
                        name: book.name!,
                        uid:UID

                    );
                    await cartDAO.insertCart(cart);
                  }
                },
                  child: Expanded(
                    child: Align(
                        child: Container(margin: EdgeInsets.all(40),
                            height: 50,
                            child: Center(
                                child: ElevatedButton(
                                  child: Text('Commander'),
                                  onPressed: null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  ),
                                )
                            )
                        )
                    ),
                  ),)

              ],

            ),


          )
          )
        ],
      ),
      floatingActionButton: StreamBuilder(
        stream: cartDAO.getAllItemInCartByUid(UID),
        builder: (BuildContext context, AsyncSnapshot<List<Cart>> snapshot) {
          if(snapshot.hasData)
          {
            var list = snapshot.data as List<Cart>;
            return
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 1),
                showBadge: true,
                badgeAnimation:badges.BadgeAnimation.fade
                  (animationDuration: Duration(seconds: 3)
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
      ),);



  }

}