extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension Range on int {
  bool isBetween(int from, int to) {
    return from <= this && this <= to;
  }
}
