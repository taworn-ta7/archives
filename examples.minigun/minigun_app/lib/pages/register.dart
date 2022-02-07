import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:minigun_client_dart/minigun_client.dart';
import '../logic.dart';
import '../ui.dart';

/// RegisterPage class.
class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

/// _RegisterState internal class.
class _RegisterState extends State<RegisterPage> {
  static final log = Logger('RegisterPage');
  final logic = Logic.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameText;
  late TextEditingController _displayNameText;
  late TextEditingController _passwordText;
  late TextEditingController _confirmPasswordText;

  @override
  void initState() {
    super.initState();
    _usernameText = TextEditingController();
    _displayNameText = TextEditingController();
    _passwordText = TextEditingController();
    _confirmPasswordText = TextEditingController();
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _confirmPasswordText.dispose();
    _passwordText.dispose();
    _displayNameText.dispose();
    _usernameText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.registerPage;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr.title),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: PaddingAround(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(tr.title, style: CustomUi.titleTextStyle),
                  const PaddingBetween(),

                  // username
                  TextFormContainer(
                    caption: tr.username,
                    labelText: tr.usernameHint,
                    maxLength: 20,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-zA-Z0-9\+\-_]+$'),
                      ),
                    ],
                    controller: _usernameText,
                    validator: (value) => validate(
                      () =>
                          value != null &&
                          value.length >= 4 &&
                          value.length <= 20,
                      tr.usernameValidator(name: tr.username.toLowerCase()),
                    ),
                  ),
                  const PaddingBetween(),

                  // display name
                  TextFormContainer(
                    caption: tr.displayName,
                    labelText: tr.displayNameHint,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    controller: _displayNameText,
                    validator: (value) => validate(
                      () =>
                          value != null &&
                          value.length >= 4 &&
                          value.length <= 50,
                      tr.displayNameValidator(
                          name: tr.displayName.toLowerCase()),
                    ),
                  ),
                  const PaddingBetween(),

                  // password
                  TextFormContainer(
                    caption: tr.password,
                    labelText: tr.passwordHint,
                    maxLength: 20,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordText,
                    validator: (value) => validate(
                      () =>
                          value != null &&
                          value.length >= 4 &&
                          value.length <= 20,
                      tr.passwordValidator(name: tr.password.toLowerCase()),
                    ),
                  ),
                  const PaddingBetween(),

                  // confirm password
                  TextFormContainer(
                    caption: tr.confirmPassword,
                    labelText: tr.confirmPasswordHint,
                    maxLength: 20,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _confirmPasswordText,
                    validator: (value) => validate(
                      () =>
                          value != null &&
                          value.length >= 4 &&
                          value.length <= 20,
                      tr.confirmPasswordValidator(
                          name: tr.confirmPassword.toLowerCase()),
                    ),
                  ),
                  const PaddingBetween(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // save
                      PageButton(
                        icon: const Icon(Icons.save),
                        caption: t.common.ok,
                        lastInList: true,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            save();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: beforeBack,
    );
  }

  // ----------------------------------------------------------------------

  // Check Before Back

  bool isChanged() {
    return _usernameText.text.isNotEmpty ||
        _displayNameText.text.isNotEmpty ||
        _passwordText.text.isNotEmpty ||
        _confirmPasswordText.text.isNotEmpty;
  }

  Future<bool> beforeBack() async {
    return CustomUi.beforeBack(context, isChanged());
  }

  // ----------------------------------------------------------------------

  // Save

  Future<void> save() async {
    final client = logic.client;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await userRegister(
        client,
        username: _usernameText.text,
        displayName: _displayNameText.text,
        password: _passwordText.text,
        confirmPassword: _confirmPasswordText.text,
      ),
    )) return;

    // get result
    final item = User.fromJson(result.rest!.json['user']);
    log.finer('save, user: $item');

    Navigator.pop(context, item);
  }
}
