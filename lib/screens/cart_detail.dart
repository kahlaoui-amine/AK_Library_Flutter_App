import 'package:book_library/dao/CartDAO.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../const/const.dart';
import '../entity/cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CartDetail extends StatefulWidget{
  final CartDAO cartDAO;
  CartDetail({super.key, required this.cartDAO});

  @override
  State<StatefulWidget> createState() => CartDetailState();
}

class CartDetailState  extends State<CartDetail>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panier'),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back),
      ),),
      body: StreamBuilder(
        stream: widget.cartDAO.getAllItemInCartByUid(UID),
        builder: (BuildContext context, AsyncSnapshot<List<Cart>> snapshot) {
          if(snapshot.hasData)
          {
            var items = snapshot.data as List<Cart>;
            return Column(
              children:
              [
                Expanded(child: ListView.builder(
                 itemCount: items ==null ? 0 : items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Slidable(
                      startActionPane:ActionPane(
                        motion: BehindMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                            onPressed: ((context){
                              widget.cartDAO.deleteCart(items[index]);
                            }),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child:  Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment:  CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child:ClipRRect(
                                    child: Image(image: NetworkImage(items[index].imageUrl),
                                    fit: BoxFit.fill),
                                      borderRadius:BorderRadius.all(Radius.circular(4)),
                                    ),
                                    flex: 2,
                                  ),
                              Expanded(flex:6,child: Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 8,right: 8),
                                        child: Text(items[index].name ,
                                          style:const TextStyle(fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                          maxLines:2,
                                          overflow:TextOverflow.ellipsis,),
                                    ),Padding(
                                        padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                                        child: Row (mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(margin: const EdgeInsets.only(left: 8),

                                            child: Text(items[index].price ,
                                              style: TextStyle(fontWeight: FontWeight.bold,),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,),),
                                          Container(margin: const EdgeInsets.only(left: 8),
                                          child: const Text('Dt',
                                          style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,),)
                                        ],),
                                    )
                                  ],
                                )

                              )),
                              Center(
                                child: ElegantNumberButton(
                                initialValue:items[index].quantity,
                                  buttonSizeWidth:25,
                                  buttonSizeHeight:20,
                                  color:Colors.white38,
                                  minValue:0,
                                  maxValue:100,
                                  decimalPlaces:0,
                                  onChanged:(value)async{
                                    items[index].quantity = value.toInt();
                                    await widget.cartDAO.updateCart(items[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ))
              ],


            );
          }
          else
            return Center(child: Text('Panier Vide'),);

        },

      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 100,
              height: 40,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "La commande est ajouté à la B.D",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER_LEFT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.green,
                      fontSize: 16.0
                  );                                },
                child: const Text(
                  "Valider",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 100,
              height: 40,
              child: FloatingActionButton(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: ()
                {
                  Navigator.of(context).popUntil((route) => route.isFirst == true);
                },
                child: const Text(
                  "Retourner",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );

  }

}