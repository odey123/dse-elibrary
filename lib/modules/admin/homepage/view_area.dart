import 'package:flutter/material.dart';
import 'package:systems_app/modules/admin/accreditation/accreditation.dart';
import 'package:systems_app/modules/admin/add_new/add_new.dart';
import 'package:systems_app/modules/admin/hod/hod.dart';
import 'package:systems_app/modules/admin/home_dashboard/home_dashboard.dart';
import 'package:systems_app/modules/admin/lecturers/lecturers.dart';
import 'package:systems_app/modules/admin/students/students.dart';
import 'package:systems_app/modules/books/books.dart';
import 'package:systems_app/modules/projects/projects.dart';
import 'package:systems_app/routes.dart';

class ViewAreaAdmin extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ViewAreaAdmin({
    super.key,
    required this.navigatorKey,
  });

  @override
  State<ViewAreaAdmin> createState() => _ViewAreaAdminState();
}

class _ViewAreaAdminState extends State<ViewAreaAdmin> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case homeDashboardRoute:
            builder = (context) => HomeDashboardAdmin(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case studentRoute:
            builder = (context) => Students(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case lecturersRoute:
            builder = (context) => Lecturers(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case hodRoute:
            builder = (context) => Hod(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case addNewAdminRoute:
            builder = (context) => AddNewAdmin(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case booksRoute:
            builder = (context) => Books(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          case accreditationRoute:
            builder = (context) => Accreditation(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
            break;
          default:
            builder = (context) => HomeDashboardAdmin(
                  navigatorKeyForDesktopWeb: widget.navigatorKey,
                );
        }
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}
