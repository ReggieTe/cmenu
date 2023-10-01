class App {
  final String app;
  final String petType;
  final String gender;
  final String documentType;
  final String documentUploadType;
  final String accountState;
  final String searchType;
  final String postMessage;
  final String timeIntervals;
  final String listTypes;
  final String listReportType;
  final String locationCities;
  final String radius;
  final String type;
  final String country;
  final String location;
  final String adState;
  final String build;
  final String dashboardEnum;
  final String eyes;
  final String found;
  final String hair;
  final String height;
  final String payment;
  final String paymentStatus;
  final String race;
  final String weight;
  final String state;
  final String accountType;
  final String searchHistory;
  final String feedType;

  const App(
      {required this.app,
      required this.petType,
      required this.gender,
      required this.listReportType,
      required this.documentType,
      required this.documentUploadType,
      required this.accountState,
      required this.searchType,
      required this.postMessage,
      required this.timeIntervals,
      required this.listTypes,
      required this.locationCities,
      required this.radius,
      required this.type,
      required this.country,
      required this.location,
      required this.adState,
      required this.build,
      required this.dashboardEnum,
      required this.eyes,
      required this.found,
      required this.hair,
      required this.height,
      required this.payment,
      required this.paymentStatus,
      required this.race,
      required this.weight,
      required this.state,
      required this.accountType,
      required this.searchHistory,
      required this.feedType});

  App copy(
          {String? app,
          String? petType,
          String? gender,
          String? documentType,
          String? listReportType,
          String? documentUploadType,
          String? accountState,
          String? searchType,
          String? postMessage,
          String? timeIntervals,
          String? listTypes,
          String? radius,
          String? locationCities,
          String? type,
          String? country,
          String? location,
          String? adState,
          String? build,
          String? dashboardEnum,
          String? eyes,
          String? found,
          String? hair,
          String? height,
          String? payment,
          String? paymentStatus,
          String? race,
          String? weight,
          String? state,
          String? accountType,
          String? searchHistory,
          String? feedType}) =>
      App(
          app: app ?? this.app,
          petType: petType ?? this.petType,
          gender: gender ?? this.gender,
          listReportType: listReportType ?? this.listReportType,
          documentType: documentType ?? this.documentType,
          documentUploadType: documentUploadType ?? this.documentUploadType,
          accountState: accountState ?? this.accountState,
          searchType: searchType ?? this.searchType,
          postMessage: postMessage ?? this.postMessage,
          timeIntervals: timeIntervals ?? this.timeIntervals,
          listTypes: listTypes ?? this.listTypes,
          locationCities: locationCities ?? this.locationCities,
          radius: radius ?? this.radius,
          type: type ?? this.type,
          country: country ?? this.country,
          location: location ?? this.location,
          adState: adState ?? this.adState,
          build: build ?? this.build,
          dashboardEnum: dashboardEnum ?? this.dashboardEnum,
          eyes: eyes ?? this.eyes,
          found: found ?? this.found,
          hair: hair ?? this.hair,
          height: height ?? this.height,
          payment: payment ?? this.payment,
          paymentStatus: paymentStatus ?? this.paymentStatus,
          race: race ?? this.race,
          weight: weight ?? this.weight,
          state: state ?? this.state,
          accountType: accountType ?? this.accountType,
          searchHistory: searchHistory ?? this.searchHistory,
          feedType:feedType??this.feedType);

  static App fromJson(Map<String, dynamic> json) => App(
      app: json['app'],
      petType: json['petType'],
      listReportType: json['listReportType'],
      gender: json['gender'],
      documentType: json['documentType'],
      documentUploadType: json['documentUploadType'],
      accountState: json['accountState'],
      searchType: json['searchType'],
      postMessage: json['postMessage'],
      timeIntervals: json['timeIntervals'],
      listTypes: json['listTypes'],
      locationCities: json['locationCities'],
      radius: json['radius'],
      type: json['type'],
      country: json['country'],
      location: json['location'],
      adState: json['adState'],
      build: json['build'],
      dashboardEnum: json['dashboardEnum'],
      eyes: json['eyes'],
      found: json['found'],
      hair: json['hair'],
      height: json['height'],
      payment: json['payment'],
      paymentStatus: json['paymentStatus'],
      race: json['race'],
      weight: json['weight'],
      state: json['state'],
      accountType: json['accountType'],
      searchHistory: json['searchHistory'],
      feedType: json['feedType']
      );

  Map<String, dynamic> toJson() => {
        'app': app,
        'petType': petType,
        'gender': gender,
        'documentType': documentType,
        'documentUploadType': documentUploadType,
        'accountState': accountState,
        'searchType': searchType,
        'postMessage': postMessage,
        'listReportType': listReportType,
        'timeIntervals': timeIntervals,
        'listTypes': listTypes,
        'locationCities': locationCities,
        'radius': radius,
        'type': type,
        'country': country,
        'location': location,
        'adState': adState,
        'build': build,
        'dashboardEnum': dashboardEnum,
        'eyes': eyes,
        'found': found,
        'hair': hair,
        'height': height,
        'payment': payment,
        'paymentStatus': paymentStatus,
        'race': race,
        'weight': weight,
        'state': state,
        'accountType': accountType,
        'searchHistory': searchHistory,
        'feedType':feedType
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
