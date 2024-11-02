import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Model/item.dart';
import 'package:cmenu/Components/SubTab/sub_build_tabs.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Single/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class SearchResultsListView extends StatefulWidget {
  final List<Product> products;
  final MenuCategory categoryName;

  const SearchResultsListView({
    super.key,
    required this.products,
    required this.categoryName,
  });

  @override
  State<SearchResultsListView> createState() => _SearchResultsListViewState();
}

var settings = SettingPreferences.getSetting();

class _SearchResultsListViewState extends State<SearchResultsListView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String currencyCode = "R";
    return Column(children: [
      if (widget.categoryName.categories.isNotEmpty)
        SubBuildTabs(categories: widget.categoryName.categories),
      for (var element in widget.products)
        Padding(
            padding: const EdgeInsets.only(
              bottom: 3,
            ),
            child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(15, 153, 153, 153),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                padding: const EdgeInsets.only(top: 5, bottom: 0),
                child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: GestureDetector(
                        onTap: () {
                          var catalog = context.read<CatalogModel>();
                          catalog.updateItems(widget.categoryName.products);
                          log(element.id, "product");
                          log(widget.categoryName.id, "category");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProductScreen(
                              categoryName: widget.categoryName.name,
                              product: element,
                            );
                          }));
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: element.images.isNotEmpty
                                                ? size.width * 0.7
                                                : size.width * 0.95,
                                            child: Text(
                                              element.name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  overflow: TextOverflow.fade),
                                            )),
                                        if (element.description.isNotEmpty)
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: SizedBox(
                                                  width:
                                                      element.images.isNotEmpty
                                                          ? size.width * 0.7
                                                          : size.width * 0.95,
                                                  child: Text(
                                                    element.description,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 14),
                                                  ))),
                                        Consumer<CartModel>(
                                          builder: (context, cart, child) => Text(
                                              "$currencyCode ${element.price}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ])),
                              if (element.images.isNotEmpty)
                                Common.displayImage(
                                    images: element.images,
                                    imageHeight: 80,
                                    imageWidth: 80,
                                    imageType: element.type,
                                    defaultImageFromUser: "dish")
                            ])))))
    ]);
  }

  log(String id, String section) async {
    try {
      TrackDataModel requestModel =
          TrackDataModel(id: id, section: section,token: dotenv.get('api_key'));
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
