import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Model/cart.dart';
import 'package:cmenu/Components/Utils/setting_preferences.dart';
import 'package:cmenu/Single/product_screen.dart';
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
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: const Icon(Icons.arrow_back, color: kPrimaryColor)),
          title: Consumer<CartModel>(
            builder: (context, cart, child) => const Text("Bag",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor)),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {
                  var cart = context.read<CartModel>();
                  cart.removeAll();
                },
                icon: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.red,
                ))
          ],
        ),
        body: Column(
          children: [
            GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Set Budget",
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                            const Text(
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
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {});
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Save'))
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: kPrimaryLightColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Budget",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    Text("Total cost of items in your bag",
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Consumer<CartModel>(
                                      builder: (context, cart, child) => Text(
                                          "$currencyCode ${cart.remainingBudget(totalBudget, cart.totalPrice)}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryColor)),
                                    ),
                                    Consumer<CartModel>(
                                      builder: (context, cart, child) => Text(
                                          "$currencyCode ${cart.totalPrice}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryColor)),
                                    )
                                  ],
                                ),
                              ],
                            ))))),
            Expanded(
              child: _CartList(),
            ),
          ],
        ),
        bottomNavigationBar:Consumer<CartModel>(
              builder: (context, cart, child) {
                return BottomAppBar(
                        elevation: 0,
                        child:  ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Ready to Order",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                              )),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Let your waiter/waitress know that you're ready to!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, color: kPrimaryColor),
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
                                    child: const Text(
                                      'Not ready yet',
                                      style: TextStyle(color: Colors.black),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      setState(() {});
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('Okay'))
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<CartModel>(
                            builder: (context, cart, child) => Text(
                                cart.items.length.toString() +
                                    (cart.items.length > 1
                                        ? " items"
                                        : " item"),
                                style: const TextStyle(
                                  fontSize: 14,
                                )),
                          ),
                          const Text("Order",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Consumer<CartModel>(builder: (context, cart, child) {
                            return Text(
                              "$currencyCode ${cart.totalPrice} ",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            );
                          })
                        ],
                      ))));
              },
        ));
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();
    var items = cart.items;
    final ids = items.map((e) => e.id).toSet();
    items.retainWhere((x) => ids.remove(x.id));

    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProductScreen(
                  categoryName: "In bag",
                  product: cart.items[index],
                );
              }));
            },
            child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(15, 153, 153, 153),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    items[index].name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  if (items[index].description.isNotEmpty)
                                    Text(
                                      items[index].description,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Consumer<CartModel>(
                                        builder: (context, cart, child) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "$currencyCode${double.parse(items[index].price) * cart.itemCount(items[index])}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Row(
                                                children: [
                                                  _ActionButton(
                                                      delete: true,
                                                      item: items[index]),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 5),
                                                      child:
                                                          Consumer<CartModel>(
                                                        builder: (context, cart, child) => Text(
                                                            cart.itemCount(items[
                                                                        index]) !=
                                                                    0
                                                                ? cart
                                                                    .itemCount(
                                                                        items[
                                                                            index])
                                                                    .toString()
                                                                : "0",
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    kPrimaryColor)),
                                                      )),
                                                  _ActionButton(
                                                      delete: false,
                                                      item: items[index])
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ))
                                ])
                          ],
                        )))),

            // Padding(
            //   padding: const EdgeInsets.only(bottom:2),
            //   child: Container(
            //     decoration: const BoxDecoration(
            //         color: Color.fromARGB(15, 153, 153, 153),),
            //     child: ListTile(
            //       trailing: IconButton(
            //         icon:const Icon(Icons.delete_outline_outlined,color: Colors.red,),
            //         onPressed: () {
            //           cart.remove(cart.items[index]);
            //         },
            //       ),
            //       title: Text(
            //         cart.items[index].name,
            //         style: const TextStyle(
            //             overflow: TextOverflow.ellipsis,
            //             fontWeight: FontWeight.bold),
            //       ),
            //       subtitle: Text(
            //         "$currencyCode ${cart.items[index].price}",
            //         style: const TextStyle(overflow: TextOverflow.ellipsis),
            //       ),
            //       onTap: (){

            //                 Navigator.push(context,
            //                     MaterialPageRoute(builder: (context) {
            //                   return ProductScreen(
            //                     categoryName:"In bag",
            //                     product: cart.items[index],
            //                   );
            //                 }));

            //       },
            //     ),
            //   ))
          );
        });
  }
}

class _ActionButton extends StatefulWidget {
  final Product item;
  final bool delete;

  const _ActionButton({required this.item, required this.delete});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  var settings = SettingPreferences.getSetting();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.delete
          ? const Icon(
              Icons.remove_circle_outline,
              // color: Colors.red,
            )
          : const Icon(
              Icons.add_circle_outline_rounded,
              // color: Colors.green,
            ),
      onTap: () {
        var cart = context.read<CartModel>();
        String message = '';
        if (widget.delete) {
          cart.remove(widget.item);
          message = 'Item removed from order list';
        } else {
          cart.add(widget.item);
          message = 'Item added to order list';
          
        }
        if (message.isNotEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.toString())));
        }
      },
    );
  }
}
