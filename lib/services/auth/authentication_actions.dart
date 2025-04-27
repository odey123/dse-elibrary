import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:systems_app/services/auth/auth_exception.dart';
import 'package:systems_app/services/auth/auth_state.dart';
part 'authentication_actions.g.dart';

@riverpod
class AuthenticationAsyncNotifier extends _$AuthenticationAsyncNotifier {
  @override
  User? build() {
    return null;
  }

  FirebaseAuth initialize() => FirebaseAuth.instance;

  User? get currentUser {
    final user = initialize().currentUser;
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<UserCredential> reauthenticate({
    required AuthCredential credential,
  }) async {
    try {
      return await currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-mismatch') {
        throw UserMismatchAuthException();
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'invalid-credential') {
        throw InvalidCredentialAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkRequestFailedAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<User> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await setSessionPersistence();
      await initialize().signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'invalid-credential') {
        throw InvalidCredentialAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestAuthException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledAuthException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkRequestFailedAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<IdTokenResult> getUserToken() async {
    final user = currentUser;
    if (user != null) {
      IdTokenResult idTokenResult = await user.getIdTokenResult();
      return idTokenResult;
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> logOut() async {
    final user = initialize().currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<bool> checkIfAdmin() async {
    final user = initialize().currentUser;
    if (user != null) {
      final idTokenResult = await user.getIdTokenResult(true);
      final isAdmin = idTokenResult.claims?['admin'] ?? false;

      if (isAdmin) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await initialize().sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'user-not-found':
          throw UserNotFoundAuthException();
        case 'network-request-failed':
          throw NetworkRequestFailedAuthException();
        default:
          throw GenericAuthException();
      }
    }
  }

  AuthState appInitializer() {
    final user = initialize().currentUser;
    if (user == null) {
      return AuthState.loggedOut;
    } else {
      return AuthState.loggedIn;
    }
  }

  Future<void> setSessionPersistence() async {
    if (kIsWeb) {
      await initialize().setPersistence(Persistence.SESSION);
    }
  }
}
