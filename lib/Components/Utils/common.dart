import 'package:internet_connection_checker/internet_connection_checker.dart';

class common {

  static Future<bool> checkInternetConnection(InternetConnectionChecker internetConnectionChecker,
  ) async {
    return await InternetConnectionChecker().hasConnection;
  }
}
