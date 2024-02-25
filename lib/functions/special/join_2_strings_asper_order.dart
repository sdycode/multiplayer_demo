String join2StringsAsperOrder(String str1, String str2) {
  if (str1.compareTo(str2) < 0) {
    return "${str1}_$str2";
  } else {
    return "${str2}_$str1";
  }
}
