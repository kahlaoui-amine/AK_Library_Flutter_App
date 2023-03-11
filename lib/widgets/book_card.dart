
import 'package:book_library/model/book.dart';
import 'package:book_library/screens/book_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:book_library/dao/CartDAO.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';
import '../entity/cart.dart';


class BookCard extends StatelessWidget{
  const BookCard({super.key, required this.book, required this.cartDAO});

  final Book book;
  final CartDAO cartDAO;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Details(book: book, cartDAO: cartDAO),
          ),
        );
      },
      child: Card(
        elevation: 12,
        child: Column(
          children: [
            Image.network(
              book.imageUrl!,
              fit: BoxFit.fill,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    '${book.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: int.parse(book.oldPrice!) == 0
                                  ? ''
                                  : '${book.oldPrice} Dt',
                              style: TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10.0,
                              ),
                            ),
                            TextSpan(
                              text: '  ${book.price} Dt',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}