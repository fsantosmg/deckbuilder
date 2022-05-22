import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import 'interceptors/logging_interceptor.dart';


final Client client =
InterceptedClient.build(interceptors: [LoggingInterceptor()]);
