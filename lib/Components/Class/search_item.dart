import 'package:cmenu/Components/Class/ad.dart';
import 'package:cmenu/Components/Class/image.dart';
import 'package:cmenu/Components/Class/menu_category.dart';
import 'package:cmenu/Components/Class/open_time.dart';

class SearchItem {
  final String id;
  final String name;
  final String address;
  final String description;
  final String phone;
  final List<MenuCategory> categories;
  final List<Image> images;
  final List<Ad> ads;
  final List<OpenTime> days;
  SearchItem(this.id, this.name, this.address, this.categories, this.images,
      this.description, this.phone, this.ads,this.days);
}
