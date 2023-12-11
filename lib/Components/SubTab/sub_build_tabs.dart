import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/SubTab/sub_tab_content_profile.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';

class SubBuildTabs extends StatefulWidget {
  final List<MenuCategory> categories;
  const SubBuildTabs({super.key, required this.categories});

  @override
  State<SubBuildTabs> createState() => _SubBuildTabsState();
}

class _SubBuildTabsState extends State<SubBuildTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.categories.length, // length of tabs
        initialIndex: 0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
             Padding(padding: const EdgeInsets.only(bottom: 10,top:5),child:TabBar(
                  labelColor: kPrimaryColor,
                  isScrollable: true,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    for (var tabItem in widget.categories)                   
                        Text(tabItem.name,style:const TextStyle(fontSize: 16),)                      
                  ],
                )),
              Container(
                  height: double.maxFinite,
                  decoration: const BoxDecoration(
                      
                          
                          ),
                  child: TabBarView(children: <Widget>[
                    for (var tabItem in widget.categories)
                      SubTabContentProfileWidget(
                        categoryName: tabItem,
                        items: tabItem.products
                        )
                  ]))
            ]));
  }
}