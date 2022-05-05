class AppData {
  static final AppData _appData = new AppData._internal();

  String userLogin;
  String userAdresse;
  String userPostalCode;
  String userBirth;
  String userVille;
  String userPassword;
  String userID;

  String itemID;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
