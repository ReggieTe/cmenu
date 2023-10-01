import 'package:cmenu/Components/Class/image.dart';

class Product {
  final String id;
  final String name;
  final String price;
  final String description;
  final String discount;
  final List<image> images;
  Product(this.id, this.name, this.price, this.description, this.discount,this.images);
}
