import 'package:cmenu/Components/Class/search_item.dart';
import 'package:flutter/material.dart';

class HistoryModel extends ChangeNotifier {
  List<SearchItem> itemNames = [];
  
  delete(SearchItem item) {
        if(itemNames.contains(item)){
            itemNames.remove(item);
        }
    notifyListeners();
  }

  add(SearchItem item) {
        if(!itemNames.contains(item)){
            itemNames.add(item);
        }
    notifyListeners();
  }

  deleteItems() {
    itemNames.clear();
    notifyListeners();
  }



  List<SearchItem> get items => itemNames;

  SearchItem getById(String id) =>
      itemNames.firstWhere((product) => product.id == id);
}
