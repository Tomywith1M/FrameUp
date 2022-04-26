import 'package:flutter/material.dart';
import 'package:frameup/app/theme.dart';
import 'package:frameup/app/utils.dart';
import 'package:frameup/components/Publish/publish.dart';
import 'package:frameup/components/Widg/dimmer.dart';
import 'package:frameup/components/log/log_page.dart';
import 'package:frameup/components/profile/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frameup/components/search/search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const List<Widget> _homePages = <Widget>[
    _OrganicActive(child: LogPage()),
    _OrganicActive(child: SearchPage()),
    _OrganicActive(child: ProfilePage())
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).appBarTheme.iconTheme!.color!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Frame-Up', style: GoogleFonts.dancingScript(fontSize: 30)),
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Dimmer(
              onTap: () => Navigator.of(context).push(PublishScreen.route),
              icon: Icons.add_circle_outline,
              iconColor: iconColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Dimmer(
              onTap: () async {
                context.removeAndShowSnackbar('Work in Progress');
              },
              icon: Icons.favorite_outline,
              iconColor: iconColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Dimmer(
              onTap: () => context.removeAndShowSnackbar('Work in Progress'),
              icon: Icons.logout,
              iconColor: iconColor,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: HomeScreen._homePages,
      ),
      bottomNavigationBar: _FrameupBottomNavBar(
        pageController: pageController,
      ),
    );
  }
}

class _FrameupBottomNavBar extends StatefulWidget {
  const _FrameupBottomNavBar({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  State<_FrameupBottomNavBar> createState() => _FrameupBottomNavBarState();
}

class _FrameupBottomNavBarState extends State<_FrameupBottomNavBar> {
  void _onNavigationItemTapped(int index) {
    widget.pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.dark)
                ? AppColors.ligthGrey.withOpacity(0.5)
                : AppColors.faded.withOpacity(0.5),
            blurRadius: 1,
          ),
        ],
      ),
      child: BottomNavigationBar(
        onTap: _onNavigationItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        iconSize: 26,
        currentIndex: widget.pageController.page?.toInt() ?? 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(
              Icons.search,
              size: 25,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Person',
          )
        ],
      ),
    );
  }
}

class _OrganicActive extends StatefulWidget {
  const _OrganicActive({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _OrganicActiveState createState() => _OrganicActiveState();
}

class _OrganicActiveState extends State<_OrganicActive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
