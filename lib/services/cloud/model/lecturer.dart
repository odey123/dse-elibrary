import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';

class Lecturer {
  final String firstName;
  final String lastName;
  final String email;
  final String prefix;
  final String gender;
  final String userId;
  final String preferredAcademicname;
  final String levelCourseAdvisor;
  final String searchText;

  Lecturer({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.prefix,
    required this.gender,
    required this.userId,
    required this.preferredAcademicname,
    required this.levelCourseAdvisor,
    required this.searchText,
  });

  Lecturer.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : firstName = snapshot.data()[firstNameFieldName] ?? '',
        lastName = snapshot.data()[lastNameFieldName] ?? '',
        email = snapshot.data()[emailFieldName] ?? '',
        userId = snapshot.data()[uidFieldName] ?? '',
        prefix = snapshot.data()[prefixFieldName] ?? '',
        gender = snapshot.data()[genderFieldName] ?? '',
        preferredAcademicname =
            snapshot.data()[preferredAcademicNameFieldName] ?? '',
        searchText = snapshot.data()[searchFieldName],
        levelCourseAdvisor = snapshot.data()[levelCourseAdvisorFieldName] ?? '';
}
