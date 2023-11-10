import 'package:carousel_slider/carousel_slider.dart';
import 'package:cmenu/Components/Class/image.dart' as local_image;
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Common {
  static Future<bool> checkInternetConnection(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    return await InternetConnectionChecker().hasConnection;
  }

  static bool isValidName(String name){
    final nameRegExp = RegExp(r"^\s*([A-Za-z ]{1,})$");
    return nameRegExp.hasMatch(name);
  }

  static Widget displayImage(
      {List<local_image.Image> images = const [],
      String imageType = 'default',
      bool displayMultiple = false,
      double imageHeight = 128,
      double imageWidth = 128,
      String defaultImageFromUser = "menu"}) {
    String defaultImage = "assets/images/$defaultImageFromUser.png";
    if (images.isNotEmpty) {
      if (displayMultiple) {
        return SizedBox(
                height:imageHeight ,
                width: imageWidth,
                child:CarouselSlider(
          options: CarouselOptions(height: imageHeight),
          items: images.map((i) {
            return Builder(builder: (BuildContext context) {
              return ImageFade(
                image: NetworkImage(i.file),
                height:imageHeight ,
                fit: BoxFit.fitWidth,
                placeholder: Image.asset(defaultImage),
                loadingBuilder: (context, progress, chunkEvent) =>
                    CircularProgressIndicator(value: progress),
                errorBuilder: (context, error) => Image.asset(
                  defaultImage,
                  fit: BoxFit.cover,
                ),
              );
            });
          }).toList(),
        ));
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox.fromSize(
              child: ImageFade(
            height: imageHeight,
            width: imageWidth,
            image: NetworkImage(images.elementAt(0).file),
            fit: BoxFit.cover,
            placeholder: Image.asset(defaultImage),
            loadingBuilder: (context, progress, chunkEvent) {
              return CircularProgressIndicator(
                value: progress,
                strokeWidth: 1.0,
              );
            },
            errorBuilder: (context, error) => Image.asset(defaultImage),
          )),
        );
      }
    } else {
      String imageToDisplay = defaultImage;

      switch (imageType) {
        case 'food':
          imageToDisplay = "assets/images/dish.png";
          break;
        case 'beer':
          imageToDisplay = "assets/images/beer.png";
          break;
        case 'beers':
          imageToDisplay = "assets/images/beers.png";
          break;
        case 'cider':
          imageToDisplay = "assets/images/cider.png";
          break;
        case 'cocktail':
          imageToDisplay = "assets/images/cocktail.png";
          break;
        case 'coffee':
          imageToDisplay = "assets/images/hot-coffe.png";
          break;
        case 'whiskey':
          imageToDisplay = "assets/images/whiskey.png";
          break;
        case 'wine':
          imageToDisplay = "assets/images/wine.png";
          break;
        case 'wine-bucket':
          imageToDisplay = "assets/images/wine-bucket.png";
          break;
        case 'ice-cream':
          imageToDisplay = "assets/images/ice-cream.png";
          break;
        case 'place':
          imageToDisplay = "assets/images/restaurant.png";
          break;
        default:
      }

      return SizedBox(
          height: imageHeight,
          width: imageWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(imageToDisplay),
          ));
    }
  }
}
