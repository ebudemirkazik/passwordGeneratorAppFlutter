import 'dart:math';
import '../models/password_options.dart';

class PasswordGeneratorService {
  static String generate(PasswordOptions option) {
    const String upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()_-+=<>?/{}[]|';

    String chars = '';

    if (option.includeUppercase) chars += upperCaseLetters;
    if (option.includeLowercase) chars += lowerCaseLetters;
    if (option.includeNumbers) chars += numbers;
    if (option.includeSymbols) chars += symbols;

    if (chars.isEmpty) return '';

    Random random = Random.secure();
    return List.generate(option.length, (index) {
      int randIndex = random.nextInt(chars.length);
      return chars[randIndex];
    }).join('');
  }
}
