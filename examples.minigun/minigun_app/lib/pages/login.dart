import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:minigun_client_dart/minigun_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic.dart';
import '../ui.dart';
import '../pages/register.dart';

/// LoginPage class.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

/// _LoginState internal class.
class _LoginState extends State<LoginPage> {
  static final log = Logger('LoginPage');
  final logic = Logic.instance();

  // widgets
  late TextEditingController _usernameText;
  late TextEditingController _passwordText;

  @override
  void initState() {
    super.initState();
    _usernameText = TextEditingController();
    _passwordText = TextEditingController();
    handleInit();
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    _passwordText.dispose();
    _usernameText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.loginPage;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/app.png'),
        title: Text(tr.title),
        actions: [
          // Thai language
          IconButton(
            icon: Image.asset('assets/locales/th.png'),
            tooltip: t.switchLocale.thai,
            onPressed: () {
              LocaleSettings.setLocaleRaw('th');
              setState(() {});
            },
          ),

          // English language
          IconButton(
            icon: Image.asset('assets/locales/en.png'),
            tooltip: t.switchLocale.english,
            onPressed: () {
              LocaleSettings.setLocaleRaw('en');
              setState(() {});
            },
          ),
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          child: PaddingAround(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  child: const FlutterLogo(
                    size: 128,
                  ),
                ),

                // username
                TextFormContainer(
                  caption: tr.username,
                  labelText: tr.username,
                  controller: _usernameText,
                ),
                const PaddingBetween(),

                // password
                TextFormContainer(
                  caption: tr.password,
                  labelText: tr.password,
                  obscureText: true,
                  controller: _passwordText,
                ),
                const PaddingBetween(),

                // button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // reset
                    PageButton(
                      caption: tr.reset,
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final username = prefs.getString('user.username') ?? '';
                        final password = prefs.getString('user.password') ?? '';
                        _usernameText.text = username;
                        _passwordText.text = password;
                      },
                    ),

                    // login
                    PageButton(
                      icon: const Icon(Icons.login),
                      caption: tr.ok,
                      lastInList: true,
                      onPressed: () => login(),
                    ),
                  ],
                ),
                const PaddingBetween(),

                // or
                Text(tr.or),
                const PaddingBetween(),

                // button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // register
                    PageButton(
                      icon: const Icon(Icons.how_to_reg_rounded),
                      caption: tr.register,
                      lastInList: true,
                      onPressed: () => register(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  // Init

  Future<void> handleInit() async {
    logic.reset();

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('user.username') ?? '';
    final password = prefs.getString('user.password') ?? '';
    _usernameText.text = username;
    _passwordText.text = password;

    if (logic.continueSession) {
      logic.continueSession = false;
      if (username.isNotEmpty && password.isNotEmpty) {
        final client = logic.client;
        late MixResult result;

        // try load previous user
        await WaitBox.show(
          context,
          () async => result = await client.login(
            username: username,
            password: password,
          ),
        );

        // check result
        if (result.isOk()) {
          final user = User.fromJson(result.rest!.json['user']);
          log.finer('continue session login, user: $user');
          logic.user = user;

          final icon = await userProfileIconGet(client);
          if (icon.isOk()) {
            log.finer('loaded profile icon');
            logic.profileIcon = icon.rest!.res.bodyBytes;
          }

          await Navigator.pushNamed(context, Pages.dashboard);
        }
      }
    }
  }

  // ----------------------------------------------------------------------

  // Login

  Future<void> login() async {
    final username = _usernameText.text;
    final password = _passwordText.text;
    log.finest('user: $username, pass: $password');

    final client = logic.client;
    late MixResult result;

    // call service
    if (!await ServiceRunner.execute(context, () async {
      result = await client.login(
        username: username,
        password: password,
      );

      if (result.isOk()) {
        final icon = await userProfileIconGet(client);
        if (icon.isOk()) {
          log.finer('loaded profile icon');
          logic.profileIcon = icon.rest!.res.bodyBytes;
        }
      }

      return result;
    })) return;

    // get result
    final item = User.fromJson(result.rest!.json['user']);
    log.finer('login, user: $item');
    logic.user = item;

    // save in shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user.username', username);
    prefs.setString('user.password', password);

    await Navigator.pushNamed(context, Pages.dashboard);
  }

  // ----------------------------------------------------------------------

  // Register

  Future<void> register() async {
    await Pages.switchPage(
      context,
      const RegisterPage(),
    );
  }
}
