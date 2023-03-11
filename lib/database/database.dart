

import 'package:book_library/dao/CartDAO.dart';
import 'package:floor/floor.dart';
import 'package:book_library/entity/cart.dart';
//more import
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart'; // the generated code will be there

@Database(version: 1,entities:[Cart])
abstract class AppDatabase extends FloorDatabase{
  CartDAO get cartDAO;
}
