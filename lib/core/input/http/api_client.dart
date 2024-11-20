import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    Duration delayBetweenRequests = const Duration(milliseconds: 10000),
    int retries = 3,
  }) : dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
            responseType: ResponseType.json,
          ),
        ) {
    dio.interceptors.addAll([
      RetryInterceptor(
        dio: dio,
        retries: retries,
        retryDelays: List.generate(
          retries,
          (retryCount) => Duration(seconds: 2 * (retryCount + 1)),
        ),
      ),
      RateLimitingInterceptor(delayBetweenRequests),
    ]);
  }
}

class RateLimitingInterceptor extends Interceptor {
  final Duration delayBetweenRequests;
  DateTime _lastRequestTime = DateTime.now().subtract(Duration(seconds: 1));

  RateLimitingInterceptor(this.delayBetweenRequests);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final currentTime = DateTime.now();
    final timeSinceLastRequest = currentTime.difference(_lastRequestTime);

    // If the time since the last request is less than the required delay, wait
    if (timeSinceLastRequest < delayBetweenRequests) {
      final waitTime = delayBetweenRequests - timeSinceLastRequest;
      await Future.delayed(waitTime);
    }

    // Update the last request time
    _lastRequestTime = DateTime.now();

    // Proceed with the request
    super.onRequest(options, handler);
  }
}
