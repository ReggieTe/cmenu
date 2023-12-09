import 'package:cmenu/Components/Class/search_item.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  final  List<SearchItem> trendingItems;
  const DiscoverScreen({super.key, required this.trendingItems});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      extendBodyBehindAppBar:true,
      backgroundColor: Colors.white,
      body:Stack(
          children: [
           
          ],
        ),
    );
  }
}
