import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({Key? key}) : super(key: key);

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          prefixIcon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
