// import 'package:cmenu/Components/Class/category_item.dart';
// import 'package:cmenu/Components/Class/product.dart';
// import 'package:cmenu/Components/Model/cart.dart';
// import 'package:cmenu/Components/Model/item.dart';
// import 'package:cmenu/Components/Utils/setting_preferences.dart';
// import 'package:cmenu/Home/components/background.dart';
// import 'package:cmenu/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';

// class Body extends StatefulWidget {
//   final CategoryItem categoryItem;

//   const Body({super.key, required this.categoryItem});

//   @override
//   State<Body> createState() => _BodyState();
// }

// class _BodyState extends State<Body> {
//   double totalBudget = 0.0;
//   BannerAd? _bannerAd;
//  var settings =  SettingPreferences.getSetting();

//   @override
//   void initState() {
//     setState(() {
//       totalBudget = settings.budget;
//     });
//     super.initState();
//     BannerAd(
//       adUnitId: bannerAndroid,
//       request: AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _bannerAd = ad as BannerAd;
//           });
//         },
//         onAdFailedToLoad: (ad, err) {
//           print('Failed to load a banner ad: ${err.message}');
//           ad.dispose();
//         },
//       ),
//     ).load();
//   }

//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }

// // class _ActionButton extends StatelessWidget {
// //   final Product item;
// //   final bool delete;

// //   const _ActionButton({required this.item, required this.delete});

// //   @override
// //   Widget build(BuildContext context) {
// //     var isInCart = context.select<CartModel, bool>(
// //       // Here, we are only interested whether [item] is inside the cart.
// //       (cart) => cart.items.contains(item),
// //     );
// //     return GestureDetector(
// //       child: delete
// //           ? Icon(
// //               Icons.remove_circle_outline,
// //               color: Colors.red,
// //             )
// //           : Icon(
// //               Icons.add_circle_outline_rounded,
// //               color: Colors.green,
// //             ),
// //       onTap: () {
// //         var cart = context.read<CartModel>();
// //         String message = 'Item added to cart';
// //         if (delete) {
// //           if (isInCart) {
// //             var cart = context.read<CartModel>();
// //             cart.remove(item);
// //             message = 'Item removed from cart';
// //           }
// //         } else {
// //           cart.add(item);
// //         }

// //         ScaffoldMessenger.of(context)
// //             .showSnackBar(SnackBar(content: Text(message.toString())));
// //       },
// //     );
// //   }
// // }
