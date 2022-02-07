import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:minigun_client_dart/minigun_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import '../logic.dart';
import '../ui.dart';

/// SkuEditPage class.
class SkuEditPage extends StatefulWidget {
  final Sku item;

  const SkuEditPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _SkuEditState createState() => _SkuEditState();
}

/// _SkuEditState internal class.
class _SkuEditState extends State<SkuEditPage> {
  static final log = Logger('SkuEditPage');
  final logic = Logic.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _barcodeText;
  late TextEditingController _costText;
  late TextEditingController _priceText;
  late TextEditingController _quantityText;

  // image file
  late bool _imageEditing;
  late PlatformFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _barcodeText = TextEditingController(text: widget.item.barcode);
    _costText = TextEditingController(text: widget.item.cost);
    _priceText = TextEditingController(text: widget.item.price);
    _quantityText =
        TextEditingController(text: widget.item.quantity.toString());
    _imageEditing = false;
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _quantityText.dispose();
    _priceText.dispose();
    _costText.dispose();
    _barcodeText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.skuEditPage;
    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppBar(
          title: tr.title(name: widget.item.code),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: PaddingAround(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // code
                  Text(widget.item.code, style: CustomUi.titleTextStyle),
                  const PaddingBetween(),

                  // barcode
                  TextFormContainer(
                    caption: tr.barcode,
                    labelText: tr.barcodeHint,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d{0,12}'),
                      ),
                    ],
                    controller: _barcodeText,
                    validator: (value) => validate(
                      () =>
                          value == null || value.isEmpty || value.length == 12,
                      tr.barcodeValidator(name: tr.barcode.toLowerCase()),
                    ),
                  ),
                  const PaddingBetween(),

                  // cost
                  TextFormContainer.money(
                    caption: tr.cost,
                    labelText: tr.costHint,
                    controller: _costText,
                  ),
                  const PaddingBetween(),

                  // price
                  TextFormContainer.money(
                    caption: tr.price,
                    labelText: tr.priceHint,
                    controller: _priceText,
                  ),
                  const PaddingBetween(),

                  // quantity
                  TextFormContainer.quantity(
                    caption: tr.quantity,
                    labelText: tr.quantityHint,
                    controller: _quantityText,
                  ),
                  const PaddingBetween(),

                  // image
                  Text(tr.image),
                  const PaddingBetween(half: true),
                  ImageChooser(
                    width: 256,
                    height: 256,
                    asset: 'assets/default-sku.png',
                    uri: widget.item.image != null
                        ? '${Constants.baseStaticUri}/files/${logic.user!.id}/sku/${widget.item.image}'
                        : null,
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

                  // button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // remove
                      PageButton(
                        icon: const Icon(Icons.remove),
                        caption: t.common.remove,
                        usePositiveNagative: true,
                        negativeButton: true,
                        onPressed: () => remove(),
                      ),

                      // update
                      PageButton(
                        icon: const Icon(Icons.update),
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
    return _barcodeText.text != (widget.item.barcode ?? '') ||
        _costText.text != widget.item.cost ||
        _priceText.text != widget.item.price ||
        _quantityText.text != widget.item.quantity.toString() ||
        _imageEditing;
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
            result = await skuImageUpload(
              client,
              code: widget.item.code,
              file: file,
            );
            return result;
          },
        )) return;
      } else {
        log.finest('image reset');
        if (!await ServiceRunner.execute(
          context,
          () async => result = await skuImageRemove(
            client,
            code: widget.item.code,
          ),
        )) return;
      }
    }

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await skuUpdate(
        client,
        code: widget.item.code,
        barcode: _barcodeText.text,
        cost: Sanitizers.toMoneyOrDefault(_costText.text).toString(),
        price: Sanitizers.toMoneyOrDefault(_priceText.text).toString(),
        quantity: Sanitizers.toIntOrDefault(_quantityText.text),
      ),
    )) return;

    // get result
    final item = Sku.fromJson(result.rest!.json['sku']);
    log.finer('update, sku: $item');

    Navigator.pop(context, true);
  }

  // ----------------------------------------------------------------------

  // Delete

  Future<void> remove() async {
    if (await MessageBox.question(
          context,
          t.question.areYouSureToDelete,
          MessageBoxOptions(button0Negative: true),
        ) !=
        true) return;

    final client = logic.client;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await skuRemove(
        client,
        code: widget.item.code,
      ),
    )) return;

    // get result
    final item = Sku.fromJson(result.rest!.json['sku']);
    log.finer('remove, sku: $item');

    Navigator.pop(context, true);
  }
}
