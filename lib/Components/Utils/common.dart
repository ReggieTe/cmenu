import 'package:carousel_slider/carousel_slider.dart';
import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/image.dart' as local_image;
import 'package:cmenu/Components/Class/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_fade/image_fade.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shimmer/shimmer.dart';

class Common {
  static Future<bool> checkInternetConnection(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    return await InternetConnectionChecker().hasConnection;
  }

  static void log(String id, String section) async {
    try {
      TrackDataModel requestModel =
          TrackDataModel(id: id, section: section,token: dotenv.get('api_key'));
      APIServiceList apiService = APIServiceList();
      await apiService.track(requestModel).then((value) async {
        if (value.error) {}
        if (!value.error) {}
      });
    } catch (error) {
      //print(error);
    }
  }

  static bool isValidName(String name) {
    final nameRegExp = RegExp(r"^\s*([A-Za-z ]{1,})$");
    return nameRegExp.hasMatch(name);
  }

  static Widget displayImage(
      {List<local_image.Image> images = const [],
      String imageType = 'default',
      bool displayMultiple = false,
      double imageHeight = 128,
      double imageWidth = 128,
      String defaultImageFromUser = "menu",
      bool noDefaultImage = false}) {
    String defaultImage = "assets/images/$defaultImageFromUser.png";
    if (images.isNotEmpty) {
      if (displayMultiple) {
        return SizedBox(
            height: imageHeight,
            width: imageWidth,
            child: CarouselSlider(
              options: CarouselOptions(height: imageHeight),
              items: images.map((i) {
                return Builder(builder: (BuildContext context) {
                  return ImageFade(
                    image: NetworkImage(i.file),
                    height: imageHeight,
                    fit: BoxFit.fill,
                    placeholder: Image.asset(defaultImage),
                    loadingBuilder: (context, progress, chunkEvent) =>
                        Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
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
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.white,
                child: Container(
                  color: Colors.grey,
                ),
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

      if (noDefaultImage) {
        return Container();
      } else {
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
}
