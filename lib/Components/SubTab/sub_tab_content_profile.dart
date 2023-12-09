import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Tab/search_list_view.dart';
import 'package:flutter/material.dart';

class SubTabContentProfileWidget extends StatefulWidget {
  final List<Product> items;
  final MenuCategory categoryName;
  const SubTabContentProfileWidget({super.key, required this.items, required this.categoryName});

  @override
  State<SubTabContentProfileWidget> createState() => _SubTabContentProfileWidgetState();
}

class _SubTabContentProfileWidgetState extends State<SubTabContentProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return SearchResultsListView(
      categoryName: widget.categoryName,
      products: widget.items
      );
  }
}
