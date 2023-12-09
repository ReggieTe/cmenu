import 'package:cmenu/Components/Api/api.service.data.dart';
import 'package:cmenu/Components/Class/key_and_value.dart';
import 'package:cmenu/Components/progress_loader.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';

class InformationCenterContentScreen extends StatefulWidget {
  final String screenPageTitle;
  final String type;
  const InformationCenterContentScreen({
    super.key,
    this.screenPageTitle = "Disclaimer",
    this.type = "disclaimer",
  });

  @override
  // ignore: library_private_types_in_public_api
  _InformationCenterContentScreenState createState() =>
      _InformationCenterContentScreenState();
}

class _InformationCenterContentScreenState
    extends State<InformationCenterContentScreen> {
  bool isApiCallProcess = false;
  APIServiceData apiService = APIServiceData();
  List<KeyAndValue> pageData = [];
  bool adVisibility = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressLoader(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: _uiSetup(context),
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
             
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: const Icon(Icons.arrow_back,
                color:kPrimaryColor)),
              centerTitle: true,
              elevation: 0,
              title: Text(
                widget.screenPageTitle,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    fontFamily: 'Quicksand'),
              )
            ),
        body:SingleChildScrollView(
            child: Column(
              
          children: [
            for (var item in pageData)
            Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                color: const Color.fromARGB(15, 153, 153, 153),
                            borderRadius: BorderRadius.circular(5),
              ),
              child: ExpansionTile(
                title: Text(
                  item.id,
                  style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: kPrimaryColor),
                  textAlign: TextAlign.left,
                ),
                children: <Widget>[
                 Padding(padding: const EdgeInsets.all(10),child: Text(item.name.trim(),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500))),
                ],
              ),
            )),
          ],
        )));
  }

  Future<void> getData() async {
    List<KeyAndValue> pageContent = [];
    setState(() {
      isApiCallProcess = true;
    });
    await apiService.fetchInformationContentData(widget.type).then((value) {
      setState(() {
        isApiCallProcess = false;
      });
      if (!value.error) {
        for (var item in value.data['info']) {
          pageContent.add(KeyAndValue(
              id: item["title"].toString(), name: item["body"].toString()));
        }
        setState(() {
          pageData = pageContent;
        });
      }
    });
  }

}
