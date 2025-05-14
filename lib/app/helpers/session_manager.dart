import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static late SharedPreferences prefs;

  static Future initSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  static String userId = "user_id";
  static String email = "email";
  static String firstName = "firstName";
  static String lastName = "lastName";
  static String gender = "gender";
  static String prefix = "prefix";
  static String role = "role";
  static String level = "level";
  static String levelCourseAdvisor = "level_course_advisor";
  static String preferredAcademicName = "preferred_academic_name";
  static String profileImageUrl = "profile_image_url";

  /// SETTERS
  static void setUserId(String value) {
    SessionManager.prefs.setString(userId, value);
  }

  static void setEmail(String value) {
    SessionManager.prefs.setString(email, value);
  }

  static void setFirstName(String value) {
    SessionManager.prefs.setString(firstName, value);
  }

  static void setLastName(String value) {
    SessionManager.prefs.setString(lastName, value);
  }

  static void setGender(String value) {
    SessionManager.prefs.setString(gender, value);
  }

  static void setPrefix(String value) {
    SessionManager.prefs.setString(prefix, value);
  }

  static void setRole(String value) {
    SessionManager.prefs.setString(role, value);
  }

  static void setLevel(String value) {
    SessionManager.prefs.setString(level, value);
  }

  static void setLevelCourseAdvisor(String value) {
    SessionManager.prefs.setString(levelCourseAdvisor, value);
  }

  static void setPreferredAcademicName(String value) {
    SessionManager.prefs.setString(preferredAcademicName, value);
  }

  static void setProfileImageUrl(String value) {
    SessionManager.prefs.setString(profileImageUrl, value);
  }

  /// GETTERS
  static String? getUserId() {
    return SessionManager.prefs.getString(userId);
  }

  static String? getEmail() {
    return SessionManager.prefs.getString(email);
  }

  static String? getFirstName() {
    return SessionManager.prefs.getString(firstName);
  }

  static String? getLastName() {
    return SessionManager.prefs.getString(lastName);
  }

  static String? getGender() {
    return SessionManager.prefs.getString(gender);
  }

  static String? getPrefix() {
    return SessionManager.prefs.getString(prefix);
  }

  static String? getRole() {
    return SessionManager.prefs.getString(role);
  }

  static String? getLevel() {
    return SessionManager.prefs.getString(level);
  }

  static String? getLevelCourseAdvisor() {
    return SessionManager.prefs.getString(levelCourseAdvisor);
  }

  static String? getPreferredAcademicName() {
    return SessionManager.prefs.getString(preferredAcademicName);
  }

  static String? getProfileImageUrl() {
    return SessionManager.prefs.getString(profileImageUrl);
  }
}
