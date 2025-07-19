import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:systems_app/services/cloud/database/cloud_database_constants.dart';
import 'package:systems_app/services/cloud/database/cloud_database_exception.dart';
import 'package:systems_app/services/cloud/database/cloud_profile.dart';
import 'package:systems_app/services/cloud/model/book.dart';
import 'package:systems_app/services/cloud/model/course.dart';
import 'package:systems_app/services/cloud/model/hand_book.dart';
import 'package:systems_app/services/cloud/model/lab_manual.dart';
import 'package:systems_app/services/cloud/model/lab_report.dart';
import 'package:systems_app/services/cloud/model/lecturer.dart';
import 'package:systems_app/services/cloud/model/project_paper.dart';
import 'package:systems_app/services/cloud/model/student.dart';
import 'package:systems_app/utils/strings.dart';
part 'database_actions.g.dart';

@riverpod
class DatabaseAsyncNotifier extends _$DatabaseAsyncNotifier {
  @override
  build() {
    return null;
  }

  FirebaseFirestore initialize() => FirebaseFirestore.instance;

  Stream<CloudProfile> getUserProfile({
    required String ownerUserId,
    required String role,
  }) {
    if (role == lecturerRole) {
      final profile = initialize()
          .collection(lecturersCollection)
          .doc(ownerUserId)
          .snapshots();
      return profile.map((snapshot) => CloudProfile.fromSnapshot(snapshot));
    } else {
      final profile = initialize()
          .collection(studentsCollection)
          .doc(ownerUserId)
          .snapshots();
      return profile.map((snapshot) => CloudProfile.fromSnapshot(snapshot));
    }
  }

