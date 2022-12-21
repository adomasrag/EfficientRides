import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/findtrips.dart';
import 'package:loginuicolors/screens/addtrips.dart';
import 'package:loginuicolors/screens/triphistory.dart';
import 'package:loginuicolors/screens/myroutes.dart';
import 'package:loginuicolors/screens/messages.dart';
import 'package:loginuicolors/screens/rating.dart';
import 'package:loginuicolors/screens/profile.dart';
import 'package:loginuicolors/models/userModel.dart';
import '../models/tab_navigator.dart';

//
import '../animation/fadeanimation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentPage = "Page1";
  int _selectedIndex = 0;
  List<String> pageKeys = ["Page1", "Page2", "Page3", "Page4"];
  late Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
    "Page4": GlobalKey<NavigatorState>(),
  };

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Page1") {
            _selectTab("Page1", 1);

            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        /*drawer: Container(
          width: 300,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 140,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: Colors.black54, blurRadius: 10.0, offset: Offset(0, 0.75))
                      ],
                    ),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 30,
                            child: user.profileImage == ""
                                ? Icon(
                                    Icons.person,
                                    size: 30,
                                  )
                                : ClipOval(
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: Image.network(
                                        user.profileImage,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Text(
                              user.firstName + ' ' + user.lastName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                        leading: Icon(Icons.history),
                        title: Text('Kelionių istorija'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TripHistoryScreen()),
                          );
                        }),
                    ListTile(
                        leading: Icon(Icons.route),
                        title: Text('Mano maršrutai'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyRoutesScreen()),
                          );
                        }),
                    ListTile(
                        leading: Icon(Icons.message),
                        title: Text('Žinutės'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MessagesScreen()),
                          );
                        }),
                    ListTile(
                        leading: Icon(Icons.rate_review),
                        title: Text('Kelionės įvertinimas'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RatingScreen()),
                          );
                        }),
                    ListTile(
                        leading: Icon(Icons.payment),
                        title: Text('Mokėjimo informacija'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentInfoScreen()),
                          );
                        }),
                    ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Profilis'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        }),
                    ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Nustatymai'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),*/
        body: Stack(children: <Widget>[
          _buildOffstageNavigator("Page1"),
          _buildOffstageNavigator("Page2"),
          _buildOffstageNavigator("Page3"),
          _buildOffstageNavigator("Page4"),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            _selectTab(pageKeys[index], index);
          },
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: ('Pagrindinis'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.route_outlined),
              label: ('Kelionės'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.messenger_outlined),
              label: ('Žinutės'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              label: ('Profilis'),
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
