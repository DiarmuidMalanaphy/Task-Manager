class ReturnError {
  late final bool _success;
  late final String _errorMessage;

  ReturnError(this._success, this._errorMessage);

  bool get success {
    return _success;
  }

  String get message {
    return _errorMessage;
  }
}
