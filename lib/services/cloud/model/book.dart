import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String bookUrl;
  final String coverUrl;
  final String ownerUid;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.bookUrl,
    required this.coverUrl,
    required this.ownerUid,
  });

  Book.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.data()[idFieldName] ?? '',
        title = snapshot.data()[titleFieldName] ?? '',
        author = snapshot.data()[authorFieldName] ?? '',
        bookUrl = snapshot.data()[bookUrlFieldName] ?? '',
        coverUrl = snapshot.data()[coverUrlFieldName] ?? '',
        ownerUid = snapshot.data()[ownerUidFieldName] ?? '';
}
