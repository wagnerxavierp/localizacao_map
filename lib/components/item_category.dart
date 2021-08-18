
import 'package:flutter/material.dart';
import 'package:points_map/models/point.dart';

class ItemCategory extends StatelessWidget {
  
  Category element;
  Image image;
  Function onPressed;

  ItemCategory({ Key? key, required this.element, required this.image, required this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.only(left: 20, top: 7, bottom: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4.0
              )
            ]
          ),
          child: TextButton(
            child: Row( // Replace with a Row for horizontal icon + text
              children: <Widget>[
                image,
                SizedBox(width: 5,),
                Text(element.name)
              ],
            ),
            onPressed: (){
              onPressed();
            }
          ),
        );
  }
}