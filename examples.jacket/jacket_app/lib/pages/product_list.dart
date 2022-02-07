import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:vulcan_client_dart/vulcan_client.dart';
import 'package:sample_stock_client_dart/sample_stock_client.dart';
import '../logic.dart';
import '../ui.dart';
import 'product_edit.dart';

/// ProductListPage class.
class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

/// _ProductListState internal class.
class _ProductListState extends State<ProductListPage> {
  static final log = Logger('ProductListPage');
  final logic = Logic.instance();

  // data
  final items = <Product>[];

  // page
  int _pageCount = 0;
  int _pageIndex = 0;

  // order
  final Map<String, String> _orderingMap = {
    '': t.productListPage.sortById,
    'name+': t.productListPage.sortByNameAsc,
    'name-': t.productListPage.sortByNameDesc,
  };
  String _orderingSelected = '';

  // search
  String _searchText = '';

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
    final tr = t.productListPage;
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
            padding: const EdgeInsets.only(left: 16, right: 16),
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
              ],
            ),
          ),

          // list view
          Expanded(
            child: RefreshIndicator(
              child: ListView(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item.name),
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
      () async => result = await productFindAll(
        client,
        queryPage: QueryPage(
          page: _pageIndex,
          order: _orderingSelected,
          search: _searchText,
        ),
      ),
    )) return;

    // get result
    final list = result.rest!.json['products'];
    log.finer('find all, count: ${list.length}');
    items.clear();
    for (var i = 0; i < list.length; i++) {
      final item = Product.fromJson(list[i]);
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
      message: t.productListPage.create,
      placeholder: t.productListPage.createHint,
      options: InputBoxOptions(
        maxLength: 100,
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^[^ \t]+$'),
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
      () async => result = await productCreate(
        client,
        name: value,
      ),
    )) return;

    // get result
    final item = Product.fromJson(result.rest!.json['product']);
    log.finer('create, product: $item');

    await refresh();
  }

  // ----------------------------------------------------------------------

  // Edit

  Future<void> edit(Product o) async {
    final client = logic.sampleStockClient;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(
      context,
      () async => result = await productFindOne(
        client,
        id: o.id,
      ),
    )) return;

    // get result
    final item = Product.fromJson(result.rest!.json['product']);
    log.finer('find one, product: $item');

    // call service again
    if (!await ServiceRunner.execute(
      context,
      () async => result = await skuFindAll(
        client,
        queryPage: QueryPage(
          order: 'code',
        ),
      ),
    )) return;

    // get result again
    final list = result.rest!.json['skus'];
    final models = <Sku>[];
    for (var i = 0; i < list.length; i++) {
      final item = Sku.fromJson(list[i]);
      models.add(item);
    }

    // call editing page
    final answer = await Pages.switchPage(
      context,
      ProductEditPage(
        item: item,
        models: models,
      ),
    );
    if (answer != null) {
      refresh();
    }
  }
}
