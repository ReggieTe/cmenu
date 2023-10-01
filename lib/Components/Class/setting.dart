// ignore: file_names
class Setting {
  final String token;
  final String location;
  final double budget;
  final String cart;
  final String history;

  const Setting(
      {this.token = '',
      this.location = '',
      this.budget = 0.0,
      this.cart = '',
      this.history = ''});

  Setting copy({String? token, String? id, double? budget, String? location, String? cart , String? history }) =>
      Setting(
          token: token ?? this.token,
          budget: budget ?? this.budget,
          location: location ?? this.location,
          history:history ??this.history,
          cart:cart??this.cart          
          );

  static Setting fromJson(Map<String, dynamic> json) {
    return Setting(
      token: json['token'],
      budget: json['budget'] ?? json['budget'],
      location: json['location'] ?? json['location'],
      history:json['history'] ??json['history'],
      cart:json['cart']??json['cart']         
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'token': token.toString(),
      'budget': budget,
      'location': location.toString(),
      'history':history.toString(),
      'cart':cart.toString()
    };
    return map;
  }
}
