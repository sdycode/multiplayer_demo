
  bool validatePhoneNumber(String phoneNumber) {
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    return digitsOnly.length >=
        10; // Adjust the condition based on your validation criteria
  }