
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Model/history.dart';
import 'package:cmenu/Components/Model/item.dart';
import 'package:cmenu/Components/Utils/first_time_preferences.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await SettingPreferences.init();
  await FirstTimePreferences.init();  
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<HistoryModel>(
            create: (context) => HistoryModel(),
          ),
          ChangeNotifierProvider<CatalogModel>(
            create: (context) => CatalogModel(),
          ),
          ChangeNotifierProxyProvider<CatalogModel, CartModel>(
            create: (context) => CartModel(),
            update: (context, catalog, cart) {
              catalog.itemNames = catalog.itemNames;
              if (cart == null) throw ArgumentError.notNull('cart');
              cart.catalog = catalog;
              return cart;      
            },
          ),
        ],
        child: MaterialApp(
          title: 'cMenu',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // fontFamily: 'Quicksand',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ));
  }
}
