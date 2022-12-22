import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/namai.dart';
import 'package:loginuicolors/screens/triphistory.dart';
import 'package:loginuicolors/screens/messages.dart';
import 'package:loginuicolors/screens/profile.dart';
import '../models/bottom_bar_scaffold.dart';

import '../animation/fadeanimation.dart';

class HomeScreen extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();
  final _tab4navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      tabs: [
        GButtonItem(
          icon: Icons.home,
          text: 'Pagrindinis',
          tab: NamaiScreen(),
          navigatorkey: _tab1navigatorKey,
        ),
        GButtonItem(
          icon: Icons.route_outlined,
          text: 'Kelionės',
          tab: TripHistoryScreen(),
          navigatorkey: _tab2navigatorKey,
        ),
        GButtonItem(
          icon: Icons.message_outlined,
          text: 'Žinutės',
          tab: MessagesScreen(),
          navigatorkey: _tab3navigatorKey,
        ),
        GButtonItem(
          icon: Icons.person,
          text: 'Profilis',
          tab: ProfileScreen(),
          navigatorkey: _tab4navigatorKey,
        ),
      ],
    );
  }
}

class TabPage1 extends StatelessWidget {
  const TabPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TabPage1 build');
    return Scaffold(
      appBar: AppBar(title: Text('Tab 1')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab 1'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Page1('Tab1')));
                },
                child: Text('Go to page1-Mokejimo informacija'))
          ],
        ),
      ),
    );
  }
}

class TabPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('TabPage2 build');
    return Scaffold(
      appBar: AppBar(title: Text('Tab 2')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab 2'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Page2('tab2')));
                },
                child: Text('Go to page2'))
          ],
        ),
      ),
    );
  }
}

class TabPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('TabPage3 build');
    return Scaffold(
      appBar: AppBar(title: Text('Tab 3')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab 3'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Page2('tab3')));
                },
                child: Text('Go to page2'))
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  final String inTab;

  const Page1(this.inTab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 1-Mokejimo informacia')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('in $inTab Page 1'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Page2(inTab)));
                },
                child: Text('Go to page2'))
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final String inTab;

  const Page2(this.inTab);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 2')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('in $inTab Page 2'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Page3(inTab)));
                },
                child: Text('Go to page3'))
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  final String inTab;

  const Page3(this.inTab);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 3')),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('in $inTab Page 3'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Go back'))
          ],
        ),
      ),
    );
  }
}
