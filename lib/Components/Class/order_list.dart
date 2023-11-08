// ignore: file_names
import 'package:cmenu/Components/Class/product.dart';
import 'package:cmenu/Components/Class/search_item.dart';

class OrderList {
  final SearchItem place;
  final List<Product> products;
  final String date;

  const OrderList(this.place ,
      this.products,
      this.date ,
      );

  OrderList copy(SearchItem place, List<Product> products, String date) =>
      OrderList(
          this.place,
          this.products,
          this.date          
          );

  static OrderList fromJson(Map<String, dynamic> json) {
    return OrderList(
      json['place'],
      json['products'],
      json['date']      
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'place': place.toString(),
      'products':products.toString(),
      'date':date.toString()
    };
    return map;
  }
}
