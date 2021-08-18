
import 'package:flutter/material.dart';
import 'package:points_map/models/point.dart';

class ItemPoint extends StatelessWidget {

  Point element;
  Image image;
  Function onPressed;

  ItemPoint({ Key? key, required this.element, required this.image, required this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0
              )
            ]
          ),
          child:  TextButton(
            child: Column(
              children: [
                Row( // Replace with a Row for horizontal icon + text
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: image,
                    ),
                    SizedBox(width: 15,),
                    Flexible(child: Text(element.title, style: TextStyle(fontSize: 16),))
                  ],
                ),
              ],
            ),
            onPressed: () {
              onPressed();
            }
          ),
        );
  }
}