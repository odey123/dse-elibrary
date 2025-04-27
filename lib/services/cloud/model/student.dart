import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';

class Student {
  final String firstName;
  final String lastName;
  final String email;
  final String level;
  final String gender;
  final String uid;

  Student({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.level,
    required this.gender,
    required this.uid,
  });

  Student.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : firstName = snapshot.data()[firstNameFieldName] ?? '',
        lastName = snapshot.data()[lastNameFieldName] ?? '',
        email = snapshot.data()[emailFieldName] ?? '',
        level = snapshot.data()[levelFieldName] ?? '',
        gender = snapshot.data()[genderFieldName] ?? '',
        uid = snapshot.data()[uidFieldName] ?? '';
}
