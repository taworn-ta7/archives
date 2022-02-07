import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:vulcan_client_dart/vulcan_client.dart';
import '../logic.dart';
import '../ui.dart';

/// EditPasswordPage class.
class EditPasswordPage extends StatefulWidget {
  final User item;

  const EditPasswordPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

/// _EditPasswordState internal class.
class _EditPasswordState extends State<EditPasswordPage> {
  static final log = Logger('EditPasswordPage');
  final logic = Logic.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordText;
  late TextEditingController _confirmPasswordText;

  @override
  void initState() {
    super.initState();
    _passwordText = TextEditingController();
    _confirmPasswordText = TextEditingController();
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _confirmPasswordText.dispose();
    _passwordText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.editPasswordPage;
    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppBar(
          title: tr.title,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: PaddingAround(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // username
                  Text(widget.item.username, style: CustomUi.titleTextStyle),
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
                      // update
                      PageButton(
                        icon: const Icon(Icons.save),
                        caption: t.common.update,
                        lastInList: true,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            update();
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

  Future<bool> beforeBack() async {
    return true;
  }

  // ----------------------------------------------------------------------

  // Save

  Future<void> update() async {
    final client = logic.authenClient;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await userUpdatePassword(
        client,
        password: _passwordText.text,
        confirmPassword: _confirmPasswordText.text,
      ),
    )) return;

    // get result
    final item = User.fromJson(result.rest!.json['user']);
    log.finer('update, user: $item');

    Navigator.pop(context, item);
  }
}
