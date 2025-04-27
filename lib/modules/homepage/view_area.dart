import 'package:flutter/material.dart';
import 'package:systems_app/modules/add_new/add_new.dart';
import 'package:systems_app/modules/all_courses/all_courses.dart';
import 'package:systems_app/modules/books/books.dart';
import 'package:systems_app/modules/courses/courses.dart';
import 'package:systems_app/modules/home_dashboard/home_dashboard.dart';
import 'package:systems_app/modules/my_courses/my_courses.dart';
import 'package:systems_app/modules/projects/projects.dart';
import 'package:systems_app/routes.dart';

class ViewArea extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String role;

  const ViewArea({
    super.key,
    required this.navigatorKey,
    required this.role,
  });

  @override
  State<ViewArea> createState() => _ViewAreaState();
}

class _ViewAreaState extends State<ViewArea> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case homeDashboardRoute:
            builder = (context) => HomeDashboard(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                  role: widget.role,
                );
            break;
          case myCoursesRoute:
            builder = (context) => MyCourses(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case coursesRoute:
            builder = (context) => Courses(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case allCoursesRoute:
            builder = (context) => AllCourses(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case addNewRoute:
            builder = (context) => AddNew(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case booksRoute:
            builder = (context) => Books(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case projectsRoute:
            builder = (context) => Projects(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          default:
            builder = (context) => HomeDashboard(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                  role: widget.role,
                );
        }
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      },
    );
  }
}
