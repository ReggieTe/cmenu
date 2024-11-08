import 'package:cmenu/Components/Class/response.dart';
import 'package:cmenu/constants.dart';
import 'package:http/http.dart' as http;

class APIServiceList {
  Future<ResponseModel> search(RequestDataModel requestModel) async {
    String url = "${domainURL}search";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> getTrendingPlaces(RequestDataModel requestModel) async {
    String url = "${domainURL}trending";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> download(RequestDataModel requestModel) async {
    String url = "${domainURL}download";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> track(TrackDataModel requestModel) async {
    String url = "${domainURL}track";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> appSettings(RequestDataModel requestModel) async {
    String url = "${domainURL}settings";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> getTags(RequestDataModel requestModel) async {
    String url = "${domainURL}tags";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> searchByTag(RequestDataModel requestModel) async {
    String url = "${domainURL}search/tag";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> appTerms(GetRequestModel requestModel) async {
    String url = "${domainURL}terms";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> appDiscliamer(GetRequestModel requestModel) async {
    String url = "${domainURL}disclaimer";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> appFaqs(GetRequestModel requestModel) async {
    String url = "${domainURL}faqs";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> appPrivacy(GetRequestModel requestModel) async {
    String url = "${domainURL}privacy";
    return processRequest(requestModel, url);
  }

  Future<ResponseModel> appAbout(GetRequestModel requestModel) async {
    String url = "${domainURL}about";
    return processRequest(requestModel, url);
  }

  bool testNoExc = false;

  Future<ResponseModel> processRequest(dynamic requestModel, String url) async {
    final response =
        await http.post(Uri.parse(url), body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return ResponseModel.fromJson(response.body);
    }
    return ResponseModel.error(
        "Server failed to load request.Please try again");
  }
}
