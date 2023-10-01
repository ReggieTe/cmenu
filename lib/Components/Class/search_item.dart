import 'package:cmenu/Components/Class/image.dart';
import 'package:cmenu/Components/Class/menu_category.dart';

class SearchItem {
  final String id;
  final String name;
  final String address;
  final List<MenuCategory> categories;  
  final List<image> images;
  SearchItem(this.id,this.name, this.address, this.categories, this.images, );
}
