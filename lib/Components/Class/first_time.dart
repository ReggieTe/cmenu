

class FirstTime {
  final bool onBoarding;
  final bool splash;

  const FirstTime({
    this.splash = true,
    this.onBoarding = true,
    
  });

  FirstTime copy({
    bool? splash,
    bool? onBoarding,
   
  }) =>
      FirstTime(
          splash: splash ?? this.splash,
          onBoarding: onBoarding ?? this.onBoarding,
          );

  static FirstTime fromJson(Map<String, dynamic> json) => FirstTime(
        splash: json['onBoarding'],
        onBoarding: json['onBoarding'],
       
      );

  Map<String, dynamic> toJson() => {
        'splash': splash,
        'onBoarding': onBoarding,       
      };
}
