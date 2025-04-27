import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';

class HOD {
  final String firstName;
  final String lastName;
  final String email;
  final String prefix;
  final String gender;
  final String preferredAcademicname;

  HOD({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.prefix,
    required this.gender,
    required this.preferredAcademicname,
  });

  HOD.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : firstName = snapshot.data()[firstNameFieldName] ?? '',
        lastName = snapshot.data()[lastNameFieldName] ?? '',
        email = snapshot.data()[emailFieldName] ?? '',
        prefix = snapshot.data()[prefixFieldName] ?? '',
        gender = snapshot.data()[genderFieldName] ?? '',
        preferredAcademicname =
            snapshot.data()[preferredAcademicNameFieldName] ?? '';
}
