import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:minigun_client_dart/minigun_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import '../logic.dart';
import '../ui.dart';

/// EditProfileIconPage class.
class EditProfileIconPage extends StatefulWidget {
  final User item;
  final Uint8List profileIcon;

  const EditProfileIconPage({
    Key? key,
    required this.item,
    required this.profileIcon,
  }) : super(key: key);

  @override
  _EditProfileIconState createState() => _EditProfileIconState();
}

/// _EditProfileIconState internal class.
class _EditProfileIconState extends State<EditProfileIconPage> {
  static final log = Logger('EditProfileIconPage');
  final logic = Logic.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();

  // image file
  late bool _imageEditing;
  late PlatformFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageEditing = false;
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.editProfileIconPage;
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

                  // profile icon
                  Text(tr.profileIcon),
                  const PaddingBetween(half: true),
                  ImageChooser(
                    width: 128,
                    height: 128,
                    asset: 'assets/default-profile-icon.png',
                    bits: widget.profileIcon,
                    onUpload: (file) {
                      _imageEditing = true;
                      _imageFile = file;
                    },
                    onReset: () {
                      _imageEditing = true;
                      _imageFile = null;
                    },
                    onRevert: () {
                      _imageEditing = false;
                    },
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
    return _imageEditing;
  }

  Future<bool> beforeBack() async {
    return CustomUi.beforeBack(context, isChanged());
  }

  // ----------------------------------------------------------------------

  // Save

  Future<void> update() async {
    final client = logic.client;
    late MixResult result;

    // check and save image
    if (_imageEditing) {
      if (_imageFile != null) {
        log.finest('image upload');
        if (!await ServiceRunner.execute(
          context,
          () async {
            final path = _imageFile!.name;
            final mime = lookupMimeType(path, headerBytes: _imageFile!.bytes);
            final file = http.MultipartFile.fromBytes(
              'image',
              _imageFile!.bytes!,
              filename: _imageFile!.name,
              contentType: MediaType.parse(mime ?? ''),
            );
            result = await userProfileIconUpload(
              client,
              file: file,
            );
            return result;
          },
        )) return;
      } else {
        log.finest('image reset');
        if (!await ServiceRunner.execute(
          context,
          () async => result = await userProfileIconRemove(client),
        )) return;
      }
    }

    // return result
    final icon = await userProfileIconGet(client);
    if (icon.isOk()) {
      log.finer('reloaded profile icon');
      Navigator.pop(context, icon.rest!.res.bodyBytes);
    } else {
      Navigator.pop(context);
    }
  }
}
