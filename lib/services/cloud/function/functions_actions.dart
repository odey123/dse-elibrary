import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:systems_app/services/cloud/function/function_exception.dart';
part 'functions_actions.g.dart';

@riverpod
class FunctionsAsyncNotifier extends _$FunctionsAsyncNotifier {
  @override
  build() {
    return null;
  }

  FirebaseFunctions initialize() => FirebaseFunctions.instance;

  Future<void> onboardStudent({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String level,
    required String adminUId,
  }) async {
    try {
      final response = await initialize().httpsCallable('onboardStudent').call({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "gender": gender,
        "level": level,
        "UId": adminUId,
      });

      log("Success: ${response.data['message']}");
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "unauthenticated":
          throw UnAuthenticatedFunctionException();
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "already-exists":
          throw AlreadyExistsFunctionException();
        case "invalid-email":
          throw InvalidArgumentFunctionException();
        case "failed-precondition":
          throw FailedPreconditionFunctionException();
        case "weak-password":
          throw WeakPasswordFunctionException();
        case "deadline-exceeded":
          throw DeadlineExceededFunctionException();
        case "resource-exhausted":
          throw ResourceExhaustedFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (_) {
      throw GenericFunctionException();
    }
  }

  Future<void> onboardStudentsFromCSV({
    required List<Map<String, dynamic>> students,
    required String adminUId,
  }) async {
    try {
      final response =
          await initialize().httpsCallable('onboardStudentsFromCSV').call({
        "students": students,
        "UId": adminUId,
      });

      log("Success: ${response.data['message']}");
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "unauthenticated":
          throw UnAuthenticatedFunctionException();
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "already-exists":
          throw AlreadyExistsFunctionException();
        case "invalid-email":
          throw InvalidArgumentFunctionException();
        case "failed-precondition":
          throw FailedPreconditionFunctionException();
        case "weak-password":
          throw WeakPasswordFunctionException();
        case "deadline-exceeded":
          throw DeadlineExceededFunctionException();
        case "resource-exhausted":
          throw ResourceExhaustedFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (_) {
      throw GenericFunctionException();
    }
  }

  Future<void> onboardLecturer({
    required String firstName,
    required String lastName,
    required String email,
    required String preferredAcademicName,
    required String prefix,
    required String levelCourseAdvisor,
    required String gender,
    required String adminUId,
  }) async {
    try {
      final response =
          await initialize().httpsCallable('onboardLecturer').call({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "preferredAcademicName": preferredAcademicName,
        "prefix": prefix,
        "levelCourseAdvisor": levelCourseAdvisor,
        "gender": gender,
        "UId": adminUId,
      });

      log("Success: ${response.data['message']}");
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "unauthenticated":
          throw UnAuthenticatedFunctionException();
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "already-exists":
          throw AlreadyExistsFunctionException();
        case "invalid-email":
          throw InvalidArgumentFunctionException();
        case "failed-precondition":
          throw FailedPreconditionFunctionException();
        case "weak-password":
          throw WeakPasswordFunctionException();
        case "deadline-exceeded":
          throw DeadlineExceededFunctionException();
        case "resource-exhausted":
          throw ResourceExhaustedFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (_) {
      throw GenericFunctionException();
    }
  }

  Future<void> onboardHod({
    required String firstName,
    required String lastName,
    required String email,
    required String preferredAcademicName,
    required String prefix,
    required String levelCourseAdvisor,
    required String gender,
    required String adminUId,
  }) async {
    try {
      final response = await initialize().httpsCallable('onboardHod').call({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "preferredAcademicName": preferredAcademicName,
        "prefix": prefix,
        "levelCourseAdvisor": levelCourseAdvisor,
        "gender": gender,
        "UId": adminUId,
      });

      log("Success: ${response.data['message']}");
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "unauthenticated":
          throw UnAuthenticatedFunctionException();
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "already-exists":
          throw AlreadyExistsFunctionException();
        case "invalid-email":
          throw InvalidArgumentFunctionException();
        case "failed-precondition":
          throw FailedPreconditionFunctionException();
        case "weak-password":
          throw WeakPasswordFunctionException();
        case "deadline-exceeded":
          throw DeadlineExceededFunctionException();
        case "resource-exhausted":
          throw ResourceExhaustedFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (_) {
      throw GenericFunctionException();
    }
  }

  Future<void> removeUser({
    required List<String> uids,
    required String adminUId,
  }) async {
    try {
      final response =
          await initialize().httpsCallable('deleteUsersFromAuth').call({
        "uids": uids,
        "UId": adminUId,
      });
      if (response.data != null && response.data['message'] != null) {
        log("Success: ${response.data['message']}");
      } else {
        log("Unexpected response format.");
      }
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "deadline-exceeded":
          throw DeadlineExceededFunctionException();
        case "resource-exhausted":
          throw ResourceExhaustedFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (_) {
      throw GenericFunctionException();
    }
  }

  Future<void> addCourse({
    required String courseName,
    required String courseCode,
    required String unit,
    required String level,
    required String semester,
    required String ownerUid,
    required String ownerName,
  }) async {
    try {
      final response = await initialize().httpsCallable('addCourse').call({
        "courseName": courseName,
        "courseCode": courseCode,
        "unit": unit,
        "level": level,
        "semester": semester,
        "ownerUid": ownerUid,
        "ownerName": ownerName,
      });

      log("Success: ${response.data['message']}");
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "unauthenticated":
          throw UnAuthenticatedFunctionException();
        case "already-exists":
          throw AlreadyExistsFunctionException();
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "deadline-exceeded":
          throw DeadlineExceededFunctionException();
        case "resource-exhausted":
          throw ResourceExhaustedFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (_) {
      throw GenericFunctionException();
    }
  }

  Future<Uint8List?> getPdfBytes({
    required String filePath,
    required String requesterUid,
  }) async {
    try {
      final response = await initialize().httpsCallable('getPdfBase64').call({
        "filePath": filePath,
        "requesterUid": requesterUid,
      });

      final base64Data = response.data['base64'];
      return base64Decode(base64Data); // Converts Base64 to Uint8List
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "unauthenticated":
          throw UnAuthenticatedFunctionException();
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "not-found":
          throw NotFoundFunctionException();
        case "deadline-exceeded":
          throw DeadlineExceededFunctionException();
        case "resource-exhausted":
          throw ResourceExhaustedFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (_) {
      throw GenericFunctionException();
    }
  }

  Future<Uint8List?> getPdfBytesFromUrl({
    required String fileUrl,
    required String requesterUid,
  }) async {
    try {
      final response =
          await initialize().httpsCallable('getPdfBase64FromUrl').call({
        "fileUrl": fileUrl,
        "requesterUid": requesterUid,
      });

      final base64Data = response.data['base64'];
      return base64Decode(base64Data); // Converts Base64 to Uint8List
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "unauthenticated":
          throw UnAuthenticatedFunctionException();
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "not-found":
          throw NotFoundFunctionException();
        case "deadline-exceeded":
          throw DeadlineExceededFunctionException();
        case "resource-exhausted":
          throw ResourceExhaustedFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (_) {
      throw GenericFunctionException();
    }
  }

  Future<Uint8List?> exportStudentsToCSv({
    required String uid,
  }) async {
    try {
      final response =
          await initialize().httpsCallable('exportStudentsToCSV').call({
        "uid": uid,
      });
      final base64Csv = response.data['base64Csv'];

      return base64Decode(base64Csv);
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "not-found":
          throw EmptyReportFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (e) {
      log('$e');
      throw GenericFunctionException();
    }
  }

  Future<Uint8List?> exportLecturersToCSv({
    required String uid,
  }) async {
    try {
      final response =
          await initialize().httpsCallable('exportLecturersToCSV').call({
        "uid": uid,
      });
      final base64Csv = response.data['base64Csv'];

      return base64Decode(base64Csv);
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "not-found":
          throw EmptyReportFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (e) {
      log('$e');
      throw GenericFunctionException();
    }
  }

  Future<Uint8List?> exportHODToCSv({
    required String uid,
  }) async {
    try {
      final response = await initialize().httpsCallable('exportHODToCSV').call({
        "uid": uid,
      });
      final base64Csv = response.data['base64Csv'];

      return base64Decode(base64Csv);
    } on FirebaseFunctionsException catch (e) {
      switch (e.code) {
        case "permission-denied":
          throw PermissionDeniedFunctionException();
        case "invalid-argument":
          throw InvalidArgumentFunctionException();
        case "not-found":
          throw EmptyReportFunctionException();
        default:
          throw GenericFunctionException();
      }
    } catch (e) {
      log('$e');
      throw GenericFunctionException();
    }
  }
}
