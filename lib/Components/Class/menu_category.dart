import 'package:cmenu/Components/Class/image.dart';
import 'package:cmenu/Components/Class/product.dart';

class MenuCategory {
  final String name;
  final String description;
  final List<Product> products;
  final List<image> images;
  MenuCategory(this.name, this.description, this.products, this.images);
}
