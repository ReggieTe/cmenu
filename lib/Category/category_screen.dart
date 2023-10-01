import 'package:cmenu/Cart/cart_screen.dart';
import 'package:cmenu/Components/Class/category_item.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Model/item.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryItem categoryItem;

  const CategoryScreen({super.key, required this.categoryItem});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final focusNode = FocusNode();
  String query = '';

  bool showSearchBar = false;
  double totalBudget = 0.0;
  BannerAd? _bannerAd;
  List<Product> products = [];
  var settings = SettingPreferences.getSetting();

  @override
  void initState() {
    products = widget.categoryItem.category.products;
    setState(() {
      totalBudget = settings.budget;
    });
    super.initState();
    BannerAd(
      adUnitId: bannerAndroid,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            widget.categoryItem.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                color: kPrimaryColor,
                fontFamily: 'Quicksand'),
          ),
          actions: [
            IconButton(
                icon: const Icon(FontAwesomeIcons.cartShopping,
                    color: kPrimaryColor),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyCart();
                  }));
                })
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (_bannerAd != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              Text(
                widget.categoryItem.address,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    overflow: TextOverflow.fade),
              ),
              GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Set Budget",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 20,
                              )),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter amount',
                                  ),
                                  onChanged: (value) {
                                    var setting = settings.copy(
                                        budget: double.parse(value));
                                    SettingPreferences.setSetting(setting);
                                    setState(() {
                                      totalBudget = double.parse(value);
                                    });
                                  },
                                ),
                              ),
                              Text(
                                'This is the total amount you want to spend',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Cancel')),
                                TextButton(
                                    onPressed: () {
                                      setState(() {});
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Save'))
                              ],
                            )
                          ],
                        );
                      },
                    );
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Remaining Budget",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                      Text("Total cost of item on your list",
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Consumer<CartModel>(
                                        builder: (context, cart, child) => Text(
                                            "$currencyCode ${cart.remainingBudget(totalBudget, cart.totalPrice)}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor)),
                                      ),
                                      Consumer<CartModel>(
                                        builder: (context, cart, child) => Text(
                                            "$currencyCode ${cart.totalPrice}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor)),
                                      )
                                    ],
                                  ),
                                ],
                              ))))),
              Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.categoryItem.category.name,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis)),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 0),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(
                                        widget.categoryItem.category.products
                                            .length
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))))
                      ])),
              if (widget.categoryItem.category.description.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      widget.categoryItem.category.description,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    )),
              if (showSearchBar)
                if (query.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Found " +
                          products.length.toString() +
                          " items for '" +
                          query +
                          "'",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              Expanded(
                  flex: 1,
                  child: Consumer<CatalogModel>(
                      builder: (context, catalog, child) {
                    return ListView.builder(
                        itemCount: catalog.items.length,
                        itemBuilder: (context, index) => (products
                                .contains(catalog.items[index]))
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(catalog.items[index].name,
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14,
                                            )),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Image.asset(
                                                  "assets/images/tray.png",
                                                )),
                                            if (catalog.items[index].description
                                                .isNotEmpty)
                                              Text(
                                                catalog
                                                    .items[index].description,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Consumer<CartModel>(
                                                  builder: (context, cart,
                                                          child) =>
                                                      Text(
                                                          "$currencyCode ${catalog.items[index].price}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 15),
                                                    child: Container(
                                                        decoration: const BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    228,
                                                                    227,
                                                                    227),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0))),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                bottom: 5,
                                                                left: 5,
                                                                right: 5),
                                                        child: Column(
                                                          children: [
                                                            _ActionButton(
                                                                delete: false,
                                                                item: catalog
                                                                        .items[
                                                                    index]),
                                                            Consumer<CartModel>(
                                                              builder: (context, cart, child) => Text(
                                                                  "${cart.itemCount(catalog.items[index]) != 0 ? "${cart.itemCount(catalog.items[index]).toString()}" : "0"}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          kPrimaryColor)),
                                                            ),
                                                            _ActionButton(
                                                                delete: true,
                                                                item: catalog
                                                                        .items[
                                                                    index])
                                                          ],
                                                        )))
                                              ],
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: Text('Cancel'))
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 244, 244, 244),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                        padding: const EdgeInsets.only(
                                            top: 0, bottom: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Image.asset(
                                                      "assets/images/tray.png",
                                                      height: 50,
                                                      width: 50,
                                                    )),
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        catalog
                                                            .items[index].name,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                      Consumer<CartModel>(
                                                        builder: (context, cart,
                                                                child) =>
                                                            Text(
                                                                "$currencyCode ${catalog.items[index].price}",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                      )
                                                    ])
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 15),
                                                child: Container(
                                                    decoration: const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 228, 227, 227),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0))),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 5,
                                                            left: 5,
                                                            right: 5),
                                                    child: Column(
                                                      children: [
                                                        _ActionButton(
                                                            delete: false,
                                                            item: catalog
                                                                .items[index]),
                                                        Consumer<CartModel>(
                                                          builder: (context, cart, child) => Text(
                                                              "${cart.itemCount(catalog.items[index]) != 0 ? "${cart.itemCount(catalog.items[index]).toString()}" : "0"}",
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      kPrimaryColor)),
                                                        ),
                                                        _ActionButton(
                                                            delete: true,
                                                            item: catalog
                                                                .items[index])
                                                      ],
                                                    )))
                                          ],
                                        ))))
                            : Container());
                  })),
              if (showSearchBar)
                Container(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SearchBar(
                        controller: _textEditingController,
                        shape: MaterialStateProperty.all(
                            const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )),
                        shadowColor: MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        hintText: 'Type keyword',
                        hintStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.grey)),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.teal)),
                        onChanged: (String value) {
                          setState(() {                            
                              query = value;
                            if (value.isNotEmpty) {
                              products = products
                                  .where((e) => e.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            } else {
                              products = widget.categoryItem.category.products;
                            }
                          });
                        },
                        onTap: () {},
                        trailing: [],
                      ),
                    )),
            ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: showSearchBar ? Colors.red : kPrimaryColor,
          onPressed: () {
            if (showSearchBar) {
              setState(() {
                showSearchBar = false;
                products = widget.categoryItem.category.products;
              });
            } else {
              setState(() {
                showSearchBar = true;
              });
            }
          },
          child: Icon(
            showSearchBar ? Icons.cancel_rounded : Icons.search,
            color: Colors.white,
          ),
        ));
  }
}

class _ActionButton extends StatelessWidget {
  final Product item;
  final bool delete;

  const _ActionButton({required this.item, required this.delete});

  @override
  Widget build(BuildContext context) {
    var isInCart = context.select<CartModel, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (cart) => cart.items.contains(item),
    );
    return GestureDetector(
      child: delete
          ? Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            )
          : Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.green,
            ),
      onTap: () {
        var cart = context.read<CartModel>();
        String message = 'Item added to cart';
        if (delete) {
          if (isInCart) {
            var cart = context.read<CartModel>();
            cart.remove(item);
            message = 'Item removed from cart';
          }
        } else {
          cart.add(item);
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message.toString())));
      },
    );
  }
}
