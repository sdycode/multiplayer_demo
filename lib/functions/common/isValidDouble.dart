isValidDoubleValue(String v) {
  return double.tryParse(v) != null;
}

double getDoubleValue(String v) {
  if (isValidDoubleValue(v)) {
    return double.parse(v);
  }
  return 0;
}
