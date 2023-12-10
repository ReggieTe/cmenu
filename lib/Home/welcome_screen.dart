// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cmenu/Cart/cart_screen.dart';
import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Tab/build_tabs.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Components/empty_page_content.dart';
import 'package:cmenu/Components/home_section.dart';
import 'package:cmenu/Components/progress_loader.dart';
import 'package:cmenu/Home/components/background.dart';
import 'package:cmenu/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final ScrollController _controller = ScrollController();
  final focusNode = FocusNode();
  String query = '';
  bool inProgress = false;
  bool showSearchBar = false;
  bool showMoreInfo = false;
  bool showPlaceInfor = true;
  bool makeAppBarTransparent = true;
  List<MenuCategory> categories = [];
  bool _bannerAdIsLoaded = false;

  String path = '';
  bool downloading = false;
  String downloadingStr = "No data";
  double download = 0;
  String savePath = "";
  bool showPromotions = true;

  @override
  void initState() {
    categories = widget.searchItem.categories;
    _controller.addListener(_onScrollEvent);
    setState(() {
      totalBudget = settings.budget;
    });
    super.initState();
    _bannerAd?.dispose();
    BannerAd(
      adUnitId: Platform.isIOS? banneriOS : bannerAndroid,
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
  void didChangeDependencies() {
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
      size: AdSize.banner,
      request: const AdRequest(),
      adUnitId: Platform.isIOS? banneriOS : bannerAndroid,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
         // print('$BannerAd loaded.');
          setState(() => _bannerAdIsLoaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          //print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) {
          //print('$BannerAd onAdOpened.');
        },
        onAdClosed: (Ad ad) {
          //print('$BannerAd onAdClosed.');
        },
      ),
    )..load();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _controller.removeListener(_onScrollEvent);
    _textEditingController.dispose();
    super.dispose();
  }

  void _onScrollEvent() {
    setState(() {
      makeAppBarTransparent =
          _controller.position.pixels == _controller.position.minScrollExtent
              ? true
              : false;
    });
  }

  @override
  Widget build(BuildContext context) => ProgressLoader(
        inAsyncCall: inProgress,
        opacity: 0.3,
        child: _uiSetup(context),
      );

  Widget bannerAdWidget() {
    return _bannerAd != null && _bannerAdIsLoaded
        ? Center(child: StatefulBuilder(
            builder: (context, setState) => Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              alignment: Alignment.center,
              child: AdWidget(ad: _bannerAd!),
            ),
          ))
        : Container();
  }

  Widget _uiSetup(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: makeAppBarTransparent
          ? widget.searchItem.images.isNotEmpty
              ? showSearchBar
                  ? false
                  : true
              : false
          : false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: makeAppBarTransparent
            ? widget.searchItem.images.isNotEmpty
                ? Colors.transparent
                : Colors.grey
            : null,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(Icons.arrow_back,
                color: makeAppBarTransparent
                    ? widget.searchItem.images.isNotEmpty
                        ? showSearchBar
                            ? kPrimaryColor
                            : Colors.grey
                        : kPrimaryColor
                    : kPrimaryColor)),
        title: GestureDetector(
            onTap: () {},
            child: widget.searchItem.images.isNotEmpty
                ? Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          showSearchBar ? widget.searchItem.name : "cMenu",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                              fontFamily: 'Quicksand',
                              overflow: TextOverflow.ellipsis),
                        )))
                : Text(
                    showSearchBar ? widget.searchItem.name : "cMenu",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontFamily: 'Quicksand',
                        overflow: TextOverflow.ellipsis),
                  )),
        actions: <Widget>[
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
                          child: Icon(Icons.shopping_bag,
                              color: makeAppBarTransparent
                                  ? widget.searchItem.images.isNotEmpty
                                      ? showSearchBar
                                          ? kPrimaryColor
                                          : Colors.grey
                                      : kPrimaryColor
                                  : kPrimaryColor),
                        )
                      : Icon(Icons.shopping_bag,
                          color: makeAppBarTransparent
                              ? widget.searchItem.images.isNotEmpty
                                  ? showSearchBar
                                      ? kPrimaryColor
                                      : Colors.grey
                                  : kPrimaryColor
                              : kPrimaryColor),
                )),
          ),
        ],
      ),
      body: Background(
          child: SingleChildScrollView(
              controller: _controller,
              child: SizedBox(
                  height: double.maxFinite,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (showPlaceInfor)
                          HomeSection(
                            searchItem: widget.searchItem,
                            size: size,
                          ),
                        bannerAdWidget(),
                        Column(children: [
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
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: 'Enter amount',
                                              ),
                                              onChanged: (value) {
                                                var setting = settings.copy(
                                                    budget:
                                                        double.parse(value));
                                                SettingPreferences.setSetting(
                                                    setting);
                                                setState(() {
                                                  totalBudget =
                                                      double.parse(value);
                                                });
                                              },
                                            ),
                                          ),
                                          const Text(
                                            'This is the total amount you want to spend',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
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
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {});
                                                  Navigator.of(context)
                                                      .pop(false);
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      padding: const EdgeInsets.only(
                                          top: 0, bottom: 0),
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
                                                          fontWeight:
                                                              FontWeight.w600)),
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
                                                    builder: (context, cart,
                                                            child) =>
                                                        Text(
                                                            "$currencyCode ${cart.remainingBudget(totalBudget, cart.totalPrice).toString()}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    kPrimaryColor)),
                                                  ),
                                                  Consumer<CartModel>(
                                                    builder: (context, cart,
                                                            child) =>
                                                        Text(
                                                            "$currencyCode ${cart.totalPrice}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    kPrimaryColor)),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ))))),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Menu",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () async {
                                              await _downloadMenu(
                                                  id: widget.searchItem.id);
                                            },
                                            child: const Icon(Icons
                                                .download_for_offline_outlined)),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (categories.isNotEmpty) {
                                                  if (showSearchBar) {
                                                    setState(() {
                                                      showSearchBar = false;
                                                      showPlaceInfor = true;
                                                      showPromotions = true;
                                                      makeAppBarTransparent =
                                                          true;
                                                      categories = widget
                                                          .searchItem
                                                          .categories;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      showSearchBar = true;
                                                      showPlaceInfor = false;
                                                      makeAppBarTransparent =
                                                          false;
                                                      showPromotions = false;
                                                      showMoreInfo = false;
                                                    });
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Nothing to search")));
                                                }
                                              },
                                              child: Icon(
                                                showSearchBar
                                                    ? Icons.cancel_rounded
                                                    : FontAwesomeIcons
                                                        .magnifyingGlass,
                                                color: showSearchBar
                                                    ? Colors.red
                                                    : kPrimaryColor,
                                              ),
                                            )),
                                      ],
                                    )
                                  ],
                                )),
                        ]),
                        if (showSearchBar)
                          if (categories.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 10),
                              child: SearchBar(
                                leading: const Icon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  color: kPrimaryColor,
                                ),
                                controller: _textEditingController,
                                shape: MaterialStateProperty.all(
                                    const ContinuousRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                )),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.white),
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
                                      categories = categories.where((e) {
                                        var item = e.products.where((element) =>
                                            element.name
                                                .toLowerCase()
                                                .contains(value.toLowerCase()));

                                        return e.name.toLowerCase().contains(
                                                value.toLowerCase()) ||
                                            e.description
                                                .toLowerCase()
                                                .contains(
                                                    value.toLowerCase()) ||
                                            item.isNotEmpty;
                                      }).toList();
                                    } else {
                                      categories = widget.searchItem.categories;
                                    }
                                  });
                                },
                                onTap: () {},
                                trailing: const [],
                              ),
                            ),
                        if (categories.isNotEmpty)
                          BuildTabs(categories: categories),
                        if (categories.isEmpty)
                          SizedBox(
                              height: size.height * 0.6,
                              child: const Center(
                                  child: EmptyPageContent(
                                      imageLink: "assets/images/menu.png",
                                      label: '0 items available'))),
                      ])))),
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

  _downloadMenu({String id = ''}) async {
    try {
      setState(() {
        inProgress = true;
      });
      String token = settings.token.isNotEmpty ? settings.token : '1234567890';
      RequestDataModel requestModel =
          RequestDataModel(keyword: id, id: id, token: token);
      APIServiceList apiService = APIServiceList();

      await (apiService.download(requestModel)).then((value) async {
        setState(() {
          inProgress = false;
        });
        if (value.error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Failed to get menu.Try again later')));
        }
        if (!value.error) {
          if (value.data['data']['file'] != "" &&
              value.data['data']['file'] != false) {
            createPdf(value.data['data']['file']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Failed to get menu.Try again later')));
          }
        }
      });
    } catch (error) {
      setState(() {
        inProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error encounter processing menu download")));
    }
  }

  createPdf(String fileUrl) async {
    try {
      bool permissionGranted = true;
      DeviceInfoPlugin plugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo android = await plugin.androidInfo;
        if (android.version.sdkInt < 33) {
          if (await Permission.storage.request().isGranted) {
            setState(() {
              permissionGranted = true;
            });
          } else if (await Permission.storage.request().isPermanentlyDenied) {
            permissionGranted = false;
          }
        }
      }
      if (Platform.isIOS) {
        if (await Permission.storage.request().isPermanentlyDenied) {
          setState(() {
            permissionGranted = false;
          });
        }
      }
      if (!permissionGranted) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text("Storage Permission required",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                      )),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Storage permission should be granted to save the menu pdf, would you like to go to app settings to give storage permissions?',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
                            onPressed: () async {
                              await openAppSettings();
                            },
                            child: const Text('Ok'))
                      ],
                    )
                  ]);
            });
      }
      var httpClient = HttpClient();
      var request = await httpClient.getUrl(Uri.parse(fileUrl));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      String localPath = "";
      if (Platform.isIOS) {
        var directory = await getApplicationDocumentsDirectory();
        localPath = '${directory.path}${Platform.pathSeparator}';
      }
      if (Platform.isAndroid) {
        path = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);
        localPath = path + Platform.pathSeparator;
      }

      final savedDir = Directory(localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }

      String fullPath = '$localPath${widget.searchItem.name.toLowerCase()}.pdf';
      await File(fullPath).writeAsBytes(bytes);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Opening pdf menu")));
      await OpenFilex.open(fullPath);
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("pdf downloading error")));
    }
  }
}
