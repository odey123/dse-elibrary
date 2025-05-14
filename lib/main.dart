import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:systems_app/app/helpers/session_manager.dart';
import 'package:systems_app/firebase_options.dart';
import 'package:systems_app/modules/add_new/add_new.dart';
import 'package:systems_app/modules/admin/add_new/add_new.dart';
import 'package:systems_app/modules/admin/courses/courses.dart';
import 'package:systems_app/modules/admin/hod/hod.dart';
import 'package:systems_app/modules/admin/homepage/homepage.dart';
import 'package:systems_app/modules/admin/lecturers/add_lecturers.dart';
import 'package:systems_app/modules/admin/lecturers/lecturers.dart';
import 'package:systems_app/modules/admin/students/add_students.dart';
import 'package:systems_app/modules/admin/students/students.dart';
import 'package:systems_app/modules/all_courses/all_courses.dart';
import 'package:systems_app/modules/authentication/forgot_password.dart';
import 'package:systems_app/modules/authentication/sign_in.dart';
import 'package:systems_app/modules/admin/authentication/sign_in_admin.dart';
import 'package:systems_app/modules/books/books.dart';
import 'package:systems_app/modules/home_dashboard/home_dashboard.dart';
import 'package:systems_app/modules/homepage/homepage.dart';
import 'package:systems_app/modules/my_courses/my_courses.dart';
import 'package:systems_app/modules/projects/projects.dart';
import 'package:systems_app/routes.dart';
import 'package:systems_app/services/auth/auth_checker.dart';
import 'package:systems_app/utils/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(const Duration(milliseconds: 100));
  await SessionManager.initSharedPreference();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Department of Systems Engineering E-Library',
      theme: kThemeData,
      home: const AuthChecker(),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        signInRoute: (context) => const SignIn(),
        signInAsAdminRoute: (context) => const SignInAsAdmin(),
        forgotPasswordRoute: (context) => const ForgotPassword(),
        homeRoute: (context) => const HomePage(),
        homeAdminRoute: (context) => const HomePageAdmin(),
        homeDashboardRoute: (context) => const HomeDashboard(),
        myCoursesRoute: (context) => const MyCourses(),
        allCoursesRoute: (context) => const AllCourses(),
        addNewRoute: (context) => const AddNew(),
        booksRoute: (context) => const Books(),
        projectsRoute: (context) => const Projects(),
        addStudentsRoute: (context) => const AddStudents(),
        addLecturersRoute: (context) => const AddLecturers(),
        addHodRoute: (context) => const AddLecturers(),
        studentRoute: (context) => const Students(),
        lecturersRoute: (context) => const Lecturers(),
        hodRoute: (context) => const Hod(),
        coursesRoute: (context) => const Courses(),
        addNewAdminRoute: (context) => const AddNewAdmin(),
      },
    );
  }
}
