import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';

class Course {
  final String unit;
  final String courseName;
  final String courseCode;
  final String courseId;
  final String ownerName;
  final String ownerUid;
  final Map<String, String> weekTopics;
  final Map<String, String> materials;

  Course({
    required this.courseName,
    required this.courseCode,
    required this.courseId,
    required this.ownerName,
    required this.ownerUid,
    required this.unit,
    required this.weekTopics,
    required this.materials,
  });

  Course.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : courseName = snapshot.data()[courseNameFieldName] ?? '',
        courseCode = snapshot.data()[courseCodeFieldName] ?? '',
        courseId = snapshot.data()[courseIdFieldName] ?? '',
        unit = snapshot.data()[unitFieldName] ?? '',
        ownerName = snapshot.data()[ownerNameFieldName] ?? '',
        ownerUid = snapshot.data()[ownerUidFieldName] ?? '',
        weekTopics =
            (snapshot.data()[weekTopicFieldName] as Map<String, dynamic>?)
                    ?.cast<String, String>() ??
                {},
        materials =
            (snapshot.data()[materialFieldName] as Map<String, dynamic>?)
                    ?.cast<String, String>() ??
                {};
}
