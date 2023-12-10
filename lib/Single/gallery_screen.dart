// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Components/progress_loader.dart';
import 'package:cmenu/Components/Class/image.dart' as local_image;
import 'package:cmenu/Home/welcome_screen.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GalleryScreen extends StatefulWidget {
  final SearchItem searchItem;
  final List<local_image.Image> images;
  const GalleryScreen(
      {super.key, required this.searchItem, required this.images});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  BannerAd? _bannerAd;
  double totalBudget = 0.0;
  var settings = SettingPreferences.getSetting();
  final focusNode = FocusNode();
  String query = '';
  bool inProgress = false;
  bool showSearchBar = false;
  List<MenuCategory> categories = [];

  String path = '';
  bool downloading = false;
  String downloadingStr = "No data";
  double download = 0;
  List<local_image.Image> imageToDisplay = [];
  List<local_image.Image> images = [];
  bool showPromotions = true;

  @override
  void initState() {
    images = widget.images;
    var image = images.first;
    setState(() {
      imageToDisplay.add(image);
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
  Widget build(BuildContext context) => ProgressLoader(
        inAsyncCall: inProgress,
        opacity: 0.3,
        child: _uiSetup(context),
      );

  Widget _uiSetup(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomeScreen(searchItem: widget.searchItem);
              }));
            },
            child: Text(
              widget.searchItem.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontFamily: 'Quicksand',
                  overflow: TextOverflow.ellipsis),
            )),
      ),
      body: SingleChildScrollView(
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
              Column(children: [
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Common.displayImage(
                        images: imageToDisplay,
                        imageType: 'ad',
                        imageHeight: size.height * 0.6,
                        imageWidth: size.width))
              ]),
              if(images.length>1)
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i in images)
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  imageToDisplay.clear();
                                  imageToDisplay.add(i);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Common.displayImage(
                                    images: [i],
                                    imageType: 'ad',
                                    imageHeight: size.height * 0.10,
                                    imageWidth: size.width * 0.15),
                              ))
                      ],
                    ))
              ])
            ]),
      ),
      bottomNavigationBar:
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i in widget.searchItem.ads)
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            images = i.images;
                            imageToDisplay.clear();
                            imageToDisplay.add(i.images.first);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Common.displayImage(
                              images: i.images,
                              imageType: 'ad',
                              imageHeight: size.height * 0.10,
                              imageWidth: size.width * 0.15),
                        ))
                ],
              )),
    );
  }
}
