import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function onPressed;
  final String name;
  MyButton({this.name, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 160,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Color(0xff746bc9),),
        child: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
