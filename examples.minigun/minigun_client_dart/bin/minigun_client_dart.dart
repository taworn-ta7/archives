import 'package:minigun_client_dart/minigun_client.dart';
import 'constants.dart';

void main() async {
  final client = Client(baseUri: Constants.baseUri);

  final result = await client.login(
    username: Constants.username,
    password: Constants.password,
  );

  print('login result: ${result.isOk()}');

  await client.logout();
}
