import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/ad.dart';
import 'package:cmenu/Components/Class/image.dart' as local_image;
import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/open_time.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Class/tag.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Model/history.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Components/progress_loader.dart';
import 'package:cmenu/Home/welcome_screen.dart';
import 'package:cmenu/InformationCenter/information_center.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController _searchController = SearchController();
  final TextEditingController _textEditingController = TextEditingController();
  var settings = SettingPreferences.getSetting();
  final focusNode = FocusNode();
  bool showSearchBar = false;
  String query = '';
  List<SearchItem> searchItems = [];
  List<SearchItem> historyItems = [];
  List<SearchItem> trendingItems = [];

  List<Tag> tags = [];
  bool inProgress = false;
  String searchName = "Search results";
  String searchCount = "0";
  bool showSearchResults = false;
  bool showTrendingItems = true;
  String searchErrorMessage = '';

  @override
  void initState() {
    getTags();
    getTrendingPlaces();
    getSettings();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProgressLoader(
        inAsyncCall: inProgress,
        opacity: 0.3,
        child: _uiSetup(context),
      );

  Widget _uiSetup(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const InformationCenterScreen();
                  }));
                },
                child: const Icon(Icons.list_rounded, color: kPrimaryColor)),
            centerTitle: true,
            elevation: 0,
            title: const Text(
              " cMenu",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontFamily: 'Quicksand'),
            ),
            actions: [
              IconButton(
                icon: showSearchBar
                    ? const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )
                    : const Icon(Icons.search, color: kPrimaryColor),
                onPressed: () {
                  setState(() {
                    if (showSearchBar) {
                      showSearchBar = false;
                      showSearchResults = false;
                      showTrendingItems = true;
                      var history = context.read<HistoryModel>();
                      searchItems = history.items;
                    } else {
                      showSearchBar = true;
                      showTrendingItems = false;
                    }
                  });
                },
              ),
            ],
          ),
          body: SizedBox(
            height: size.height,
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var tag in tags)
                        GestureDetector(
                            onTap: () async {
                              setState(() {
                                inProgress = true;
                              });
                              await _search(id: tag.id);
                              Common.log(tag.id, 'tag');
                              setState(() {
                                inProgress = false;
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: kPrimaryLightColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 3, bottom: 3),
                                    child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          '${tag.name} (${tag.count})',
                                          style: const TextStyle(
                                              color: kPrimaryColor),
                                        ))))),
                    ],
                  )),
              if (showTrendingItems)
                if (trendingItems.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: Column(children: [
                        const Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Trending Places",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: kPrimaryColor,
                                        fontSize: 16)),

                                // GestureDetector(
                                //   child:const Text(
                                //   "More",
                                //   style: TextStyle(
                                //       color: Colors.blue,
                                //       fontSize: 14,)) ,
                                //       onTap:(){
                                //       log("", 'discover');
                                //     Navigator.push(context,
                                //         MaterialPageRoute(
                                //             builder: (context) {
                                //       return DiscoverScreen(trendingItems: trendingItems);
                                //     }));

                                //       }
                                // )
                              ],
                            )),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var i in trendingItems)
                                GestureDetector(
                                    onTap: () {
                                      var cart = context.read<CartModel>();
                                      cart.removeAll();
                                      var history =
                                          context.read<HistoryModel>();
                                      if (!history.items.contains(i)) {
                                        history.add(i);
                                        Common.log(i.id, 'place');
                                      }
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return HomeScreen(searchItem: i);
                                      }));
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                            width: size.width * 0.30,
                                            height: size.height * 0.25,
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    15, 153, 153, 153),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Common.displayImage(
                                                    images: i.images,
                                                    imageType: 'place',
                                                    imageHeight:
                                                        size.height * 0.20,
                                                    imageWidth:
                                                        size.width * 0.30),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, top: 10),
                                                  child: Text(i.name,
                                                      style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kPrimaryColor,
                                                          fontFamily:
                                                              'Quicksand'),
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                )
                                              ],
                                            ))))
                            ],
                          ),
                        )
                      ])),
              if (showSearchBar)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                        controller: _textEditingController,
                        onSubmitted: (value) async {
                          setState(() {
                            searchErrorMessage = '';
                          });
                          if (query.isNotEmpty) {
                            if (Common.isValidName(value)) {
                              await _search();
                            } else {
                              setState(() {
                                searchErrorMessage =
                                    "Special characters (,./?><!@#%^&*() not allowed.Try again";
                              });
                            }
                          } else {
                            setState(() {
                              searchErrorMessage =
                                  "Place name empty , must sure you type something.Try again";
                            });
                          }
                        },
                        onChanged: (String value) {
                          setState(() {
                            searchErrorMessage = '';
                            query = value;
                          });
                        },
                        style: const TextStyle(color: Colors.teal),
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Colors.teal,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Search for place",
                          hintMaxLines: 1,
                          errorText: searchErrorMessage.isNotEmpty
                              ? searchErrorMessage
                              : null,
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: GestureDetector(
                            child: const Icon(Icons.search),
                            onTap: () async {
                              setState(() {
                                searchErrorMessage = '';
                              });
                              if (query.isNotEmpty) {
                                if (Common.isValidName(query)) {
                                  await _search();
                                } else {
                                  setState(() {
                                    searchErrorMessage =
                                        "Special characters (,./?><!@#%^&*() not allowed.Try again";
                                  });
                                }
                              } else {
                                setState(() {
                                  searchErrorMessage =
                                      "Place name empty , must sure you type something.Try again";
                                });
                              }
                            },
                          ),
                          prefixIcon: query.isNotEmpty
                              ? GestureDetector(
                                  child: const Icon(Icons.cancel),
                                  onTap: () async {
                                    setState(() {
                                      query = '';
                                      _textEditingController.clear();
                                    });
                                  },
                                )
                              : null,
                          prefixIconColor: kPrimaryColor,
                        ))),
              if (showSearchResults)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        searchName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: kPrimaryColor,
                            fontSize: 16),
                      ),
                      Container(
                          decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                searchCount,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )))
                    ],
                  ),
                ),
              if (searchItems.isNotEmpty)
                if (!showSearchResults)
                  if (!showSearchBar)
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("History",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: kPrimaryColor,
                                            fontSize: 16)),
                                    GestureDetector(
                                      child: const Text("Clear all",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: kPrimaryColor)),
                                      onTap: () {
                                        setState(() {
                                          inProgress = true;
                                        });
                                        var history =
                                            context.read<HistoryModel>();
                                        if (history.items.isNotEmpty) {
                                          history.deleteItems();
                                        }
                                        setState(() {
                                          searchItems.clear();
                                          inProgress = false;
                                        });
                                      },
                                    )
                                  ],
                                )))),
              if (searchItems.isNotEmpty)
                for (var item in searchItems)
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
                            leading: item.images.isNotEmpty
                                ? Common.displayImage(
                                    images: item.images,
                                    imageType: 'place',
                                    imageHeight: 60,
                                    imageWidth: 60)
                                : null,
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              item.address,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                            trailing: !showSearchResults && !showSearchBar
                                ? GestureDetector(
                                    child: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      var history =
                                          context.read<HistoryModel>();
                                      history.delete(item);
                                      setState(() {
                                        searchItems.remove(item);
                                      });
                                    },
                                  )
                                : null,
                            onTap: () {
                              var cart = context.read<CartModel>();
                              cart.removeAll();
                              var history = context.read<HistoryModel>();
                              if (!history.items.contains(item)) {
                                history.add(item);
                                Common.log(item.id, 'place');
                              }
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return HomeScreen(searchItem: item);
                              }));
                            },
                          ))),
              if (searchItems.isEmpty)
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Container(
                        width: size.width * 0.98,
                        decoration: const BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Menu App",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                    fontFamily: 'Quicksand'),
                              ),
                              Text(
                                "Menu app for restaurants,clubs and coffee shops in and around Cape Town",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Image.asset(
                        "assets/images/table-mountain.png",
                        height: size.width * 0.9,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Container(
                          width: size.width * 0.98,
                          decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Can't find your favorite place ?",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Quicksand'),
                                  ),
                                  Text(
                                    "Let us know on our social handles so that we include it on the list of awesome places in Cape Town ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ))),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ],
                  ),
                ),
            ])),
          ),
          bottomNavigationBar: (searchItems.isEmpty) && (!showSearchBar)
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showSearchBar = true;
                          showTrendingItems = false;
                        });
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Get started",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: kPrimaryColor,
                                    fontFamily: 'Quicksand'),
                              ),
                              Icon(
                                Icons.search,
                                color: kPrimaryColor,
                              ),
                            ],
                          ))))
              : null,
        ));
  }

  getTags() async {
    try {
      List<Tag> tagList = [];

      RequestDataModel requestModel =
          RequestDataModel(keyword: '', id: '', token: dotenv.get('API_KEY'));
      APIServiceList apiService = APIServiceList();
      setState(() {
        inProgress = true;
      });
      await apiService.getTags(requestModel).then((value) async {
        setState(() {
          inProgress = false;
        });
        if (value.error) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error getting tags')));
        }
        if (!value.error) {
          for (var tag in value.data['data']['results']) {
            tagList.add(Tag(tag['id'], tag['name'], tag['count']));
          }
        }
      });
      setState(() {
        tags = tagList;
      });
    } catch (error) {
      //print(error);
      setState(() {
        inProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error encounter processing tag data")));
    }
  }

  getSettings() async {
    try {
      RequestDataModel requestModel =
          RequestDataModel(keyword: '', id: '',token: dotenv.get('api_key'));
      APIServiceList apiService = APIServiceList();
      setState(() {
        inProgress = true;
      });
      await apiService.appSettings(requestModel).then((value) async {
        setState(() {
          inProgress = false;
        });
        if (value.error) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error getting tags')));
        }
        if (!value.error) {
          // appVersion
          if (value.data['data']['settings']['version'] != appVersion) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("New Version Available",
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                      )),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "Download the latest version of cMenu on the store to enjoy the latest features and also bug fixes",
                          style: TextStyle(
                            fontSize: 14,
                          ))
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'))
                  ],
                );
              },
            );
          }
        }
      });
    } catch (error) {
      //print(error);
      setState(() {
        inProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error encounter processing setting data")));
    }
  }

  getTrendingPlaces({String id = ''}) async {
    try {
      setState(() {
        inProgress = true;
      });
      List<SearchItem> trendingPlaces = [];

      RequestDataModel requestModel =
          RequestDataModel(keyword: query, id: id,token: dotenv.get('api_key'));
      APIServiceList apiService = APIServiceList();

      await apiService.getTrendingPlaces(requestModel).then((value) async {
        setState(() {
          inProgress = false;
        });
        if (value.error) {
          setState(() {
            searchErrorMessage = 'Error getting search results';
          });

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error getting search results')));
        }
        if (!value.error) {
          for (var place in value.data['data']['results']) {
            List<MenuCategory> categories = [];
            for (var category in place['category']) {
              if (!category['isSubCategory']) {
                List<Product> products = [];
                List<MenuCategory> subCategories = [];
                for (var product in category['products']) {
                  products.add(Product(
                      product['id'],
                      product['name'],
                      sortString(product['price']),
                      sortString(product['description']),
                      sortString(product['discount']),
                      processImages(product['image']),
                      type: sortString(product['type'])));
                }
                //SORT SUB-CARTEGORIES
                if (sortArray(category['categories'])) {
                  for (var subCategory in category['categories']) {
                    List<Product> subCategoryProducts = [];
                    for (var product in subCategory['products']) {
                      subCategoryProducts.add(Product(
                          product['id'],
                          product['name'],
                          sortString(product['price']),
                          sortString(product['description']),
                          sortString(product['discount']),
                          processImages(product['image']),
                          type: sortString(product['type'])));
                    }

                    subCategories.add(MenuCategory(
                        sortString(category['id']),
                        sortString(subCategory['name']),
                        sortString(subCategory['description']),
                        subCategoryProducts,
                        processImages(subCategory['image']), []));
                  }
                }
                categories.add(MenuCategory(
                    sortString(category['id']),
                    sortString(category['name']),
                    sortString(category['description']),
                    products,
                    processImages(category['image']),
                    subCategories));
              }
            }
            trendingPlaces.add(SearchItem(
              place['id'],
              place['name'],
              place['address'],
              categories,
              processImages(place['image']),
              sortString(place['description']),
              sortString(place['phone']),
              processAds(place['ads']),
              processDays([]),
            ));
          }
        }
      });
      //}
      setState(() {
        trendingItems = trendingPlaces;
      });
    } catch (error) {
      setState(() {
        inProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error encounter processing trending place data")));
    }
  }

  _search({String id = ''}) async {
    try {
      setState(() {
        inProgress = true;
      });
      List<SearchItem> searchItemss = [];

      RequestDataModel requestModel =
          RequestDataModel(keyword: query, id: id,token: dotenv.get('api_key'));
      APIServiceList apiService = APIServiceList();

      await (id.isNotEmpty
              ? apiService.searchByTag(requestModel)
              : apiService.search(requestModel))
          .then((value) async {
        setState(() {
          inProgress = false;
        });
        if (value.error) {
          setState(() {
            searchErrorMessage = 'Error getting search results';
          });

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error getting search results')));
        }
        if (!value.error) {
          for (var place in value.data['data']['results']) {
            List<MenuCategory> categories = [];
            for (var category in place['category']) {
              if (!category['isSubCategory']) {
                List<Product> products = [];
                List<MenuCategory> subCategories = [];
                for (var product in category['products']) {
                  products.add(Product(
                      product['id'],
                      product['name'],
                      sortString(product['price']),
                      sortString(product['description']),
                      sortString(product['discount']),
                      processImages(product['image']),
                      type: sortString(product['type'])));
                }
                //SORT SUB-CARTEGORIES
                if (sortArray(category['categories'])) {
                  for (var subCategory in category['categories']) {
                    List<Product> subCategoryProducts = [];
                    for (var product in subCategory['products']) {
                      subCategoryProducts.add(Product(
                          product['id'],
                          product['name'],
                          sortString(product['price']),
                          sortString(product['description']),
                          sortString(product['discount']),
                          processImages(product['image']),
                          type: sortString(product['type'])));
                    }

                    subCategories.add(MenuCategory(
                        sortString(category['id']),
                        sortString(subCategory['name']),
                        sortString(subCategory['description']),
                        subCategoryProducts,
                        processImages(subCategory['image']), []));
                  }
                }
                categories.add(MenuCategory(
                    sortString(category['id']),
                    sortString(category['name']),
                    sortString(category['description']),
                    products,
                    processImages(category['image']),
                    subCategories));
              }
            }
            searchItemss.add(SearchItem(
              place['id'],
              place['name'],
              place['address'],
              categories,
              processImages(place['image']),
              sortString(place['description']),
              sortString(place['phone']),
              processAds(place['ads']),
              processDays([]),
            ));
          }
        }
      });
      //}
      setState(() {
        searchItems = searchItemss;
        searchCount = searchItems.length.toString();
        showSearchResults = true;
        if (searchItems.isEmpty) {
          searchErrorMessage = 'O places found .Please try again';
        }
      });
    } catch (error) {
      setState(() {
        inProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error encounter processing search data")));
    }
  }

  List<local_image.Image> processImages(var images) {
    List<local_image.Image> productImages = [];
    for (var element in images) {
      if (element.containsKey('file')) {
        productImages.add(local_image.Image(
            element['file'].toString(), element['id'].toString()));
      }
    }
    return productImages;
  }

  List<OpenTime> processDays(var daysList) {
    List<OpenTime> days = [];
    for (var element in daysList) {
      days.add(OpenTime(element['day'].toString(), element['time'].toString()));
    }
    return days;
  }

  List<Ad> processAds(var adList) {
    List<Ad> ads = [];
    for (var element in adList) {
      ads.add(Ad(element['id'].toString(), processImages(element['images'])));
    }

    return ads;
  }

  String sortString(var item) {
    return item == "" || item == "Null" || item == "null" || item == null
        ? ""
        : item.toString();
  }

  bool sortArray(var item) {
    return item == "" || item == "Null" || item == "null" || item == null
        ? false
        : true;
  }
}
