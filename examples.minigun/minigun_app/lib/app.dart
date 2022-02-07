import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'ui.dart';
import 'pages/login.dart';
import 'pages/dashboard.dart';
import 'pages/sku_list.dart';
import 'pages/product_list.dart';

/// App class.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: LocaleSettings.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        const transition = PageTransitionType.bottomToTop;
        var path = settings.name ?? '';
        switch (path) {
          case Pages.dashboard:
            return PageTransition(
              type: transition,
              settings: settings,
              child: const DashboardPage(),
            );

          case Pages.sku:
            return PageTransition(
              type: transition,
              settings: settings,
              child: const SkuListPage(),
            );

          case Pages.product:
            return PageTransition(
              type: transition,
              settings: settings,
              child: const ProductListPage(),
            );

          case Pages.login:
          case '':
            return PageTransition(
              type: transition,
              settings: settings,
              child: const LoginPage(),
            );
        }
      },
      initialRoute: '/',
      title: t.app,
      debugShowCheckedModeBanner: false,
    );
  }
}
