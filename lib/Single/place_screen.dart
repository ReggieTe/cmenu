import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PlaceScreen extends StatefulWidget {
  final SearchItem searchItem;

  const PlaceScreen({super.key, required this.searchItem});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
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
        title: const Text(
          "Place",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              color: kPrimaryColor,
              fontFamily: 'Quicksand'),
        ),
      ),
      body:SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
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
                Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: Common.displayImage(
                                    images: widget.searchItem.images,
                                    displayMultiple: true,
                                    imageWidth: size.width * 0.8,
                                    imageHeight: size.height * 0.4,
                                    imageType: 'place')),
                                   Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(15, 153, 153, 153)),
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.searchItem.name,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis)),                                    
                                        const Icon(FontAwesomeIcons.user,color: kPrimaryColor,), 
                                    ],))),
                                Padding(padding:const EdgeInsets.only(top:3),
                                child: Container(
                                  width: size.width,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(15, 153, 153, 153),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(widget.searchItem.address,
                                          style: const TextStyle(
                                              fontSize: 16))))),
                                      if(widget.searchItem.phone.isNotEmpty)
                                Padding(padding:const EdgeInsets.only(top:3),
                                child: Container(
                                  width: size.width,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(15, 153, 153, 153),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child:Text(widget.searchItem.phone,
                                overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                              fontSize: 12))))),
                            if (widget.searchItem.description.isNotEmpty)
                              Padding(padding:const EdgeInsets.all(5),
                                child:Text(
                                widget.searchItem.description,
                                style: const TextStyle(fontSize: 14),
                              )),
                          ])),
                    ])
              ],
            ))      
    );
  }

}

