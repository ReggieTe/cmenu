import 'package:cmenu/Components/Class/image.dart';
import 'package:cmenu/Components/Class/product.dart';

class MenuCategory {
  final String id;
  final String name;
  final String description;
  final List<Product> products;
  final List<MenuCategory> categories;
  final List<Image> images;
  MenuCategory(this.id,this.name, this.description, this.products, this.images, this.categories);
}
