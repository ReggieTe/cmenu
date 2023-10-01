import 'package:cmenu/Category/category_screen.dart';
import 'package:cmenu/Components/Class/category_item.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Model/Item.dart';
import 'package:cmenu/Components/empty_page_content.dart';
import 'package:cmenu/Home/components/background.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final SearchItem searchItem;
  const Body({super.key, required this.searchItem});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double totalBudget = 0.0;

  //late setting = SettingPreferences.getSetting();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.searchItem.address,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  overflow: TextOverflow.fade),
            ),
            GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const CartScreen();
                  // }));
                },
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Budget",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  Text("Total cost of item on your list",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<CartModel>(
                                    builder: (context, cart, child) => Text(
                                        "$currencyCode ${cart.remainingBudget(totalBudget, cart.totalPrice).toString()}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Consumer<CartModel>(
                                    builder: (context, cart, child) => Text(
                                        "$currencyCode  ${cart.totalPrice}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ],
                              ),
                            ],
                          ))))),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Menu",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                            decoration: const BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                    widget.searchItem.categories.length
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)))))
                  ],
                )),
            if (widget.searchItem.categories.isNotEmpty)
              for (var category in widget.searchItem.categories)
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: ListTile(
                          leading: const Icon(FontAwesomeIcons.list),
                          title: Text(category.name,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          trailing: Container(
                              decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                    category.products.length.toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          subtitle: Text(category.description,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                              )),
                          onTap: () {
                            // var catalog = Provider.of<CatalogModel>(context, listen: false);
                            // catalog.updateItems(category.products);
                            var catalog = context.read<CatalogModel>();
                            catalog.updateItems(category.products);
                            
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CategoryScreen(
                                  categoryItem:
                                      CategoryItem(widget.searchItem.name, widget.searchItem.address, category));
                            }));
                          },
                        ))),
            if (widget.searchItem.categories.isEmpty)
              const EmptyPageContent(
                  imageLink: "assets/images/color/notification.png",
                  label: 'Menu empty')
          ],
        ),
      ),
    );
  }
}
