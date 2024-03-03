import 'package:flutter/material.dart';
import 'package:p2p/models/item.dart';

class EditItemsProvider extends ChangeNotifier {
  List<Item> _item = [];

  List<Item> get items => _item;

  void addItem(Item item) {
    _item.add(item);
    notifyListeners();
  }

  void removeList() {
    _item.clear();
    notifyListeners();
  }

  void addItems(List<Item> item) {
    _item.clear();
    _item.addAll(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _item.removeAt(index);
    notifyListeners();
  }

  void editItem(int? index, Item editedItem) {
    print("desc:-----${editedItem.description}");
    _item[index!] = editedItem;
    notifyListeners();
  }

  Item getById(int? index) {
    return items[index!];
  }
}
