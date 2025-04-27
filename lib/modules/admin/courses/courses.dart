import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKeyForDesktopWeb;
  const Courses({super.key, this.navigatorKeyForDesktopWeb});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
