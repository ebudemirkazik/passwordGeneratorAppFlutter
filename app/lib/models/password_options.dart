class PasswordOptions {
  int length;
  bool includeUppercase;
  bool includeLowercase;
  bool includeNumbers;
  bool includeSymbols;

  PasswordOptions({
    required this.length,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
  });
}
