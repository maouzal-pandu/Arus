extension StringX on String {
  String get upperFirst =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);
}
