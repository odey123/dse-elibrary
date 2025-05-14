import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';

class CloudProfile {
  final String email;
  final String firstName;
  final String lastName;
  final String prefix;
  final String gender;
  final String levelCourseAdvisor;
  final String userId;
  final String level;
  final String role;
  final String preferredAcademicName;
  final String profileImageUrl;

  CloudProfile({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.prefix,
    required this.levelCourseAdvisor,
    required this.userId,
    required this.level,
    required this.role,
    required this.preferredAcademicName,
    required this.profileImageUrl,
  });

  CloudProfile.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : email = snapshot.data()![emailFieldName] ?? '',
        firstName = snapshot.data()![firstNameFieldName] ?? '',
        lastName = snapshot.data()![lastNameFieldName] ?? '',
        prefix = snapshot.data()![prefixFieldName] ?? '',
        gender = snapshot.data()![genderFieldName] ?? '',
        levelCourseAdvisor =
            snapshot.data()![levelCourseAdvisorFieldName] ?? '',
        preferredAcademicName =
            snapshot.data()![preferredAcademicNameFieldName] ?? '',
        level = snapshot.data()![levelFieldName] ?? '',
        role = snapshot.data()![roleFieldName] ?? '',
        userId = snapshot.data()![uidFieldName] ?? '',
        profileImageUrl = snapshot.data()![profileImageUrlFieldName] ?? '';
}
