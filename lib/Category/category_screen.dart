import 'package:cmenu/Cart/cart_screen.dart';
import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/category_item.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Model/item.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Single/gallery_screen.dart';
import 'package:cmenu/Single/product_screen.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryItem categoryItem;
  final SearchItem searchItem;

  const CategoryScreen({super.key,required this.searchItem, required this.categoryItem});

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
  bool showPromotions = true;
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
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          //print('Failed to load a banner ad: ${err.message}');
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
                            child: const Icon(FontAwesomeIcons.list,
                                color: kPrimaryColor),
                          )
                        : const Icon(FontAwesomeIcons.list),
                  )),
            ),
          ],
        ),
        body: Column(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Remaining Budget",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                      Text("Total cost of items on your list",
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
             if (widget.searchItem.ads.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Promotions (${widget.searchItem.ads.length})",
                                    style: const TextStyle(fontSize: 16)),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showPromotions =
                                          showPromotions ? false : true;
                                    });
                                  },
                                  child: Text(
                                    showPromotions ? "Hide" : "View",
                                    style: TextStyle(
                                        color: showPromotions
                                            ? Colors.red
                                            : kPrimaryColor),
                                  ),
                                )
                              ],
                            ),
                            if (showPromotions)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (var i in widget.searchItem.ads)
                                      GestureDetector(
                                          onTap: () {
                                            log(i.id, "ad");
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return GalleryScreen(
                                                  searchItem: widget.searchItem,
                                                  images: i.images);
                                            }));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Common.displayImage(
                                                images: i.images,
                                                imageType: 'ad',
                                                imageHeight: size.height * 0.20,
                                                imageWidth: size.width * 0.30),
                                          ))
                                  ],
                                ),
                              )
                          ])),
             
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
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Found ${products.length} items for '$query'",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              if (widget.categoryItem.category.categories.isNotEmpty)
                for (var category in widget.categoryItem.category.categories)
                  Padding(
                      padding: const EdgeInsets.only(
                        bottom: 3,
                      ),
                      child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(15, 153, 153, 153),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: ListTile(
                            leading: Common.displayImage(
                                images: category.images,
                                imageType: 'place',
                                imageHeight: 80,
                                imageWidth: 80),
                            title: Text(category.name,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                )),
                            trailing: Container(
                                decoration: const BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 0),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(
                                      category.products.length.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: kPrimaryColor,
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
                              log(widget.categoryItem.id, 'category');
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CategoryScreen(
                                    searchItem:widget.searchItem,
                                    categoryItem: CategoryItem(
                                        widget.categoryItem.id,
                                        widget.categoryItem.name,
                                        widget.categoryItem.address,
                                        category));
                              }));
                            },
                          ))),
              Expanded(
                  flex: 1,
                  child: Consumer<CatalogModel>(
                      builder: (context, catalog, child) {
                    return ListView.builder(
                        itemCount: catalog.items.length,
                        itemBuilder: (context, index) => (products
                                .contains(catalog.items[index]))
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 3,
                                ),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(15, 153, 153, 153),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ProductScreen(
                                                  searchItem: widget.searchItem,
                                                  categoryItem:
                                                      widget.categoryItem,
                                                  product: catalog.items[index],
                                                );
                                              }));
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: SizedBox(
                                                        child: Common.displayImage(
                                                            images: catalog
                                                                .items[index]
                                                                .images,
                                                            imageHeight: 80,
                                                            imageWidth: 80,
                                                            imageType: catalog
                                                                .items[index]
                                                                .type,
                                                            defaultImageFromUser:
                                                                "dish"))),
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.6,
                                                          child: Text(
                                                            catalog.items[index]
                                                                .name,
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          )),
                                                      if (catalog
                                                          .items[index]
                                                          .description
                                                          .isNotEmpty)
                                                        SizedBox(
                                                            width: size.width *
                                                                0.6,
                                                            child: Text(
                                                              catalog
                                                                  .items[index]
                                                                  .description,
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            )),
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
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10, right: 15),
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 228, 227, 227),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0))),
                                                padding: const EdgeInsets.only(
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
                                                          cart.itemCount(catalog
                                                                          .items[
                                                                      index]) !=
                                                                  0
                                                              ? cart
                                                                  .itemCount(
                                                                      catalog.items[
                                                                          index])
                                                                  .toString()
                                                              : "0",
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
                                    )))
                            : Container());
                  })),
              if (showSearchBar)
                Container(
                    margin: const EdgeInsets.all(10),
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
                        trailing: const [],
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
    return GestureDetector(
      child: widget.delete
          ? const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            )
          : const Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.green,
            ),
      onTap: () {
        var cart = context.read<CartModel>();
        String message = '';
        if (widget.delete) {
          cart.remove(widget.item);
          message = 'Item removed from order list';
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
      //print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error encounter processing logs")));
    }
  }
}
