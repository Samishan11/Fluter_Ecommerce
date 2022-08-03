import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_commerce/screens/contactus.dart';
import 'package:e_commerce/screens/homepage.dart';
import 'package:e_commerce/screens/profilescreen.dart';
import 'package:flutter/material.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({Key key}) : super(key: key);

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  @override
  Widget build(BuildContext context) {
    return Container(child: CurvedNavigationBar(
        height :50,
        backgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 300),
        onTap: (ind){
          print(ind);
          if(ind==0){
            Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => HomePage()));
          }else if(ind==1){
            Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => ProfileScreen()));
          }else{
            Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => ContactUs()));
          }
        },
        items: [
          Icon(Icons.home),
          Icon(Icons.person),
          Icon(Icons.settings),
        ],
      ),
    );
  }
}