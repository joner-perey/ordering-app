import 'package:flutter/material.dart';
import 'package:lalaco/controller/controllers.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Widget page;

  const SectionTitle({Key? key, required this.title, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          GestureDetector(
            onTap: () {
              homeController.getPopularProducts();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
            child: const Text(
              "See more",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
