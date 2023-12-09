import 'package:cmenu/Components/information_center_content.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: Column(
      children: [
       Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child:   Container(
                    margin: const EdgeInsets.only(bottom:1),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(15, 153, 153, 153),
                            borderRadius: BorderRadius.circular(5),
  ),
  child: ListTile(
            title: const Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
                size: 16,
              color: kPrimaryColor,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const InformationCenterContentScreen(
                    screenPageTitle: 'Terms & Conditions', type: 'terms');
              }));
            },
          ),
        )),
        Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child:  Container(
  margin: const EdgeInsets.only(bottom:1),
  decoration: BoxDecoration(
    color: const Color.fromARGB(15, 153, 153, 153),
                            borderRadius: BorderRadius.circular(5),
  ),
  child: ListTile(
            title: const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
                size: 16,
              color: kPrimaryColor,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const InformationCenterContentScreen(
                    screenPageTitle: 'Privacy Policy', type: 'privacy');
              }));
            },
          ),
        )),
        Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child:  Container(
  margin: const EdgeInsets.only(bottom:1),
  decoration: BoxDecoration(
    color: const Color.fromARGB(15, 153, 153, 153),
                            borderRadius: BorderRadius.circular(5),
  ),
  child: ListTile(
            title: const Text(
              'Disclaimer',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
                size: 16,
              color: kPrimaryColor,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const InformationCenterContentScreen(
                    screenPageTitle: 'Disclaimer', type: 'disclaimer');
              }));
            },
          ),
        )),
       Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child:   Container(
  margin: const EdgeInsets.only(bottom:1),
  decoration: BoxDecoration(
    color: const Color.fromARGB(15, 153, 153, 153),
                            borderRadius: BorderRadius.circular(5),
  ),
  child: ListTile(
            title: const Text(
              'FAQs',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
                size: 16,
              color: kPrimaryColor,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const InformationCenterContentScreen(
                    screenPageTitle: 'FAQs', type: 'faqs');
              }));
            },
          ),
        )),
       Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child:   Container(
  margin: const EdgeInsets.only(bottom:1),
  decoration: BoxDecoration(
    color: const Color.fromARGB(15, 153, 153, 153),
                            borderRadius: BorderRadius.circular(5),
  ),
  child: ListTile(
            title: const Text(
              'About cMenu',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
                size: 16,
              color: kPrimaryColor,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const InformationCenterContentScreen(
                    screenPageTitle: 'About cMenu', type: 'about');
              }));
            },
          ),
        )),
      ],
    ));
  }
}
