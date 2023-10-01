import 'package:cmenu/Cart/cart_screen.dart';
import 'package:cmenu/Category/category_screen.dart';
import 'package:cmenu/Components/Class/category_item.dart';
import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Model/item.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Components/empty_page_content.dart';
import 'package:cmenu/Home/components/background.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final SearchItem searchItem;
  const HomeScreen({super.key, required this.searchItem});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  double totalBudget = 0.0;
  var settings = SettingPreferences.getSetting();
  final TextEditingController _textEditingController = TextEditingController();
  final focusNode = FocusNode();
  String query = '';

  bool showSearchBar = false;
  List<MenuCategory> categories = [];

  @override
  void initState() {
    categories = widget.searchItem.categories;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            widget.searchItem.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontFamily: 'Quicksand',
                overflow: TextOverflow.ellipsis),
          ),
          actions: <Widget>[
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
        body: Background(
            child: Column(
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
              Column(children: [
                Text(
                  widget.searchItem.address,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Consumer<CartModel>(
                                          builder: (context, cart, child) => Text(
                                              "$currencyCode ${cart.remainingBudget(totalBudget, cart.totalPrice).toString()}",
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
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Menu",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
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
                                        widget.searchItem.categories.length
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)))))
                      ],
                    )),
              ]),
              if (categories.isNotEmpty)
                Expanded(
                    //flex: 1,
                    child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 0.5, color: kPrimaryColor),
                        )),
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: ListTile(
                          leading: Image.asset(
                            "assets/images/restaurant.png",
                            height: 50,
                          ),
                          title: Text(categories[index].name,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                              )),
                          trailing: Container(
                              decoration: const BoxDecoration(
                                  color: kPrimaryLightColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                    categories[index]
                                        .products
                                        .length
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          subtitle: Text(categories[index].description,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                              )),
                          onTap: () {
                            // var catalog = Provider.of<CatalogModel>(context, listen: false);
                            // catalog.updateItems(category.products);
                            var catalog = context.read<CatalogModel>();
                            catalog.updateItems(categories[index].products);

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CategoryScreen(
                                  categoryItem: CategoryItem(
                                      widget.searchItem.name,
                                      widget.searchItem.address,
                                      categories[index]));
                            }));
                          },
                        ));
                  },
                )),
              if (categories.isEmpty)
                Container(
                    height: size.height * 0.6,
                    child: Center(
                        child: const EmptyPageContent(
                            imageLink: "assets/images/menu.png",
                            label: '0 items available'))),
              if (showSearchBar)
                if (categories.isNotEmpty)
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
                                categories = categories
                                    .where((e) =>
                                        e.name
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        e.description
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                    .toList();
                              } else {
                                categories = widget.searchItem.categories;
                              }
                            });
                          },
                          onTap: () {},
                          trailing: [],
                        ),
                      ))
            ])),
        floatingActionButton: FloatingActionButton(
          backgroundColor: showSearchBar ? Colors.red : kPrimaryColor,
          onPressed: () {
            if (categories.isNotEmpty) {
              if (showSearchBar) {
                setState(() {
                  showSearchBar = false;
                  categories = widget.searchItem.categories;
                });
              } else {
                setState(() {
                  showSearchBar = true;
                });
              }
            }else{
              ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Nothing to search")));
            }
          },
          child: Icon(
            showSearchBar ? Icons.cancel_rounded : Icons.search,
            color: Colors.white,
          ),
        ));
  }
}
