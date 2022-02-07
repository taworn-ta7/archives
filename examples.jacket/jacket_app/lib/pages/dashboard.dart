import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../base/formatter.dart';
import '../logic.dart';
import '../ui.dart';

/// DashboardPage class.
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

/// _DashboardState internal class.
class _DashboardState extends State<DashboardPage> {
  static final log = Logger('DashboardPage');
  final logic = Logic.instance();

  @override
  void initState() {
    super.initState();
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
    final tr = t.dashboardPage;
    final item = logic.user!;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
        withMoreMenu: true,
        onResult: (menu, result) => setState(() {}),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: PaddingAround(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // icon
              Image.memory(
                logic.profileIcon!,
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
              const PaddingBetween(),

              // username
              Text(item.username, style: CustomUi.titleTextStyle),
              const PaddingBetween(),

              ///*
              // display name
              Row(
                children: [
                  Text('${tr.displayName}: '),
                  Text(item.displayName),
                ],
              ),
              const PaddingBetween(),

              // registered date/time
              Row(
                children: [
                  Text('${tr.createdAi}: '),
                  Text(Formatter.dateTimeFormat.format(item.createdAt!)),
                ],
              ),
              const PaddingBetween(),
              //*/

              ///*
              // data table
              DataTable(
                columns: <DataColumn>[
                  DataColumn(label: Text(t.common.name)),
                  DataColumn(label: Text(t.common.value)),
                ],
                rows: <DataRow>[
                  DataRow(cells: <DataCell>[
                    DataCell(Text(tr.displayName)),
                    DataCell(Text(item.displayName)),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text(tr.createdAi)),
                    DataCell(
                        Text(Formatter.dateTimeFormat.format(item.createdAt!))),
                  ]),
                ],
              ),
              //*/
            ],
          ),
        ),
      ),
    );
  }
}
