import 'dart:math';

import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _scrollController = ScrollController();

  // Generate dummy data to fill the ListView
  final List<String> listItems = List.generate(100, (i) => "Item $i");

  // Define the fixed height for an item
  final double _height = 80;

  // Define the function that scroll to an item
  void _scrollToIndex(index) {
    _scrollController.animateTo(_height * index,
        duration: const Duration(seconds: 2), curve: Curves.easeIn);
  }

  // The index of the destination item
  // It is a random number
  int? _destinationIndex;

  // This is ued for creating a random number
  final _random = Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: listItems.length,
            itemBuilder: (_, index) {
              return SizedBox(
                height: _height,
                child: Card(
                  color: index == _destinationIndex
                      ? Colors.orange // Highlight item
                      : Colors.blue[100],
                  child: Center(
                    child: Text(
                      listItems[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _destinationIndex = _random.nextInt(100);
          });
          _scrollToIndex(_destinationIndex);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
