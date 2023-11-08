import 'dart:convert';

class ResponseModel {
  final String message;

  ///  returns true if the api call failed i.e status code not equal to 200/400
  final bool error;
  final Map<String, dynamic> data;

  /// returns a list of errors
  final Map<String, dynamic> errors;

  ResponseModel(
      {required this.message,
      required this.error,
      required this.data,
      required this.errors});

  factory ResponseModel.fromJson(String rawData) {
    var jsonn = json.decode(rawData);
    return ResponseModel(
        errors: jsonn["errors"] ?? {},
        message: jsonn["message"] ?? "",
        data: jsonn['body'] ?? const {},
        error: jsonn["code"] == 200 ? false : true);
  }

  factory ResponseModel.error(String? errorMessage) {
    return ResponseModel(
        message: errorMessage ?? "Failed to process data",
        data: {},
        error: true,
        errors: {});
  }

  @override
  String toString() {
    return {
      'message': message,
      'error': error,
      'data': data,
      'errors': errors,
    }.toString();
  }
}

class RequestDataModel {
  final String id;
  final String keyword;
  final String token;

  RequestDataModel({
    required this.id,
    required this.keyword,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'id': id.trim(), 'keyword': keyword.trim(),'token':token.trim()};
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class TrackDataModel {
  final String token;
  final String section;
  final String id;

  TrackDataModel({
    required this.token,
    required this.section,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id.trim(),
      'token': token.trim(),
      'section': section.trim()
    };
    return map;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
