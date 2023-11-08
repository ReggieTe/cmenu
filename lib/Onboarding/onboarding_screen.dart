import 'package:cmenu/Search/search_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:cmenu/Components/Utils/first_time_preferences.dart';
import 'package:cmenu/constants.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var firstTime = FirstTimePreferences.getFirstTime();
    return Scaffold(
      body: Center(
          child: IntroductionScreen(
        pages: [
          PageViewModel(
              image: buildImage("assets/images/chairs.png"),
              title: "Plan better",
              body: "Plan dates better & within your budget",
              decoration: getPageDecoration()),
          PageViewModel(
              image: buildImage("assets/images/bill.png"),
              title: 'Avoid Surprises ',
              body: "Avoid being surprised when the bill comes",
              decoration: getPageDecoration()), 
        ],
        onDone: () {
          firstTime = firstTime.copy(onBoarding: false);
          FirstTimePreferences.setFirstTime(firstTime);
          redirect(context);
        },
        onSkip: () {
          firstTime = firstTime.copy(onBoarding: false);
          FirstTimePreferences.setFirstTime(firstTime);
          redirect(context);
        },
        showSkipButton: true,
        skip: const Text('Skip'),
        next: const Icon(Icons.chevron_right),
        done: const Text("Got it", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: kPrimaryColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      )
      ),
    );
  }

  redirect(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SearchScreen();
    }));
  }

  //Missing

  Widget buildImage(String path) => Center(
        child: Image.asset(
          path,
          width: 200,
        ),
      );

  PageDecoration getPageDecoration() => const PageDecoration(
      imageAlignment: Alignment.bottomCenter,
      titleTextStyle: TextStyle(
          fontSize: 28, color: kPrimaryColor),
      bodyTextStyle: TextStyle(fontSize: 20,fontFamily: 'Quicksand'),
      imagePadding: EdgeInsets.symmetric(horizontal: 100),
      pageColor: Colors.white);
}
