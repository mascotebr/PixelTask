class HelpUtil {
  static bool isToday(DateTime? date) {
    if (date != null) {
      if (date.day == DateTime.now().day &&
          date.month == DateTime.now().month &&
          date.year == DateTime.now().year) {
        return false;
      }
    }
    return true;
  }
}
