import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:minigun_client_dart/minigun_client.dart';
import '../logic.dart';
import '../ui.dart';

/// ProductEditPage class.
class ProductEditPage extends StatefulWidget {
  final Product item;
  final List<Sku> models;

  const ProductEditPage({
    Key? key,
    required this.item,
    required this.models,
  }) : super(key: key);

  @override
  _ProductEditState createState() => _ProductEditState();
}

/// _ProductEditState internal class.
class _ProductEditState extends State<ProductEditPage> {
  static final log = Logger('ProductEditPage');
  final logic = Logic.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();

  // check items
  List<bool> selected = [];

  @override
  void initState() {
    super.initState();
    final list = widget.item.productSkus;
    selected = List<bool>.generate(
      widget.models.length,
      (int index) {
        if (list != null) {
          final found = list.indexWhere(
              (item) => item.sku?.code == widget.models[index].code);
          return found >= 0;
        }
        return false;
      },
    );
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
    final tr = t.productEditPage;
    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppBar(
          title: tr.title(name: widget.item.name),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: PaddingAround(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name
                  Text(widget.item.name, style: CustomUi.titleTextStyle),
                  const PaddingBetween(),

                  // data table
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: Text(t.common.name)),
                    ],
                    rows: List<DataRow>.generate(
                      widget.models.length,
                      (int index) => DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>((
                          Set<MaterialState> states,
                        ) {
                          if (states.contains(MaterialState.selected)) {
                            // selected row
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2);
                          }
                          if (index.isEven) {
                            // even row with color
                            return Colors.grey.withOpacity(0.2);
                          } else {
                            // odd row with default color
                            return null;
                          }
                        }),
                        cells: <DataCell>[
                          DataCell(Text(widget.models[index].code)),
                        ],
                        selected: selected[index],
                        onSelectChanged: (bool? value) {
                          setState(() {
                            selected[index] = value!;
                          });
                        },
                      ),
                    ),
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
    return false;
  }

  Future<bool> beforeBack() async {
    return CustomUi.beforeBack(context, isChanged());
  }

  // ----------------------------------------------------------------------

  // Save

  Future<void> update() async {
    List<String> checkList = [];
    for (var i = 0; i < widget.models.length; i++) {
      if (selected[i]) {
        checkList.add(widget.models[i].code);
        log.finest('add check ${widget.models[i].code}');
      }
    }

    final client = logic.client;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await productUpdate(
        client,
        id: widget.item.id,
        skus: checkList,
      ),
    )) return;

    // get result
    final item = Product.fromJson(result.rest!.json['product']);
    log.finer('update, product: $item');

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
      () async => result = await productRemove(
        client,
        id: widget.item.id,
      ),
    )) return;

    // get result
    final item = Product.fromJson(result.rest!.json['product']);
    log.finer('remove, product: $item');

    Navigator.pop(context, true);
  }
}
