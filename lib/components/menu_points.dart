
import 'package:flutter/material.dart';

class MenuPoints extends StatelessWidget {

  List<Widget> listWidgets;

  MenuPoints({ Key? key, required this.listWidgets }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 300,
      margin: EdgeInsets.only(right: 30, left: 30),
      decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
      child: ListView(
        children: listWidgets,
      ),
    );
  }
}