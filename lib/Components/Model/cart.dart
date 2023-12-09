import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Model/item.dart';
import 'package:flutter/foundation.dart';


class CartModel extends ChangeNotifier {
  /// The private field backing [catalog].
  late CatalogModel _catalog;

  /// Internal, private state of the cart. Stores the ids of each item.
  final List<String> _itemIds = [];

  /// The current catalog. Used to construct items from numeric ids.
  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  /// List of items in the cart.
  List<Product> get items {
    return _itemIds.map((id)=> _catalog.getById(id)).toList();
  }

  /// The current total price of all items.
  double get totalPrice =>
      items.fold(0, (total, current) => total + double.parse(current.price));

  String remainingBudget(double budget, double total) {
    return (budget - total).toString();
  }

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Product item) {
    _itemIds.add(item.id);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  int itemCount(Product item) {
    int count = 0;
    for (var id in _itemIds) {
      if (id == item.id) {
        count++;
      }
    }
    return count;
  }
void removeAll() {
    _itemIds.clear();
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }

  void remove(Product item) {
    _itemIds.remove(item.id);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
}
