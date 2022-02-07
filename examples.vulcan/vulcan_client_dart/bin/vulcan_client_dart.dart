import 'package:vulcan_client_dart/vulcan_client.dart';
import 'constants.dart';

void main() async {
  final client = AuthenClient(baseUri: Constants.baseUri);

  final result = await client.login(
    username: Constants.username,
    password: Constants.password,
  );

  print('login result: ${result.isOk()}');

  await client.logout();
}
