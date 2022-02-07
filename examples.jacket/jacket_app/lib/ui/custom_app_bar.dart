import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vulcan_client_dart/vulcan_client.dart';
import '../i18n/strings.g.dart';
import '../logic.dart';
import '../widgets/message_box.dart';
import '../widgets/wait_box.dart';
import '../widgets/search_bar.dart';
import '../pages.dart';
import '../pages/edit_profile_icon.dart';
import '../pages/edit_display_name.dart';
import '../pages/edit_password.dart';

enum ProfileMenu {
  editProfileIcon,
  editDisplayName,
  editPassword,
  logout,
}

/// A customized AppBar.
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool withMoreMenu;
  final void Function(ProfileMenu menu, Object? result)? onResult;
  final bool searchBox;
  final void Function(String value)? onSearchTextChanged;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.withMoreMenu = false,
    this.onResult,
    this.searchBox = false,
    this.onSearchTextChanged,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final logic = Logic.instance();

  late TextEditingController _searchText;

  @override
  void initState() {
    super.initState();
    _searchText = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: _buildActionList(context),
    );
  }

  /// Build popup menu button list.
  Widget _buildPopupMenu(BuildContext context) {
    final tr = t.appBar;
    return PopupMenuButton(
      // item list
      itemBuilder: (context) {
        List<PopupMenuEntry<ProfileMenu>> list = [];
        if (widget.withMoreMenu) {
          list.add(PopupMenuItem(
            value: ProfileMenu.editProfileIcon,
            child: ListTile(
              leading: const Icon(Icons.face),
              title: Text(tr.editProfileIcon),
            ),
          ));
          list.add(PopupMenuItem(
            value: ProfileMenu.editDisplayName,
            child: ListTile(
              leading: const Icon(Icons.face),
              title: Text(tr.editDisplayName),
            ),
          ));
          list.add(PopupMenuItem(
            value: ProfileMenu.editPassword,
            child: ListTile(
              leading: const Icon(Icons.password),
              title: Text(tr.editPassword),
            ),
          ));
        }
        list.add(PopupMenuItem(
          value: ProfileMenu.logout,
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: Text(tr.logout),
          ),
        ));
        return list;
      },

      // profile icon
      icon: _buildProfileIcon(context),

      // tooltip
      tooltip: tr.openMenu,

      // event
      onSelected: (value) async {
        if (value == ProfileMenu.editProfileIcon) {
          // edit profile icon
          final answer = await Pages.switchPage(
            context,
            EditProfileIconPage(
              item: logic.user!,
              profileIcon: logic.profileIcon!,
            ),
          );
          if (answer != null) {
            logic.profileIcon = answer as Uint8List;
            widget.onResult?.call(ProfileMenu.editProfileIcon, answer);
          }
        } else if (value == ProfileMenu.editDisplayName) {
          // edit display name
          final answer = await Pages.switchPage(
            context,
            EditDisplayNamePage(
              item: logic.user!,
            ),
          );
          if (answer != null) {
            logic.user = answer as User;
            widget.onResult?.call(ProfileMenu.editDisplayName, answer);
          }
        } else if (value == ProfileMenu.editPassword) {
          // edit password
          final answer = await Pages.switchPage(
            context,
            EditPasswordPage(
              item: logic.user!,
            ),
          );
          if (answer != null) {
            logic.user = answer as User;
            await MessageBox.info(context, tr.needRelogin);
            await _logout(context);
          }
        } else if (value == ProfileMenu.logout) {
          // logout
          final answer = await MessageBox.question(
            context,
            t.question.areYouSureToExit,
            MessageBoxOptions(
              button0Negative: true,
            ),
          );
          if (answer == true) {
            await _logout(context);
          }
        }
      },
    );
  }

  /// Build profile icon.
  Widget _buildProfileIcon(BuildContext context) {
    const size = 24.0;
    final icon = Logic.instance().profileIcon;
    if (icon != null) {
      return Image.memory(
        icon,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/default-profile-icon.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }
  }

  /// Build search box.
  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: t.searchBar.open,
      onPressed: () => Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: SearchBar(
            searchText: _searchText,
            onChanged: (text) => widget.onSearchTextChanged?.call(text),
          ),
        ),
      ),
    );
  }

  /// Build action list.
  List<Widget> _buildActionList(BuildContext context) {
    final actions = <Widget>[];
    if (widget.searchBox) {
      actions.add(_buildSearchButton(context));
    }
    actions.add(_buildPopupMenu(context));
    return actions;
  }

  // ----------------------------------------------------------------------

  // Logout

  Future<void> _logout(BuildContext context) async {
    await WaitBox.show(context, () async {
      final logic = Logic.instance();
      await logic.authenClient.logout();
      logic.reset();
    });

    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
