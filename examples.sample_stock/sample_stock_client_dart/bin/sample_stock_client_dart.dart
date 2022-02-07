import 'package:sample_stock_client_dart/sample_stock_client.dart';
import 'constants.dart';

void main() async {
  final client = SampleStockClient(baseUri: Constants.baseUri);

  final result = await client.login(
    username: Constants.username,
    password: Constants.password,
  );

  print('login result: ${result.isOk()}');
}
