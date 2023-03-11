import 'package:floor/floor.dart';

@entity
class Cart{
  @primaryKey
  final int id;
  final String uid, name,category,imageUrl,price;
  int quantity ;

  Cart({required this.id, required this.uid, required this.name, required this.category, required this.imageUrl, required this.price,
      required this.quantity});
}