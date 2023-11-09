import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/image.dart' as local_image;
import 'package:cmenu/Components/Class/menu_category.dart';
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
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
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
  List<Tag> tags = [];
  bool inProgress = false;
  String searchName = "Search results";
  String searchCount = "0";
  bool showSearchResults = false;
  String searchErrorMessage = '';

  @override
  void initState() {
    getTags();
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
              automaticallyImplyLeading: false,
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
                    if (showSearchBar) {
                      setState(() {
                        showSearchBar = false;
                        showSearchResults = false;
                        var history = context.read<HistoryModel>();
                        searchItems = history.items;
                      });
                    } else {
                      setState(() {
                        showSearchBar = true;
                      });
                    }
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
                                log(tag.id, 'tag');
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
                                          left: 10,
                                          right: 10,
                                          top: 3,
                                          bottom: 3),
                                      child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            '${tag.name} (${tag.count})',
                                            style: const TextStyle(
                                                color: kPrimaryColor),
                                          ))))),
                      ],
                    )),
                if (showSearchBar)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                          controller: _textEditingController,
                          onSubmitted: (value) async {
                            setState(() {
                              searchErrorMessage = '';
                            });
                            await _search();
                          },
                          onChanged: (String value) {
                            setState(() {
                              query = value;
                            });
                          },style: const TextStyle(color:  Colors.teal),                          
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
                            suffixIcon: GestureDetector(child:const Icon(Icons.search) , onTap:() async {
                              await _search();
                            } ,),
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
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                      GestureDetector(
                                        child: const Text("Clear all",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.bold)),
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
                              leading: Common.displayImage(
                                  images: item.images,
                                  imageType: 'place',
                                  imageHeight: 60,
                                  imageWidth: 60),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              subtitle: Text(
                                item.address,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              trailing: GestureDetector(
                                child: Image.asset(
                                  "assets/images/bin.png",
                                  height: 25,
                                ),
                                onTap: () {
                                  var history = context.read<HistoryModel>();
                                  history.delete(item);
                                  setState(() {
                                    searchItems.remove(item);
                                  });
                                },
                              ),
                              onTap: () {
                                var cart = context.read<CartModel>();
                                cart.removeAll();
                                var history = context.read<HistoryModel>();
                                if (!history.items.contains(item)) {
                                  history.add(item);
                                  log(item.id, 'place');
                                }
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomeScreen(searchItem: item);
                                }));
                              },
                            ))),
                if (searchItems.isEmpty)
                  SizedBox(
                    height: size.height * 0.8,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (!showSearchBar)
                            SizedBox(height: size.height * 0.1),
                          Image.asset(
                            "assets/images/restaurant.png",
                            height: 300,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "cMenu is a Menu App ",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontFamily: 'Quicksand'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "For different eateries in & around Cape Town",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Quicksand',
                                color: kPrimaryColor),
                          ),
                          if (searchItems.isEmpty)
                            if (!showSearchBar)
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(50),
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        showSearchBar = true;
                                                      });
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("Get started"),
                                                        Icon(
                                                          Icons.search,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ],
                                                    )))
                                          ])))
                        ],
                      ),
                    ),
                  ),
              ])),
            )));
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

  getTags() async {
    try {
      List<Tag> tagList = [];
      String token = settings.token.isNotEmpty ? settings.token : '1234567890';
      RequestDataModel requestModel =
          RequestDataModel(keyword: '', id: '', token: token);
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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error encounter processing tag data")));
    }
  }

  getSettings() async {
    try {
      String token = settings.token.isNotEmpty ? settings.token : '1234567890';
      RequestDataModel requestModel =
          RequestDataModel(keyword: '', id: '', token: token);
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error encounter processing setting data")));
    }
  }

  _search({String id = ''}) async {
    try {
      setState(() {
        inProgress = true;
      });
      List<SearchItem> searchItemss = [];
      String token = settings.token.isNotEmpty ? settings.token : '1234567890';
      RequestDataModel requestModel =
          RequestDataModel(keyword: query, id: id, token: token);
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
                sortString(place['phone'])));
          }
        }
      });
      //}
      setState(() {
        searchItems = searchItemss;
        searchCount = searchItems.length.toString();
        showSearchResults = true;
        if(searchItems.isEmpty){
          searchErrorMessage = 'O places found .Please try again';
        }
      });
    } catch (error) {
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
