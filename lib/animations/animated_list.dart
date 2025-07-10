import 'package:flutter/material.dart';

class AnimatedCardList extends StatefulWidget {
  const AnimatedCardList({super.key});

  @override
  State<AnimatedCardList> createState() => _AnimatedCardListState();
}

class _AnimatedCardListState extends State<AnimatedCardList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<String> _items = List.generate(5, (index) => 'Item ${index + 1}');

  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(index, (context, animation) {
      return _buildItem(removedItem, animation, index, isRemoving: true);
    }, duration: const Duration(milliseconds: 600));
  }

  Widget _buildItem(
    String item,
    Animation<double> animation,
    int index, {
    bool isRemoving = false,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        color: isRemoving ? Colors.red.shade100 : Colors.blue.shade100,
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeItem(index),
          ),
        ),
      ),
    );
  }

  void _addItem() {
    final newIndex = _items.length;
    _items.add('Item ${newIndex + 1}');
    _listKey.currentState?.insertItem(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Card List')),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_items[index], animation, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
