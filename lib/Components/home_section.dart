import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/Components/Class/search_item.dart';
import 'package:cmenu/Components/Utils/common.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Single/gallery_screen.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class HomeSection extends StatefulWidget {
  HomeSection(
      {super.key,
      required this.searchItem,
      required this.size,
      this.showMoreInfo = false,
      this.showImage = true,
      this.showPromotions = true});

  final SearchItem searchItem;
  final Size size;
  bool showMoreInfo;
  bool showPromotions;
  bool showImage;
  var settings = SettingPreferences.getSetting();

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if(widget.showImage)
          Common.displayImage(
              images: widget.searchItem.images,
              displayMultiple: true,
              imageWidth: widget.size.width,
              imageHeight: widget.size.height * 0.4,
              imageType: 'place',
              noDefaultImage: true),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.searchItem.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          fontSize: 30,
                          fontFamily: 'Quicksand'),
                    ),
                    if (widget.searchItem.description.isNotEmpty)
                      Text(
                        widget.searchItem.description,
                        style: const TextStyle(),
                      ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.showMoreInfo =
                                      widget.showMoreInfo ? false : true;
                                });
                              },
                              child: Text(
                                widget.showMoreInfo
                                    ? "Hide more info"
                                    : "More info",
                                style: TextStyle(
                                    color: widget.showMoreInfo
                                        ? Colors.red
                                        : Colors.blue,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        )),
                    if (widget.showMoreInfo)
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.searchItem.address.isNotEmpty)
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        
                                        Row(
                                          children: [
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 2),
                                                child: Icon(
                                                    FontAwesomeIcons
                                                        .locationDot,
                                                    color: kPrimaryColor)),
                                            SizedBox(width:widget.size.width*0.6,child:Text(widget.searchItem.address,
                                                style: const TextStyle(
                                                    fontSize: 16,overflow: TextOverflow.ellipsis)))
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            "Get directions",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ])),
                            if (widget.searchItem.phone.isNotEmpty)
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 2),
                                              child: Icon(
                                                  FontAwesomeIcons.squarePhone,
                                                  color: kPrimaryColor)),
                                          Text(widget.searchItem.phone,
                                              style:
                                                  const TextStyle(fontSize: 16))
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          "Book now",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  )),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Opened on",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    for (var day in widget.searchItem.days)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Checkbox(
                                                  value: true,
                                                  onChanged: (bool? value) {},
                                                  activeColor: kPrimaryColor,
                                                ),
                                                Text(day.day),
                                              ]),
                                          Text(day.time)
                                        ],
                                      )
                                  ],
                                )),
                          ]),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.searchItem.ads.isNotEmpty)
                          Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Promotions",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    widget.showPromotions =
                                                        widget.showPromotions
                                                            ? false
                                                            : true;
                                                  });
                                                },
                                                child: Icon(
                                                  widget.showPromotions
                                                      ? FontAwesomeIcons
                                                          .eyeSlash
                                                      : FontAwesomeIcons.eye,
                                                  color: widget.showPromotions
                                                      ? Colors.red
                                                      : kPrimaryColor,
                                                ))
                                          ],
                                        )),
                                    if (widget.showPromotions)
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
                                                          searchItem:
                                                              widget.searchItem,
                                                          images: i.images);
                                                    }));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Common.displayImage(
                                                        images: i.images,
                                                        imageType: 'ad',
                                                        imageHeight:
                                                            widget.size.height *
                                                                0.20,
                                                        imageWidth:
                                                            widget.size.width *
                                                                0.30),
                                                  ))
                                          ],
                                        ),
                                      )
                                  ]))
                      ],
                    )
                  ]))
        ]);
  }

  log(String id, String section) async {
    try {
      String token = widget.settings.token.isNotEmpty
          ? widget.settings.token
          : '1234567890';
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
