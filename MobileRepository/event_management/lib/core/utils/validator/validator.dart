class Validators {
  //Private Constructor to restrict creating instance of class
  Validators._();
  static String? emptyFieldValidator(String? value) => (value ?? '').trim().isEmpty ? 'Field Required' : null;

  static String? emailFieldController(String? value) {
    final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if ((value ?? '').trim().isEmpty) {
      return 'Field Required';
    }
    if (emailRegExp.hasMatch(value!)) return null;
    return 'Invalid Email Address';
  }

  static String? cityNameValidator(String? value) {
    final emptyFieldValidator = Validators.emptyFieldValidator(value);
    if (emptyFieldValidator == null) {
      if (value!.trim().length < 4) {
        return "Please enter at least 4 digits";
      }
      return null;
    } else {
      return emptyFieldValidator;
    }
  }
}
