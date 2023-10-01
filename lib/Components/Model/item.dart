import 'package:cmenu/Components/Class/product.dart';
import 'package:flutter/material.dart';

class CatalogModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  List<Product> itemNames = [];

  updateItems(List<Product> items) {
    for ( var item in items ){
        if(!itemNames.contains(item)){
            itemNames.add(item);
        }
    }
    notifyListeners();
  }

  deleteItems() {
    itemNames.clear();
    notifyListeners();
  }
  List<Product> get items => itemNames;

  Product getById(String id) =>
      itemNames.firstWhere((product) => product.id == id);

   /// Get item by its position in the catalog.
  Product getByPosition(String position) {
    // In this simplified case, an item's position in the catalog
    // is also its id.
    return getById(position);
  }
}
