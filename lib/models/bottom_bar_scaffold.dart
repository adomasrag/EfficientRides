import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  /// pass the required items for the tabs and BottomNavigationBar
  final List<GButtonItem> tabs;

  const PersistentBottomBarScaffold({Key? key, required this.tabs}) : super(key: key);

  @override
  _PersistentBottomBarScaffoldState createState() => _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState extends State<PersistentBottomBarScaffold> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return WillPopScope(
      onWillPop: () async {
        /// Check if curent tab can be popped
        if (widget.tabs[_selectedTab].navigatorkey?.currentState?.canPop() ?? false) {
          widget.tabs[_selectedTab].navigatorkey?.currentState?.pop();
          return false;
        } else {
          // if current tab can't be popped then use the root navigator
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        /// Using indexedStack to maintain the order of the tabs and the state of the previously opened tab
        body: IndexedStack(
          index: _selectedTab,
          children: widget.tabs
              .map((page) => Navigator(
                    /// Each tab is wrapped in a Navigator so that naigation in
                    /// one tab can be independent of the other tabs
                    key: page.navigatorkey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [MaterialPageRoute(builder: (context) => page.tab)];
                    },
                  ))
              .toList(),
        ),

        /// Define the persistent bottom bar

        bottomNavigationBar: isKeyboardOpen
            ? null
            : Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                  child: GNav(
                    backgroundColor: Colors.black,
                    color: Colors.white,
                    activeColor: Colors.white,
                    tabBackgroundColor: Theme.of(context).primaryColor,
                    gap: 8,
                    duration: const Duration(milliseconds: 350),
                    padding: EdgeInsets.all(16),
                    selectedIndex: _selectedTab,
                    tabs: widget.tabs.map((item) => GButton(icon: item.icon, text: item.text)).toList(),
                    onTabChange: (index) {
                      if (index == _selectedTab) {
                        /// if you want to pop the current tab to its root then use
                        widget.tabs[index].navigatorkey?.currentState?.popUntil((route) => route.isFirst);

                        /// if you want to pop the current tab to its last page
                        /// then use
                        // widget.items[index].navigatorkey?.currentState?.pop();
                      } else {
                        setState(() {
                          _selectedTab = index;
                        });
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

/// Model class that holds the tab info for the [PersistentBottomBarScaffold]
class GButtonItem {
  final Widget tab;
  final GlobalKey<NavigatorState>? navigatorkey;
  final String text;
  final IconData icon;

  GButtonItem({required this.tab, this.navigatorkey, required this.text, required this.icon});
}
