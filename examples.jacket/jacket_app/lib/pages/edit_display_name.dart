import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:vulcan_client_dart/vulcan_client.dart';
import '../logic.dart';
import '../ui.dart';

/// EditDisplayNamePage class.
class EditDisplayNamePage extends StatefulWidget {
  final User item;

  const EditDisplayNamePage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _EditDisplayNameState createState() => _EditDisplayNameState();
}

/// _EditDisplayNameState internal class.
class _EditDisplayNameState extends State<EditDisplayNamePage> {
  static final log = Logger('EditDisplayNamePage');
  final logic = Logic.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameText;

  @override
  void initState() {
    super.initState();
    _displayNameText = TextEditingController(text: widget.item.displayName);
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _displayNameText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.editDisplayNamePage;
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

  bool isChanged() {
    return _displayNameText.text != widget.item.displayName;
  }

  Future<bool> beforeBack() async {
    return CustomUi.beforeBack(context, isChanged());
  }

  // ----------------------------------------------------------------------

  // Save

  Future<void> update() async {
    final client = logic.authenClient;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await userUpdateDisplayName(
        client,
        displayName: _displayNameText.text,
      ),
    )) return;

    // get result
    final item = User.fromJson(result.rest!.json['user']);
    log.finer('update, user: $item');

    Navigator.pop(context, item);
  }
}
