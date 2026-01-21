extension RegexExt on String {

  bool validateEmail() => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this);


  bool validatePhone() => RegExp(r'^(\+|00)?[0-9]+$')
      .hasMatch(this);
}
