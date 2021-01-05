class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    Object message = this.message;
    if (message == null) return "HttpException";
    return message;
  }

  // String toString() {
  //   return 'HttpException: $message';
    // return super.toString(); //Instance of HttpExeption
  // }
}
