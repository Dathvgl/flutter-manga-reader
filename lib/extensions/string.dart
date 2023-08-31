extension CustomString on String {
  String toCapitalized() {
    final text = '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    return length > 0 ? text : '';
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
