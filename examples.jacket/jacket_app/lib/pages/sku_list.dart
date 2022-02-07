import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:vulcan_client_dart/vulcan_client.dart';
import 'package:sample_stock_client_dart/sample_stock_client.dart';
import '../logic.dart';
import '../ui.dart';
import 'sku_edit.dart';

/// SkuListPage class.
class SkuListPage extends StatefulWidget {
  const SkuListPage({Key? key}) : super(key: key);

  @override
  _SkuListState createState() => _SkuListState();
}

/// _SkuListState internal class.
class _SkuListState extends State<SkuListPage> {
  static final log = Logger('SkuListPage');
  final logic = Logic.instance();

  // data
  final items = <Sku>[];

  // page
  int _pageCount = 0;
  int _pageIndex = 0;

  // order
  final Map<String, String> _orderingMap = {
    '': t.skuListPage.sortById,
    'code+': t.skuListPage.sortByCodeAsc,
    'code-': t.skuListPage.sortByCodeDesc,
    'barcode+': t.skuListPage.sortByBarcodeAsc,
    'barcode-': t.skuListPage.sortByBarcodeDesc,
    'cost+': t.skuListPage.sortByCostAsc,
    'cost-': t.skuListPage.sortByCostDesc,
    'price+': t.skuListPage.sortByPriceAsc,
    'price-': t.skuListPage.sortByPriceDesc,
    'q+': t.skuListPage.sortByQuantityAsc,
    'q-': t.skuListPage.sortByQuantityDesc,
  };
  String _orderingSelected = '';

  // search
  String _searchText = '';

  // view in trash
  bool _isTrashChecked = false;

  // initial timer handle
  late Timer _initTimer;

  @override
  void initState() {
    super.initState();
    _searchText = '';
    _initTimer = Timer(const Duration(), handleInit);
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _initTimer.cancel();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.skuListPage;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
        withMoreMenu: true,
        onResult: (menu, result) => setState(() {}),
        searchBox: true,
        onSearchTextChanged: (text) {
          setState(() {
            _searchText = text;
            _pageIndex = 0;
          });
          refresh();
        },
      ),
      drawer: const CustomDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 0),
            child: Row(
              children: [
                // ordering
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: _orderingMap
                        .map((value, text) {
                          return MapEntry(
                            value,
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(text),
                            ),
                          );
                        })
                        .values
                        .toList(),
                    value: _orderingSelected,
                    onChanged: (value) {
                      setState(() {
                        _orderingSelected = value ??= '';
                      });
                      refresh();
                    },
                  ),
                ),

                // view in trash
                TrashSwitch(
                  isChecked: _isTrashChecked,
                  onRefresh: (isChecked) {
                    setState(() {
                      _isTrashChecked = !_isTrashChecked;
                      _pageIndex = 0;
                    });
                    refresh();
                  },
                ),
              ],
            ),
          ),

          // list view
          Expanded(
            child: RefreshIndicator(
              child: ListView(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item.code),
                    subtitle: Text(
                      item.barcode == null || item.barcode!.isEmpty
                          ? tr.barcodeNotFound
                          : tr.barcodeFormat(barcode: item.barcode!),
                    ),
                    onTap: () => edit(item),
                  );
                }).toList(),
              ),
              onRefresh: refresh,
            ),
          ),

          // paginator
          Container(
            alignment: Alignment.bottomLeft,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            child: Paginator(
              pageIndex: _pageIndex,
              pageCount: _pageCount,
              onPageRefresh: (pageIndex, pageCount) {
                _pageIndex = pageIndex;
                refresh();
              },
            ),
          ),
        ],
      ),

      // create
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: tr.createHint,
        onPressed: create,
      ),
    );
  }

  // ----------------------------------------------------------------------

  // Init

  Future<void> handleInit() async {
    await refresh();
  }

  // ----------------------------------------------------------------------

  // Refresh

  Future<void> refresh() async {
    final client = logic.sampleStockClient;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await skuFindAll(
        client,
        queryPage: QueryPage(
          page: _pageIndex,
          order: _orderingSelected,
          search: _searchText,
          trash: _isTrashChecked,
        ),
      ),
    )) return;

    // get result
    final list = result.rest!.json['skus'];
    log.finer('find all, count: ${list.length}');
    items.clear();
    for (var i = 0; i < list.length; i++) {
      final item = Sku.fromJson(list[i]);
      log.finer('#$i: $item');
      items.add(item);
    }

    // update paginate
    final paginate = result.rest!.json['paginate'];
    _pageIndex = paginate['pageIndex'];
    _pageCount = paginate['pageCount'];
    log.finer('page: ${_pageIndex + 1}/$_pageCount');

    setState(() {});
  }

  // ----------------------------------------------------------------------

  // Add

  Future<void> create() async {
    final value = await InputBox.show(
      context: context,
      message: t.skuListPage.create,
      placeholder: t.skuListPage.createHint,
      options: InputBoxOptions(
        maxLength: 50,
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^[A-Za-z0-9\+\-_]+'),
          ),
        ],
        barrierDismissible: true,
      ),
    );
    if (value == null || value.isEmpty) return;

    final client = logic.sampleStockClient;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await skuCreate(
        client,
        code: value,
        cost: '0.0',
        price: '0.0',
        quantity: 0,
      ),
    )) return;

    // get result
    final List list = result.rest!.json['skus'];
    final items = list.map((item) => Sku.fromJson(item)).toList();
    log.finer('create, skus: $items');

    await refresh();
  }

  // ----------------------------------------------------------------------

  // Edit

  Future<void> edit(Sku o) async {
    final client = logic.sampleStockClient;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await skuFindOne(
        client,
        code: o.code,
      ),
    )) return;

    // get result
    final item = Sku.fromJson(result.rest!.json['sku']);
    log.finer('find one, sku: $item');

    // call editing page
    final answer = await Pages.switchPage(
      context,
      SkuEditPage(
        item: item,
      ),
    );
    if (answer != null) {
      refresh();
    }
  }
}
