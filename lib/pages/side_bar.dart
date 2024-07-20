import 'package:flutter/material.dart';
import 'package:mother_ai/components/info_card.dart';
import 'package:mother_ai/pages/chat_page.dart';
import 'package:mother_ai/pages/home_page.dart';
import 'package:mother_ai/pages/milestone_page.dart';
import 'package:mother_ai/pages/recipe_page.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color.fromARGB(255, 9, 141, 125),
        width: 288,
        height: double.infinity,
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const InfoCard(
              name: 'Mama',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
              child: Text(
                "Browse".toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white70),
              ),
            ),
            const Divider(height: 1.0),
            ...menuItems.map((menuItem) => ListTile(
                  leading: Icon(menuItem.icon),
                  title: Text(menuItem.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => menuItem.screen),
                    );
                  },
                ))
          ]),
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final Widget screen;
  const MenuItem(
      {required this.icon, required this.title, required this.screen});
}

final List<MenuItem> menuItems = [
  const MenuItem(icon: Icons.home, title: 'Home', screen: HomePage()),
  const MenuItem(icon: Icons.food_bank, title: 'Recipe', screen: RecipePage()),
  const MenuItem(icon: Icons.chat, title: 'Ask Me', screen: ChatPage()),
  const MenuItem(
      icon: Icons.bedroom_baby, title: 'Milestones', screen: MilestonePage()),
];