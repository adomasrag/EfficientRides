import 'package:after_layout/after_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:loginuicolors/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
//
import 'auth/main_page.dart';

void main() async {
  /// initialize FireBase App
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    new MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF14C3AE),
        scaffoldBackgroundColor: Color(0xFF0d1b28),
        errorColor: Color(0xFFC31429),
        fontFamily: 'Raleway',
      ),
      //home: MainScreen(),
      home: new Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new MainScreen()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),
    );
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
          pages: [
            PageViewModel(
              titleWidget: Center(),
              body: 'Introducing the ultimate intercity carpooling app!',
              image: buildImage("assets/1.webp"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              titleWidget: Center(),
              body: 'Announce travel plans, connect with fellow travelers.',
              image: buildImage("assets/2.jpeg"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              titleWidget: Center(),
              body: 'Avoid crowded buses and enjoy comfortable journeys by car.',
              image: buildImage("assets/3.jpg"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
          ],
          onDone: () {
            if (true) {
              print("Done clicked");
              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new MainScreen()));
            }
          },
          //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
          scrollPhysics: const ClampingScrollPhysics(),
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: true,
          isBottomSafeArea: true,
          skip: const Text("SKIP", style: TextStyle(fontWeight: FontWeight.w600)),
          next: const Icon(Icons.navigate_next),
          done: const Text("DONE", style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: getDotsDecorator()),
    );
  }
}

//widget to add the image on screen
Widget buildImage(String imagePath) {
  return Center(
      child: Image.asset(
    imagePath,
    height: 550,
    //height: 350,
  ));
}

//method to customise the page style
PageDecoration getPageDecoration() {
  return const PageDecoration(
    pageColor: Colors.white,
    imagePadding: EdgeInsets.only(top: 120),
    bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
    titlePadding: EdgeInsets.only(top: 50),
    bodyTextStyle: TextStyle(fontSize: 26, color: Colors.black),
  );
}

//method to customize the dots style
DotsDecorator getDotsDecorator() {
  return const DotsDecorator(
    spacing: EdgeInsets.symmetric(horizontal: 2),
    activeColor: Colors.indigo,
    color: Colors.grey,
    activeSize: Size(12, 5),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
  );
}
