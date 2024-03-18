import 'package:flutter/material.dart';
import 'package:test/product.dart';

class SearchableDropdown extends StatefulWidget {
  final List<Product> items;
  final String title;
  final void Function(Product) onItemSelected;

  const SearchableDropdown({
    Key? key,
    required this.items,
    required this.title,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  SearchableDropdownState createState() => SearchableDropdownState();
}

class SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  late List<Product> _filteredItems;
  Product? _selectedItem;

  @override
  void initState() {
    _filteredItems = List.from(widget.items);
    super.initState();
  }

  void _filterItems(String query) {
    List<Product> filteredList = widget.items.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.price.toString().contains(query);
    }).toList();

    setState(() {
      _filteredItems.clear();
      _filteredItems.addAll(filteredList);
    });
  }

  void _showItemSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.title),
          content: SizedBox(
            height: 500,
            width: double.maxFinite,
            child: _buildItemSelectionList(context),
          ),
        );
      },
    );
  }

  Widget _buildItemSelectionList(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _filteredItems.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _filterItems(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for a ${widget.title}',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              );
            } else {
              Product item = _filteredItems[index - 1];
              return ListTile(
                title: Text('${item.name} - ${item.price}'),
                onTap: () {
                  setState(() {
                    _selectedItem = item;
                  });
                  widget.onItemSelected(
                      item); // Thông báo cho widget cha khi một mục được chọn
                  Navigator.pop(context);
                },
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showItemSelectionDialog(context),
      child: Text(_selectedItem != null
          ? _selectedItem!.name
          : 'Select ${widget.title}'),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String selectedTitle = 'Select Product';
  List<Product> products1 = [
    Product('1', 'Product 1', 10.0),
    Product('2', 'Product 2', 20.0),
    Product('3', 'Product 3', 30.0),
    Product('4', 'Product 4', 40.0),
    Product('5', 'Product 5', 50.0),
  ];

  List<Product> products2 = [
    Product('6', 'Another Product 1', 60.0),
    Product('7', 'Another Product 2', 70.0),
    Product('8', 'Another Product 3', 80.0),
    Product('9', 'Another Product 4', 90.0),
    Product('10', 'Another Product 5', 100.0),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Searchable Dropdown Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchableDropdown(
              onItemSelected: (value) {
                setState(() {
                  selectedTitle = value.name;
                });
              },
              items: products1,
              title: 'Product',
            ),
            SearchableDropdown(
              onItemSelected: (value) {
                setState(() {
                  selectedTitle = value.name;
                });
              },
              items: products2,
              title: 'Another Product',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