  Future<void> editLecturerProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String preferredAcademicName,
    required String prefix,
  }) async {
    final profile =
        await initialize().collection(lecturersCollection).doc(userId).get();
    await profile.reference.update({
      firstNameFieldName: firstName,
      lastNameFieldName: lastName,
      preferredAcademicNameFieldName: preferredAcademicName,
      prefixFieldName: prefix,
    });

    final courseCollection = await initialize()
        .collection(coursesCollection)
        .where(ownerUidFieldName, isEqualTo: userId)
        .get();

    final batch = initialize().batch();
    for (var doc in courseCollection.docs) {
      batch.update(doc.reference, {
        ownerNameFieldName: preferredAcademicName,
      });
    }
    await batch.commit();
  }

  Future<void> editStudentProfile({
    required String userId,
    required String firstName,
    required String lastName,
  }) async {
    final profile =
        await initialize().collection(studentsCollection).doc(userId).get();
    await profile.reference.update({
      firstNameFieldName: firstName,
      lastNameFieldName: lastName,
    });
  }

  Stream<List<Student>> getAllStudents() {
    final collection = initialize().collection(studentsCollection).snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => Student.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<Lecturer>> getAllLecturers() {
    final collection = initialize().collection(lecturersCollection).snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => Lecturer.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<Lecturer>> getHod() {
    final collection = initialize().collection(hod).snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => Lecturer.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<Course>> getAllCourses({
    String? level,
  }) {
    if (level != null) {
      final collection = initialize()
          .collection(coursesCollection)
          .where(levelFieldName, isEqualTo: level)
          .snapshots();
      return collection.map((event) {
        if (event.docs.isNotEmpty) {
          return event.docs.map((doc) => Course.fromSnapshot(doc)).toList();
        } else {
          return [];
        }
      });
    } else {
      final collection = initialize().collection(coursesCollection).snapshots();
      return collection.map((event) {
        if (event.docs.isNotEmpty) {
          return event.docs.map((doc) => Course.fromSnapshot(doc)).toList();
        } else {
          return [];
        }
      });
    }
  }

  Stream<List<Course>> getAllCoursesPerSemester({
    required String level,
    required String semester,
  }) {
    final collection = initialize()
        .collection(coursesCollection)
        .where(levelFieldName, isEqualTo: level)
        .where(semesterFieldName, isEqualTo: semester)
        .snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => Course.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }

  Future<void> addTopicToCourse({
    required String courseId,
    required String courseCode,
    required String topicName,
    required String topicWeek,
  }) async {
    final courseCollection = await initialize()
        .collection(coursesCollection)
        .where(courseIdFieldName, isEqualTo: courseId)
        .where(courseCodeFieldName, isEqualTo: courseCode)
        .get();

    final courseDoc = courseCollection.docs.first;
    final data = courseDoc.data();
    final Map<String, dynamic> weekMap = data[weekTopicFieldName] ?? {};
    if (weekMap.containsKey(topicWeek)) {
      throw TopicWeekAlreadySetException();
    } else {
      await courseDoc.reference.update({
        '$weekTopicFieldName.$topicWeek': topicName,
      });
    }
  }

  Future<void> addMaterialToCourse({
    required String courseId,
    required String courseCode,
    required String materialName,
    required String materialUrl,
  }) async {
    final courseCollection = await initialize()
        .collection(coursesCollection)
        .where(courseIdFieldName, isEqualTo: courseId)
        .where(courseCodeFieldName, isEqualTo: courseCode)
        .get();

    final courseDoc = courseCollection.docs.first;
    await courseDoc.reference.update({
      '$materialFieldName.$materialName': materialUrl,
    });
  }

  Future<void> addProjectPaper({
    required String title,
    required String writtenBy,
    required String coordinatorName,
    required String coordinatorUid,
    required String paperUrl,
    required String id,
  }) async {
    final collection = initialize().collection(projectPapersCollection);
    await collection.add({
      titleFieldName: title,
      writtenByFieldName: writtenBy,
      coordinatorNameFieldName: coordinatorName,
      coordinatorUidFieldName: coordinatorUid,
      paperUrlFieldName: paperUrl,
      idFieldName: id,
    });
  }

  Future<void> addBook({
    required String title,
    required String author,
    required String ownerUid,
    required String coverUrl,
    required String bookUrl,
    required String category,
    required String id,
  }) async {
    final collection = initialize().collection(booksCollection);
    await collection.add({
      titleFieldName: title,
      authorFieldName: author,
      ownerUidFieldName: ownerUid,
      coverUrlFieldName: coverUrl,
      bookUrlFieldName: bookUrl,
      categoryFieldName: category,
      idFieldName: id,
    });
  }

  Stream<List<ProjectPaper>> getAllProjectPapers() {
    final collection =
        initialize().collection(projectPapersCollection).snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => ProjectPaper.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<Book>> getAllBooks() {
    final collection = initialize().collection(booksCollection).snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => Book.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }

  Stream<Map<String, String>> streamCourseTopics({
    required String courseId,
    required String courseCode,
  }) {
    final query = initialize()
        .collection(coursesCollection)
        .where(courseIdFieldName, isEqualTo: courseId)
        .where(courseCodeFieldName, isEqualTo: courseCode)
        .snapshots();

    return query.map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) return {};

      final data = querySnapshot.docs.first.data();
      final Map<String, dynamic> weekMap =
          Map<String, dynamic>.from(data[weekTopicFieldName] ?? {});

      return weekMap.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    });
  }

  Stream<Map<String, String>> streamCourseMaterials({
    required String courseId,
    required String courseCode,
  }) {
    final query = initialize()
        .collection(coursesCollection)
        .where(courseIdFieldName, isEqualTo: courseId)
        .where(courseCodeFieldName, isEqualTo: courseCode)
        .snapshots();

    return query.map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) return {};

      final data = querySnapshot.docs.first.data();
      final Map<String, dynamic> weekMap =
          Map<String, dynamic>.from(data[materialFieldName] ?? {});

      return weekMap.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    });
  }

  Stream<List<Course>> getLecturerCourses({
    required String ownerUid,
    String? semester,
  }) {
    if (semester != null) {
      final collection = initialize()
          .collection(coursesCollection)
          .where(semesterFieldName, isEqualTo: semester)
          .where(ownerUidFieldName, arrayContains: ownerUid)
          .snapshots();
      return collection.map((event) {
        if (event.docs.isNotEmpty) {
          return event.docs.map((doc) => Course.fromSnapshot(doc)).toList();
        } else {
          return [];
        }
      });
    } else {
      final collection = initialize()
          .collection(coursesCollection)
          .where(ownerUidFieldName, arrayContains: ownerUid)
          .snapshots();
      return collection.map((event) {
        if (event.docs.isNotEmpty) {
          return event.docs.map((doc) => Course.fromSnapshot(doc)).toList();
        } else {
          return [];
        }
      });
    }
  }

  Future<void> addImageUrlToUserProfile({
    required String userId,
    required String profileImageUrl,
    required String role,
  }) async {
    if (role == lecturerRole) {
      final profile =
          await initialize().collection(lecturersCollection).doc(userId).get();
      await profile.reference.update({
        profileImageUrlFieldName: profileImageUrl,
      });
    } else {
      final profile =
          await initialize().collection(studentsCollection).doc(userId).get();
      await profile.reference.update({
        profileImageUrlFieldName: profileImageUrl,
      });
    }
    final courseCollection = await initialize()
        .collection(coursesCollection)
        .where(ownerUidFieldName, isEqualTo: userId)
        .get();

    final batch = initialize().batch();
    for (var doc in courseCollection.docs) {
      batch.update(doc.reference, {
        profileImageUrlFieldName: profileImageUrl,
      });
    }
    await batch.commit();
  }

  Stream<List<HandBook>> getAllHandbook() {
    final collection = initialize()
        .collection(accreditationCollection)
        .where(typeFieldName, isEqualTo: handbook)
        .snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => HandBook.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<LabReport>> getAllLabReport() {
    final collection = initialize()
        .collection(accreditationCollection)
        .where(typeFieldName, isEqualTo: labReport)
        .snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => LabReport.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<LabManual>> getAllLabManual() {
    final collection = initialize()
        .collection(accreditationCollection)
        .where(typeFieldName, isEqualTo: labManual)
        .snapshots();
    return collection.map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map((doc) => LabManual.fromSnapshot(doc)).toList();
      } else {
        return [];
      }
    });
  }
}
