import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mother_ai/pages/home_page.dart';




class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,});

  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()), // Pass name to next screen (optional)
        ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.white24,
          child: Icon(
            CupertinoIcons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
