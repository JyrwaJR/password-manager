import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final String uid;
  const CustomBottomNavigationBar({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);
    goRouter.addListener(() {
      if (goRouter.location == '/home') {
        if (mounted) {
          setState(() {
            selectedIndex = 0;
          });
        }
      } else if (goRouter.location == '/volt') {
        if (mounted) {
          setState(() {
            selectedIndex = 1;
          });
        }
      } else if (goRouter.location == '/profile') {
        if (mounted) {
          setState(() {
            selectedIndex = 2;
          });
        }
      }
    });
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          tabBackgroundColor: Theme.of(context).canvasColor,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          duration: const Duration(milliseconds: 300),
          activeColor: Theme.of(context).primaryColor,
          color: Theme.of(context).primaryColorDark,
          tabs: const [
            GButton(
              icon: Icons.equalizer_outlined,
              text: 'Tool',
            ),
            GButton(
              icon: Icons.shield_outlined,
              text: 'Password',
            ),
            GButton(
              icon: Icons.person_2_outlined,
              text: 'Profile',
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        if (widget.uid == 'null') {
          context.go(context.namedLocation('email'));
        } else {
          context.go(context.namedLocation('home'));
        }
        break;
      case 1:
        if (widget.uid == 'null') {
          context.go(context.namedLocation('email'));
        } else {
          context.go(context.namedLocation('volt'));
        }
        break;
      case 2:
        if (widget.uid == 'null') {
          context.go(context.namedLocation('email'));
        } else {
          context.go(context.namedLocation('profile',
              queryParameters: <String, String>{'uid': widget.uid}));
        }
        break;
    }
  }
}
