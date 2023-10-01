import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  double totalBudget = 0.0;
  var settings = SettingPreferences.getSetting();

  @override
  void initState() {
    setState(() {
      totalBudget = settings.budget;
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer<CartModel>(
          builder: (context, cart, child) => Text("Cart (${cart.items.length})",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  color: kPrimaryColor)),
        ),
         backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                var cart = context.read<CartModel>();
                cart.removeAll();
              },
              icon: Image.asset(
                "assets/images/bin.png",
                height: 20,
                width: 20,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _CartList(),
          ),
          const Divider(height: 4, color: Colors.grey),
          SizedBox(
     height: 100,
      child:Padding(padding: EdgeInsets.all(5),child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Remaining"),
                 GestureDetector(onTap:(){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Set Budget",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 20,
                              )),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter amount',
                                  ),
                                  onChanged: (value) {
                                    var setting = settings.copy(
                                        budget: double.parse(value));
                                    SettingPreferences.setSetting(setting);
                                    setState(() {
                                      totalBudget = double.parse(value);
                                    });
                                  },
                                ),
                              ),
                              Text(
                                'This is the total amount you want to spend',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Cancel')),
                                TextButton(
                                    onPressed: () {
                                      setState(() {});
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Save'))
                              ],
                            )
                          ],
                        );
                      },
                    );
                 
                 },child:Consumer<CartModel>(
                                        builder: (context, cart, child) => Text(
                                            "$currencyCode ${cart.remainingBudget(totalBudget, cart.totalPrice)}",
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor)),
                                      ))
                ],),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Spent'),
Consumer<CartModel>(
                builder: (context, cart, child) =>
                    Text('$currencyCode ${cart.totalPrice}',style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: kPrimaryColor))),
                  ],
                )
              ],
            ),

         
          ],
        ),
      )),
    )
        ],
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    var cart = context.watch<CartModel>();

    return ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 244, 244, 244),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: ListTile(
                leading: Image.asset(
                  "assets/images/correct.png",
                  height: 50,
                  width: 50,
                ),
                trailing: IconButton(
                  icon: Image.asset(
                    "assets/images/bin.png",
                    height: 20,
                    width: 20,
                  ),
                  onPressed: () {
                    cart.remove(cart.items[index]);
                  },
                ),
                title: Text(
                  cart.items[index].name,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "$currencyCode ${cart.items[index].price}",
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
            )));
  }
}


