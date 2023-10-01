import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/image.dart';
import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Class/tag.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Model/history.dart';
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
  final focusNode = FocusNode();
  bool showSearchBar = false;
  String query = '';
  List<SearchItem> searchItems = [];
  List<Tag> tags = [];
  bool inProgress = false;

  @override
  void initState() {
    getTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ProgressLoader(
        child: _uiSetup(context),
        inAsyncCall: inProgress,
        opacity: 0.3,
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
            style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor,fontFamily: 'Quicksand'),
          ),
          actions: [
            IconButton(
              icon: showSearchBar ? Icon(Icons.cancel,color: Colors.red,): Icon(Icons.search,color: kPrimaryColor),
              onPressed: () {
                if (showSearchBar) {
                  setState(() {
                    showSearchBar = false;
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
                                        tag.name,
                                        style: const TextStyle(
                                            color: kPrimaryColor),
                                      ))))),
                  ],
                )),
            if (showSearchBar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar(
                  controller: _textEditingController,                  
                  shape:
                      MaterialStateProperty.all(const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )),
                  shadowColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all( Colors.white

                  ),
                  hintText: 'Type keyword',
                  hintStyle: MaterialStateProperty.all(
                      const TextStyle(color: Colors.grey)),

                  textStyle: MaterialStateProperty.all(const TextStyle(
                      color: Colors.teal)),

                  onChanged: (String value) {
                    setState(() {
                      query = value;
                    });
                  },
                  
                  onTap: () {
                  },
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        await _search();
                      },
                    ),
                  ],
                ),
              ),
            if (searchItems.isNotEmpty)
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    var history = context.read<HistoryModel>();
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
               Container(
                        decoration: BoxDecoration(
                        border: Border(
                                bottom: BorderSide(width: 0.3, color: kPrimaryColor),
                              )
                      ),
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child:  ListTile(
                  leading:Image.asset(
                                "assets/images/menu.png",
                                height: 50,
                              ),
                  title: Text(item.name,style: TextStyle(overflow: TextOverflow.ellipsis),),
                  subtitle: Text(item.address,style: TextStyle(overflow: TextOverflow.ellipsis),),
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
                    history.add(item);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeScreen(searchItem: item);
                    }));
                  },
                )),
                if (searchItems.isEmpty)
                Container(
                  height: size.height*0.6,
                  child: Center(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                              Image.asset(
                                "assets/images/restaurant.png",
                                height: 300,
                              ),
                              SizedBox(height: 10,),
                              Text("cMenu is a Menu App ",style: TextStyle(fontSize:25,fontWeight: FontWeight.bold,color: kPrimaryColor,fontFamily:'Quicksand'),),
                              SizedBox(height: 10,),
                              Text("For different eateries in & around Cape Town",style: TextStyle(fontSize: 16,fontFamily:'Quicksand',color: kPrimaryColor),),
                              SizedBox(height: 20,),
                             
                    ],) ,
                  ),
                ),
                if (searchItems.isEmpty)
                   if (!showSearchBar)
                Padding(padding: EdgeInsets.all(50),child: 
                              ElevatedButton(onPressed: (){
                                setState(() {
                                  showSearchBar = true;
                                });
                              }, child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Text("Get started"),
                              Icon(Icons.search,color: kPrimaryColor,),
                              ],)))
          ])),
        )));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  getTags() async {
    List<Tag> tagList = [];
    RequestDataModel requestModel = RequestDataModel(keyword: '', id: '');
    APIServiceList apiService = APIServiceList();
    setState(() {
      inProgress = true;
    });
    await apiService.getTags(requestModel).then((value) async {
      setState(() {
        inProgress = false;
      });
      if (value.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error getting tags')));
      }
      if (!value.error) {
        for (var tag in value.data['data']['results']) {
          tagList.add(Tag(tag['id'], tag['name']));
        }
      }
    });
    setState(() {
      tags = tagList;
    });
  }

  _search({String id = ''}) async {
    setState(() {
      inProgress = true;
    });
    List<SearchItem> searchItemss = [];
    RequestDataModel requestModel = RequestDataModel(keyword: query, id: id);
    APIServiceList apiService = APIServiceList();

    await (id.isNotEmpty
            ? apiService.searchByTag(requestModel)
            : apiService.search(requestModel))
        .then((value) async {
      setState(() {
        inProgress = false;
      });
      if (value.error) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error getting search results')));
      }
      if (!value.error) {
        for (var place in value.data['data']['results']) {
          List<MenuCategory> categories = [];
          for (var category in place['category']) {
            List<Product> products = [];
            for (var product in category['products']) {
              products.add(Product(
                  product['id'],
                  product['name'],
                  sortString(product['price']),
                  sortString(product['description']),
                  sortString(product['discount']),
                  processImages(product['image'])));
            }
            categories.add(MenuCategory(
                sortString(category['name']),
                sortString(category['description']),
                products,
                processImages(category['image'])));
          }
          searchItemss.add(SearchItem(place['id'], place['name'],
              place['address'], categories, processImages(place['image'])));
        }
      }
    });
    //}
    setState(() {
      searchItems = searchItemss;
    });
  }

  List<image> processImages(var images) {
    List<image> productImages = [];
    for (var element in images) {
      if (element.containsKey('file')) {
        productImages.add(image(element['file'].toString(),element['id'].toString()));
      }
    }
    return productImages;
  }

  String sortString(var item) {
    return item == "" || item == "Null" || item == "null" || item == null
        ? ""
        : item.toString();
  }
}
