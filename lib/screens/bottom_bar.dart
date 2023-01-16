import 'package:flutter/material.dart';
import 'package:loginuicolors/models/bottom_bar_scaffold.dart';
import 'package:loginuicolors/screens/home.dart';
import 'package:loginuicolors/screens/messages.dart';
import 'package:loginuicolors/screens/profile.dart';
import 'package:loginuicolors/screens/triphistory.dart';

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
          text: 'Home',
          tab: NamaiScreen(),
          navigatorkey: _tab1navigatorKey,
        ),
        GButtonItem(
          icon: Icons.route_outlined,
          text: 'Trips',
          tab: TripHistoryScreen(),
          navigatorkey: _tab2navigatorKey,
        ),
        GButtonItem(
          icon: Icons.message_outlined,
          text: 'Messages',
          tab: MessagesScreen(),
          navigatorkey: _tab3navigatorKey,
        ),
        GButtonItem(
          icon: Icons.person,
          text: 'Profile',
          tab: ProfileScreen(),
          navigatorkey: _tab4navigatorKey,
        ),
      ],
    );
  }
}
