import 'package:cmenu/Components/Api/api.service.list.dart';
import 'package:cmenu/Components/Class/response.dart';

class APIServiceData {
  Future<ResponseModel> fetchInformationContentData(String type) {
    GetRequestModel requestModel = GetRequestModel(authid: "");
    switch (type) {
      case 'disclaimer':
        return APIServiceList().appDiscliamer(requestModel);
      case 'about':
        return APIServiceList().appAbout(requestModel);
      case 'faqs':
        return APIServiceList().appFaqs(requestModel);
      case 'privacy':
        return APIServiceList().appPrivacy(requestModel);
      case 'terms':
        return APIServiceList().appTerms(requestModel);
      default:
        return APIServiceList().appTerms(requestModel);
    }
  }
}
