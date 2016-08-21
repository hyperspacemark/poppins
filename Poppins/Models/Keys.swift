struct Keys {
  static var dropboxKey: String {
    return Bundle.main.infoDictionary?["DropboxKey"] as? String ?? ""
  }

  static var dropboxSecret: String {
    return Bundle.main.infoDictionary?["DropboxSecret"] as? String ?? ""
  }
}
