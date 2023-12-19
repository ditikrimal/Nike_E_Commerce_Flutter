import 'package:flutter/material.dart';

class ShopPageBody extends StatefulWidget {
  final SizedBox shoesList;
  final TextEditingController searchController;
  final Function(String) onSearch;

  const ShopPageBody({
    Key? key,
    required this.shoesList,
    required this.searchController,
    required this.onSearch,
  }) : super(key: key);

  @override
  _ShopPageBodyState createState() => _ShopPageBodyState();
}

class _ShopPageBodyState extends State<ShopPageBody> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Search bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 17),
          padding: const EdgeInsets.fromLTRB(15, 5, 1, 5),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  onChanged: (query) {
                    setState(() {
                      isSearching = query.isNotEmpty;
                    });
                    widget.onSearch(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = false;
                  });
                  widget.searchController.clear();
                  FocusScope.of(context).unfocus();
                  widget.onSearch('');
                },
                icon: Icon(
                  isSearching ? Icons.close : Icons.search,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        //show a message
        Container(
          padding: const EdgeInsets.all(15.0),
          alignment: Alignment.center,
          child: Text(
            'where comfort meets fashion, NIKE',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        //hot picks from shoes

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Hot Picks 🔥',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    decoration: TextDecoration.underline),
              )
            ],
          ),
        ),
        widget.shoesList,
      ],
    );
  }
}
