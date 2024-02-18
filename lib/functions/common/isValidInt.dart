bool isValidIntValue(String s) {
  return int.tryParse(s) != null;
}

int getInt(String s) {
  if (isValidIntValue(s)) return int.parse(s);
  return 0;
}
