import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';

class ProjectPaper {
  final String id;
  final String title;
  final String writtenBy;
  final String paperUrl;
  final String coordinatorName;

  ProjectPaper({
    required this.id,
    required this.title,
    required this.writtenBy,
    required this.paperUrl,
    required this.coordinatorName,
  });

  ProjectPaper.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.data()[idFieldName] ?? '',
        title = snapshot.data()[titleFieldName] ?? '',
        writtenBy = snapshot.data()[writtenByFieldName] ?? '',
        paperUrl = snapshot.data()[paperUrlFieldName] ?? '',
        coordinatorName = snapshot.data()[coordinatorFieldName] ?? '';
}
