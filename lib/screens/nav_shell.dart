
import 'package:checkfront/screens/about_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_pill_nav.dart';
import '../widgets/app_sidebar.dart';
import 'home_screen.dart';
import 'history_screen.dart';

class NavShell extends StatefulWidget {
  final int initialIndex; // ✅ added
  const NavShell({super.key, this.initialIndex = 0}); // ✅ added

  @override
  State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
  late int index; // ✅ changed to late

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex; // ✅ start from drawer target
  }

  AppBar _appBar(String title) {
    return AppBar(
      title: Text(title),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBarForIndex() {
    if (index == 1) return _appBar("History");
    if (index == 2) return _appBar("About");
    return _appBar("CheckAi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: _appBarForIndex(),

      body: Stack(
        children: [
          IndexedStack(
            index: index,
            children: const [HomeScreen(), HistoryScreen(), AboutScreen()],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: SizedBox(
                width: 210,
                height: 54,
                child: BottomPillNav(
                  index: index,
                  onChanged: (i) => setState(() => index = i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}