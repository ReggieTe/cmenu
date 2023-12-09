import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Tab/search_list_view.dart';
import 'package:flutter/material.dart';

class TabContentProfileWidget extends StatefulWidget {
  final List<Product> items;
  final MenuCategory categoryName;
  const TabContentProfileWidget({super.key, required this.items, required this.categoryName});

  @override
  State<TabContentProfileWidget> createState() => _TabContentProfileWidgetState();
}

class _TabContentProfileWidgetState extends State<TabContentProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return SearchResultsListView(
      categoryName: widget.categoryName,
      products: widget.items
      );
  }
}
