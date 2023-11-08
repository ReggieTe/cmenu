import 'package:cmenu/Components/Class/image.dart';

class Product {
  final String id;
  final String name;
  final String price;
  final String description;
  final String discount;
  final List<Image> images;
  final String type;
  Product(this.id, this.name, this.price, this.description, this.discount,
      this.images,{this.type=''});
}
