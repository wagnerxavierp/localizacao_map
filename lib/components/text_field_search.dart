import 'package:flutter/material.dart';

class TextFieldSearch extends StatelessWidget {

  TextEditingController textSearchController;
  Function search;
  String hint;

  TextFieldSearch({ Key? key, required this.textSearchController, required this.search, required this.hint }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
              height: 50,
              margin: const EdgeInsets.only(right: 30, left: 30, top: 70),
              child: TextField(
                controller: textSearchController,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[500]),
                  hintText: hint,
                  fillColor: Colors.white70,
                  suffixIcon: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      search();
                    },
                    icon: Icon(Icons.search),
                  )
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            );
  }
}