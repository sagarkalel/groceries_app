import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:groceries_app/data/categories.dart';
import 'package:groceries_app/models/grocery_item.dart';
import 'package:groceries_app/screens/new_item.dart';
import 'package:http/http.dart' as data;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroceryItem> _groceryItems = [];
  double sliderValue = 0;
  bool _isLoading = true;
  String? _error;

  void _loadItems() async {
    final url = Uri.https(
        "myfirstprojectsagar1-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping-list.json");
    try {
      final response = await data.get(url);
      if (response.statusCode >= 400) {
        _error = "Failed to fetched data, please try again later!";
        setState(() {});
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      _error = "sorry.something went wrong, please try again later!";
      setState(() {});
    }
  }

  void _addItem() async {
    final myItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));
    if (myItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(myItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https(
        "myfirstprojectsagar1-default-rtdb.asia-southeast1.firebasedatabase.app",
        "shopping-list/${item.id}.json");
    final response = await data.delete(url);
    if (response.statusCode >= 400) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Sorry, item can't be deleted, something went wrong")));
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Sorry!, no items added yet.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: Colors.white70),
          ),
          Text("${(sliderValue * 100 / 10).toStringAsFixed(0)}%"),
          Slider(
              value: sliderValue,
              label: "sagar",
              thumbColor: Colors.amber,
              min: 0.0,
              max: 10,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              })
        ],
      ),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, color: Colors.white70),
        ),
      );
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (_, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id.toString()),
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Stack(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  color: _groceryItems[index].category.color,
                ),
              ],
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
