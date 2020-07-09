```Dart
import 'package:ali_cloudapi_sign/ali_cloudapi_sign.dart';

void main() async {
  Map<String, dynamic> headers =
        AliSign.creatAliGatewaySign("get", Uri.parse(url), query);

}
```