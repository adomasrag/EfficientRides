import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/home.dart';
import 'package:loginuicolors/screens/triphistory.dart';
import 'package:loginuicolors/screens/messages.dart';
import 'package:loginuicolors/screens/profile.dart';
import '../models/bottom_bar_scaffold.dart';

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
