import 'dart:io';

import 'package:cmenu/Cart/cart_screen.dart';
import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final String categoryName;
  final Product product;

  const ProductScreen(
      {super.key, required this.product, required this.categoryName});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  double totalBudget = 0.0;
  BannerAd? _bannerAd;
  List<Product> products = [];
  int itemQuantity = 0;
  bool showPromotions = true;
  var settings = SettingPreferences.getSetting();

  @override
  void initState() {
    setState(() {
      var cart = context.read<CartModel>();
      itemQuantity = cart.itemCount(widget.product);
      totalBudget = settings.budget;
    });

    super.initState();
    BannerAd(
      adUnitId:  Platform.isIOS? banneriOS : bannerAndroid,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // print('Failed to load a banner ad: ${err.message}');
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: const Icon(Icons.arrow_back, color: kPrimaryColor)),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              color: kPrimaryColor),
        ),
        actions: [
          Consumer<CartModel>(
            builder: (context, cart, child) => Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const MyCart();
                    }));
                  },
                  child: (cart.items.isNotEmpty)
                      ? badges.Badge(
                          badgeContent: Text(cart.items.length.toString(),
                              style: const TextStyle(color: Colors.white)),
                          child: const Icon(Icons.shopping_bag,
                              color: kPrimaryColor),
                        )
                      : const Icon(Icons.shopping_bag, color: kPrimaryColor),
                )),
          ),
        ],
      ),
      body: Stack(children: [
        Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  if (_bannerAd != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Set Budget",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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
                                  const Text(
                                    'This is the total amount you want to spend',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {});
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Save'))
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Budget",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          Text(
                                              "Total cost of items in your bag",
                                              style: TextStyle(
                                                fontSize: 14,
                                              )),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Common.displayImage(
                                              images: widget.product.images,
                                              displayMultiple: true,
                                              imageWidth: size.width,
                                              imageHeight: size.height * 0.4,
                                              imageType: widget.product.type)),
                                      Text(widget.product.name,
                                          style: const TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 30,
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ])),
                            if (widget.product.description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  widget.product.description,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            Consumer<CartModel>(
                              builder: (context, cart, child) => Text(
                                  "$currencyCode ${widget.product.price}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ])),
                ]))),
        Align(
            alignment: Alignment.bottomCenter,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 10, left: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<CartModel>(
                            builder: (context, cart, child) => GestureDetector(
                              child: const Icon(
                                Icons.remove_circle_rounded,
                                color: kPrimaryColor,
                                size: 40,
                              ),
                              onTap: () {
                                if (cart.items.contains(widget.product)) {
                                  cart.remove(widget.product);
                                  setState(() {
                                    itemQuantity--;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Item removed from order list')));
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(itemQuantity.toString(),
                                style: const TextStyle(fontSize: 30)),
                          ),
                          Consumer<CartModel>(
                              builder: (context, cart, child) =>
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.add_circle_rounded,
                                      color: kPrimaryColor,
                                      size: 40,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        itemQuantity =
                                            cart.itemCount(widget.product) + 1;
                                      });
                                    },
                                  ))
                        ])),
              ),
            ]))
      ]),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Consumer<CartModel>(
            builder: (context, cart, child) => ElevatedButton(
                onPressed: () {
                  int itemsToAdd =
                      itemQuantity = cart.itemCount(widget.product);
                  itemsToAdd = itemsToAdd == 0 ? 1 : itemsToAdd;
                  for (var i = 0; i < itemsToAdd; i++) {
                    cart.add(widget.product);
                  }
                  log(widget.product.id, 'product');
                  setState(() {
                    itemQuantity = cart.itemCount(widget.product);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Item added to order list')));
                },
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          itemQuantity.toString() +
                              (itemQuantity > 1 ? " items" : " item"),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const Text("Add to order",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Consumer<CartModel>(builder: (context, cart, child) {
                          return Text(
                            "$currencyCode ${double.parse(widget.product.price) * itemQuantity} ",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          );
                        })
                      ],
                    )))),
      ),
    );
  }

  log(String id, String section) async {
    try {
      String token = settings.token.isNotEmpty ? settings.token : '1234567890';
      TrackDataModel requestModel =
          TrackDataModel(id: id, section: section, token: token);
      APIServiceList apiService = APIServiceList();
      await apiService.track(requestModel).then((value) async {
        if (value.error) {}
        if (!value.error) {}
      });
    } catch (error) {
      // print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error encounter processing logs")));
    }
  }
}
