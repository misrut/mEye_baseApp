import 'package:misrut_core/misrut_core.dart';

class MyExceptionHandler implements IMiExceptionHandler {
  @override
  String get statusCodeKey => 'statusCode';

  @override
  String get statusMessageKey => 'message';

  @override
  String get successCode => 'CF200';

  @override
  String get errorCode => '';

  static void handleSilentException(dynamic exception) {
    print(exception);
  }

  static void handleException(dynamic exception) {
    print(exception);
  }
  
  @override
  void handleErrorResponse(Map<String, dynamic>? data) {
    // TODO: implement handleErrorResponse
  }
}
