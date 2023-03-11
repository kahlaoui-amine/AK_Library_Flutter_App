
import 'package:book_library/entity/cart.dart';
import 'package:floor/floor.dart';

@dao
abstract class CartDAO{
  @Query('SELECT * FROM Cart where uid=:uid')
  Stream<List<Cart>> getAllItemInCartByUid(String uid);

  @Query('SELECT * FROM Cart where uid=:uid AND id=:id')
  Future<Cart?> getItemInCartByUid(String uid,int id);

  @Query('DELETE FROM Cart where uid=:uid')
  Stream<List<Cart>> clearCartByUid(String uid);

  @insert
  Future<void> insertCart(Cart book);

  @update
  Future<void> updateCart(Cart book);

  @delete
  Future<void> deleteCart(Cart book);
}