import 'package:flutter/material.dart';

class AppUpperBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text("yelp diy"));
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}


