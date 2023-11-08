import 'package:cmenu/Cart/cart_screen.dart';
import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/category_item.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  final CategoryItem categoryItem;

  const ProductScreen(
      {super.key, required this.product, required this.categoryItem});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  double totalBudget = 0.0;
  BannerAd? _bannerAd;
  List<Product> products = [];
  var settings = SettingPreferences.getSetting();

  @override
  void initState() {
    setState(() {
      totalBudget = settings.budget;
    });
    super.initState();
    BannerAd(
      adUnitId: bannerAndroid,
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
        title: Text(
          widget.categoryItem.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              color: kPrimaryColor,
              fontFamily: 'Quicksand'),
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
                          child:
                              const Icon(FontAwesomeIcons.list, color: kPrimaryColor),
                        )
                      : const Icon(FontAwesomeIcons.list),
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
                                          Text("Remaining Budget",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          Text(
                                              "Total cost of items on your list",
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
                      child:                  
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: Common.displayImage(
                                    images: widget.product.images,
                                    displayMultiple: true,
                                    imageWidth: size.width * 0.8,
                                    imageHeight: size.height * 0.4,
                                    imageType: 'food')),
                             Text(widget.product.name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis)),
                          ])),        
                            Consumer<CartModel>(
                              builder: (context, cart, child) =>
                                  Text("$currencyCode ${widget.product.price}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      )),
                            ),
                            if (widget.product.description.isNotEmpty)
                              Text(
                                widget.product.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: size.height*0.2,)
                          ]))
                    ],
                  ))),
        Align(
            alignment: Alignment.bottomCenter,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Container(
                decoration: const BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ActionButton(delete: true, item: widget.product),
                          Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Consumer<CartModel>(
                                builder: (context, cart, child) => Text(
                                    cart.itemCount(widget.product) != 0 ? cart.itemCount(widget.product).toString() : "0",
                                    style: const TextStyle(
                                        fontSize: 30, color: kPrimaryColor)),
                              )),
                          _ActionButton(delete: false, item: widget.product)
                        ]),                        
                        
                        )),
                        
                            Consumer<CartModel>(
                                builder: (context, cart, child) {
                              if (cart.itemCount(widget.product) > 0) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: kPrimaryLightColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Note",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "Money to be spent on this item is  $currencyCode ${double.parse(widget.product
                                                                .price) *
                                                            cart.itemCount(
                                                                widget.product)} because you have placed ${cart.itemCount(widget.product).toString()} of this item on your order list leaving you with $currencyCode ${cart.remainingBudget(totalBudget, cart.totalPrice)} balance on your budget.",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                )),
                                          ])),
                                );
                              }

                              return Container();
                            })
                        
                        ]))
      ]),
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

class _ActionButton extends StatefulWidget {
  final Product item;
  final bool delete;

  const _ActionButton({required this.item, required this.delete});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  var settings = SettingPreferences.getSetting();

  @override
  Widget build(BuildContext context) {
  
return Consumer<CartModel>(
   builder: (context, cart, child) => GestureDetector(
      child: widget.delete
          ? const Icon(
              Icons.remove_circle_outline,
              color: Colors.redAccent,
              size: 40,
            )
          : const Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.green,
              size: 40,
            ),
      onTap: () {
        String message = '';
        if (widget.delete) {
          if (cart.catalog.items.contains(widget.item)) {
            cart.remove(widget.item);
            message = 'Item removed from order list';
          }
        } else {
          cart.add(widget.item);
          message = 'Item added to order list';
          log(widget.item.id, 'product');
        }
        if (message.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.toString())));
        }
      },
    ),
                              )

    
    ;
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
      //print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error encounter processing logs")));
    }
  }
}
