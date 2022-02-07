import 'dart:convert';
import 'package:http/http.dart' as http;
import 'client.dart';
import 'mix_result.dart';

Future<MixResult> userRegister(
  Client client, {
  required String username,
  required String displayName,
  required String password,
  required String confirmPassword,
}) async {
  final json = {
    'user': {
      'username': username,
      'displayName': displayName,
      'password': password,
      'confirmPassword': confirmPassword,
    },
  };
  return await client.call(
    MethodType.post,
    client.getUri('user/register'),
    body: jsonEncode(json),
  );
}

Future<MixResult> userUnregister(
  Client client,
) async {
  return await client.call(
    MethodType.put,
    client.getUri('user/unregister'),
  );
}

Future<MixResult> userUpdateDisplayName(
  Client client, {
  required String displayName,
}) async {
  final json = {
    'user': {
      'displayName': displayName,
    },
  };
  return await client.call(
    MethodType.put,
    client.getUri('user/update/displayName'),
    body: jsonEncode(json),
  );
}

Future<MixResult> userUpdatePassword(
  Client client, {
  required String password,
  required String confirmPassword,
}) async {
  final json = {
    'user': {
      'password': password,
      'confirmPassword': confirmPassword,
    },
  };
  return await client.call(
    MethodType.put,
    client.getUri('user/update/password'),
    body: jsonEncode(json),
  );
}

Future<MixResult> userProfileIconUpload(
  Client client, {
  required http.MultipartFile file,
}) async {
  final req = client.prepareMultipart(
    'POST',
    client.getUri('user/profile/icon'),
  );
  req.files.add(file);
  return await client.callMultipart(req);
}

Future<MixResult> userProfileIconGet(
  Client client,
) async {
  return await client.callRaw(
    MethodType.get,
    client.getUri('user/profile/icon'),
  );
}

Future<MixResult> userProfileIconRemove(
  Client client,
) async {
  return await client.call(
    MethodType.delete,
    client.getUri('user/profile/icon'),
  );
}
