import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  final ValueChanged<String> onSearch;

  Searchbar({required this.onSearch});

  @override
  _SearchbarState createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final TextEditingController _controller = TextEditingController();

  void _onSearchSubmitted(String query) {
    widget.onSearch(query);
  }

  // Method to handle when the search icon is clicked
  void _onSearchIconClicked() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch(query); // Trigger the search when the icon is clicked
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: _onSearchSubmitted, // Trigger search on "enter"
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Your Products",
                ),
              ),
            ),
            GestureDetector(
              onTap: _onSearchIconClicked, // Trigger search on icon click
              child: const Icon(
                Icons.search_outlined,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
