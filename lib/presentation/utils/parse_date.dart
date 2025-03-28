DateTime parseDate(String date) {
  // Split the date string into parts
  List<String> parts = date.split('/');
  if (parts.length != 3) {
    throw FormatException('Invalid date format. Expected dd/mm/yyyy');
  }

  // Parse the day, month, and year from the string parts
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  // Create a DateTime object using the parsed values
  return DateTime(year, month, day);
}