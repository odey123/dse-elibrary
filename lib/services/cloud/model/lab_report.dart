import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';

class LabReport {
  final String name;
  final String coverUrl;
  final String filePath;

  LabReport({
    required this.name,
    required this.coverUrl,
    required this.filePath,
  });

  LabReport.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()[nameFieldName] ?? '',
        coverUrl = snapshot.data()[coverurlFieldName] ?? '',
        filePath = snapshot.data()[filePathFieldName] ?? '';
}
