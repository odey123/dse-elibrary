import 'dart:developer';
import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:systems_app/services/cloud/model/course.dart';
import 'package:systems_app/services/cloud/storage/cloud_storage_exception.dart';
part 'storage.actions.g.dart';

@riverpod
class StorageAsyncNotifier extends _$StorageAsyncNotifier {
  @override
  build() {
    return null;
  }

  FirebaseStorage initialize() => FirebaseStorage.instance;

  Future<String> addMaterialToCourse({
    required Course course,
    required String uid,
    required String filename,
    required Uint8List bytes,
    required String path,
  }) async {
    try {
      final Reference storageReference =
          initialize().ref().child('$uid/${course.courseCode}/$filename');

      UploadTask uploadTask;

      if (kIsWeb) {
        // For Flutter Web, use the bytes
        uploadTask = storageReference.putData(bytes);
      } else {
        // For Mobile/Desktop, use the file path
        final file = io.File(path);
        uploadTask = storageReference.putFile(file);
      }

      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } on Exception catch (e) {
      log('$e');
      throw ErrorUploadingFile();
    }
  }

  Future<String> addProjectPaper({
    required String title,
    required String path,
    required Uint8List bytes,
    required String projectSupervisorUid,
  }) async {
    try {
      final Reference storageReference = initialize()
          .ref()
          .child('$projectSupervisorUid/projectPapers/$title');

      UploadTask uploadTask;

      if (kIsWeb) {
        // For Flutter Web, use the bytes
        uploadTask = storageReference.putData(bytes);
      } else {
        // For Mobile/Desktop, use the file path
        final file = io.File(path);
        uploadTask = storageReference.putFile(file);
      }

      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } on Exception catch (e) {
      log('$e');
      throw ErrorUploadingFile();
    }
  }

  Future<String> addBook({
    required String title,
    required String ext,
    required String path,
    required Uint8List bytes,
    required String projectSupervisorUid,
  }) async {
    try {
      final Reference storageReference =
          initialize().ref().child('$projectSupervisorUid/books/$title.$ext');

      UploadTask uploadTask;

      if (kIsWeb) {
        // For Flutter Web, use the bytes
        uploadTask = storageReference.putData(bytes);
      } else {
        // For Mobile/Desktop, use the file path
        final file = io.File(path);
        uploadTask = storageReference.putFile(file);
      }

      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } on Exception catch (e) {
      log('$e');
      throw ErrorUploadingFile();
    }
  }

  Future<String> addBookCover({
    required String title,
    required String ext,
    required String path,
    required Uint8List bytes,
    required String projectSupervisorUid,
  }) async {
    try {
      final Reference storageReference = initialize()
          .ref()
          .child('$projectSupervisorUid/booksCover/$title.$ext');

      UploadTask uploadTask;

      if (kIsWeb) {
        // For Flutter Web, use the bytes
        uploadTask = storageReference.putData(bytes);
      } else {
        // For Mobile/Desktop, use the file path
        final file = io.File(path);
        uploadTask = storageReference.putFile(file);
      }

      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } on Exception catch (e) {
      log('$e');
      throw ErrorUploadingFile();
    }
  }

  Future<String> uploadProfileImage({
    required String ext,
    required String path,
    required Uint8List bytes,
    required String uid,
  }) async {
    try {
      final Reference storageReference =
          initialize().ref().child('profileImage/$uid/profile.$ext');

      UploadTask uploadTask;

      if (kIsWeb) {
        // For Flutter Web, use the bytes
        uploadTask = storageReference.putData(bytes);
      } else {
        // For Mobile/Desktop, use the file path
        final file = io.File(path);
        uploadTask = storageReference.putFile(file);
      }

      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } on Exception catch (e) {
      log('$e');
      throw ErrorUploadingFile();
    }
  }
}
