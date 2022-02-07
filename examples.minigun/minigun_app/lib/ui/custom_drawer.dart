import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../logic.dart';
import '../pages.dart';

/// A customized Drawer.
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final logic = Logic.instance();

  @override
  Widget build(BuildContext context) {
    final tr = t.drawerUi;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
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

                // name
                ListTile(
                  title: Text(tr.title),
                  subtitle: Text(logic.user?.displayName ?? '-'),
                ),
              ],
            ),
          ),

          // home
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(tr.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.dashboard);
            },
          ),

          // sku
          ListTile(
            leading: const Icon(Icons.toc),
            title: Text(tr.sku),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.sku);
            },
          ),

          // product
          ListTile(
            leading: const Icon(Icons.toc),
            title: Text(tr.product),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, Pages.product);
            },
          ),
        ],
      ),
    );
  }
}
