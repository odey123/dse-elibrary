import 'dart:developer';

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
}
