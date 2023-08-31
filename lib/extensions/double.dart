extension CustomDouble on double {
  String chapterManga([bool short = false]) {
    final prefix = short ? "Chapter" : "Ch";
    final regex = RegExp(r"([.]*0+)(?!.*\d)");

    if (this > -1) {
      return "$prefix $this".replaceAll(regex, "");
    } else {
      return "Oneshot";
    }
  }
}
