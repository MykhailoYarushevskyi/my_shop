class CommonException implements Exception {
  final String message;
  CommonException(this.message);

  @override
  String toString() {
    Object message = this.message;
    if (message == null) return "CommonException";
    return message;
  }

  // String toString() {
  //   return 'CommonException: $message';
    // return super.toString();//Instance of CommonException
  // }
}
