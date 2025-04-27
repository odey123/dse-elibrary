import 'dart:math';

String generateReference() {
  final random = Random();

  String randomNumbers = '';
  for (int i = 0; i < 9; i++) {
    randomNumbers += random.nextInt(10).toString();
  }

  return randomNumbers;
}
