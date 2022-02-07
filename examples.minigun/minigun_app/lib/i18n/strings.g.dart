
/*
 * Generated file. Do not edit.
 *
 * Locales: 2
 * Strings: 262 (131.0 per locale)
 *
 * Built on 2021-12-28 at 12:12 UTC
 */

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale {
	en, // 'en' (base locale, fallback)
	th, // 'th'
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_StringsEn _t = _currLocale.translations;
_StringsEn get t => _t;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget.translations;
	}
}

class LocaleSettings {
	LocaleSettings._(); // no constructor

	/// Uses locale of the device, fallbacks to base locale.
	/// Returns the locale which has been set.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.useDeviceLocale().languageTag
	static AppLocale useDeviceLocale() {
		final String? deviceLocale = WidgetsBinding.instance?.window.locale.toLanguageTag();
		if (deviceLocale != null) {
			return setLocaleRaw(deviceLocale);
		} else {
			return setLocale(_baseLocale);
		}
	}

	/// Sets locale
	/// Returns the locale which has been set.
	static AppLocale setLocale(AppLocale locale) {
		_currLocale = locale;
		_t = _currLocale.translations;

		if (WidgetsBinding.instance != null) {
			// force rebuild if TranslationProvider is used
			_translationProviderKey.currentState?.setLocale(_currLocale);
		}

		return _currLocale;
	}

	/// Sets locale using string tag (e.g. en_US, de-DE, fr)
	/// Fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale setLocaleRaw(String localeRaw) {
		final selected = _selectLocale(localeRaw);
		return setLocale(selected ?? _baseLocale);
	}

	/// Gets current locale.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.currentLocale.languageTag
	static AppLocale get currentLocale {
		return _currLocale;
	}

	/// Gets base locale.
	/// Hint for pre 4.x.x developers: You can access the raw string via LocaleSettings.baseLocale.languageTag
	static AppLocale get baseLocale {
		return _baseLocale;
	}

	/// Gets supported locales in string format.
	static List<String> get supportedLocalesRaw {
		return AppLocale.values
			.map((locale) => locale.languageTag)
			.toList();
	}

	/// Gets supported locales (as Locale objects) with base locale sorted first.
	static List<Locale> get supportedLocales {
		return AppLocale.values
			.map((locale) => locale.flutterLocale)
			.toList();
	}

}

// context enums

// interfaces generated as mixins

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {
	_StringsEn get translations {
		switch (this) {
			case AppLocale.en: return _StringsEn._instance;
			case AppLocale.th: return _StringsTh._instance;
		}
	}

	String get languageTag {
		switch (this) {
			case AppLocale.en: return 'en';
			case AppLocale.th: return 'th';
		}
	}

	Locale get flutterLocale {
		switch (this) {
			case AppLocale.en: return const Locale.fromSubtags(languageCode: 'en');
			case AppLocale.th: return const Locale.fromSubtags(languageCode: 'th');
		}
	}
}

extension StringAppLocaleExtensions on String {
	AppLocale? toAppLocale() {
		switch (this) {
			case 'en': return AppLocale.en;
			case 'th': return AppLocale.th;
			default: return null;
		}
	}
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey = GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
	TranslationProvider({required this.child}) : super(key: _translationProviderKey);

	final Widget child;

	@override
	_TranslationProviderState createState() => _TranslationProviderState();

	static _InheritedLocaleData of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget;
	}
}

class _TranslationProviderState extends State<TranslationProvider> {
	AppLocale locale = _currLocale;

	void setLocale(AppLocale newLocale) {
		setState(() {
			locale = newLocale;
		});
	}

	@override
	Widget build(BuildContext context) {
		return _InheritedLocaleData(
			locale: locale,
			child: widget.child,
		);
	}
}

class _InheritedLocaleData extends InheritedWidget {
	final AppLocale locale;
	Locale get flutterLocale => locale.flutterLocale; // shortcut
	final _StringsEn translations; // store translations to avoid switch call

	_InheritedLocaleData({required this.locale, required Widget child})
		: translations = locale.translations, super(child: child);

	@override
	bool updateShouldNotify(_InheritedLocaleData oldWidget) {
		return oldWidget.locale != locale;
	}
}

// pluralization feature not used

// helpers

final _localeRegex = RegExp(r'^([a-z]{2,8})?([_-]([A-Za-z]{4}))?([_-]?([A-Z]{2}|[0-9]{3}))?$');
AppLocale? _selectLocale(String localeRaw) {
	final match = _localeRegex.firstMatch(localeRaw);
	AppLocale? selected;
	if (match != null) {
		final language = match.group(1);
		final country = match.group(5);

		// match exactly
		selected = AppLocale.values
			.cast<AppLocale?>()
			.firstWhere((supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'), orElse: () => null);

		if (selected == null && language != null) {
			// match language
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.startsWith(language) == true, orElse: () => null);
		}

		if (selected == null && country != null) {
			// match country
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.contains(country) == true, orElse: () => null);
		}
	}
	return selected;
}

// translations

class _StringsEn {
	_StringsEn._(); // no constructor

	static final _StringsEn _instance = _StringsEn._();

	String get app => 'Minigun';
	_StringsSwitchLocaleEn get switchLocale => _StringsSwitchLocaleEn._instance;
	_StringsCommonEn get common => _StringsCommonEn._instance;
	_StringsQuestionEn get question => _StringsQuestionEn._instance;
	_StringsValidatorEn get validator => _StringsValidatorEn._instance;
	_StringsMessageBoxEn get messageBox => _StringsMessageBoxEn._instance;
	_StringsWaitBoxEn get waitBox => _StringsWaitBoxEn._instance;
	_StringsServiceRunnerEn get serviceRunner => _StringsServiceRunnerEn._instance;
	_StringsPaginatorEn get paginator => _StringsPaginatorEn._instance;
	_StringsImageChooserEn get imageChooser => _StringsImageChooserEn._instance;
	_StringsTrashEn get trash => _StringsTrashEn._instance;
	_StringsAppBarEn get appBar => _StringsAppBarEn._instance;
	_StringsSearchBarEn get searchBar => _StringsSearchBarEn._instance;
	_StringsEditProfileIconPageEn get editProfileIconPage => _StringsEditProfileIconPageEn._instance;
	_StringsEditDisplayNamePageEn get editDisplayNamePage => _StringsEditDisplayNamePageEn._instance;
	_StringsEditPasswordPageEn get editPasswordPage => _StringsEditPasswordPageEn._instance;
	_StringsDrawerUiEn get drawerUi => _StringsDrawerUiEn._instance;
	_StringsLoginPageEn get loginPage => _StringsLoginPageEn._instance;
	_StringsRegisterPageEn get registerPage => _StringsRegisterPageEn._instance;
	_StringsDashboardPageEn get dashboardPage => _StringsDashboardPageEn._instance;
	_StringsSkuListPageEn get skuListPage => _StringsSkuListPageEn._instance;
	_StringsSkuEditPageEn get skuEditPage => _StringsSkuEditPageEn._instance;
	_StringsProductListPageEn get productListPage => _StringsProductListPageEn._instance;
	_StringsProductEditPageEn get productEditPage => _StringsProductEditPageEn._instance;

	/// A flat map containing all translations.
	dynamic operator[](String key) => _translationMapEn[key];
}

class _StringsSwitchLocaleEn {
	_StringsSwitchLocaleEn._(); // no constructor

	static final _StringsSwitchLocaleEn _instance = _StringsSwitchLocaleEn._();

	String get english => 'English';
	String get thai => 'ไทย';
}

class _StringsCommonEn {
	_StringsCommonEn._(); // no constructor

	static final _StringsCommonEn _instance = _StringsCommonEn._();

	String get close => 'Close';
	String get ok => 'OK';
	String get cancel => 'Cancel';
	String get yes => 'Yes';
	String get no => 'No';
	String get retry => 'Retry';
	String get name => 'Name';
	String get value => 'Value';
	String get create => 'Create';
	String get createMore => 'Create...';
	String get update => 'Save';
	String get updateMore => 'Save...';
	String get remove => 'Delete';
	String get removeMore => 'Delete...';
}

class _StringsQuestionEn {
	_StringsQuestionEn._(); // no constructor

	static final _StringsQuestionEn _instance = _StringsQuestionEn._();

	String get areYouSureToExit => 'Are you sure to exit this program?';
	String get areYouSureToDelete => 'Are you sure to delete this item?';
	String get areYouSureToLeave => 'Are you sure to leave without save data?';
}

class _StringsValidatorEn {
	_StringsValidatorEn._(); // no constructor

	static final _StringsValidatorEn _instance = _StringsValidatorEn._();

	String isPositiveInt({required Object name}) => 'Please input $name as positive integer.';
	String isPositiveOrZeroInt({required Object name}) => 'Please input $name as positive integer or zero.';
	String isNegativeInt({required Object name}) => 'Please input $name as negative integer.';
	String isNegativeOrZeroInt({required Object name}) => 'Please input $name as negative integer or zero.';
	String isPositiveFloat({required Object name}) => 'Please input $name as positive floating-point.';
	String isPositiveOrZeroFloat({required Object name}) => 'Please input $name as positive floating-point or zero.';
	String isNegativeFloat({required Object name}) => 'Please input $name as negative floating-point.';
	String isNegativeOrZeroFloat({required Object name}) => 'Please input $name as negative floating-point or zero.';
	String isMoney({required Object name}) => 'Please input $name as money.';
}

class _StringsMessageBoxEn {
	_StringsMessageBoxEn._(); // no constructor

	static final _StringsMessageBoxEn _instance = _StringsMessageBoxEn._();

	String get info => 'Information';
	String get warning => 'Warning';
	String get error => 'Error';
	String get question => 'Question';
}

class _StringsWaitBoxEn {
	_StringsWaitBoxEn._(); // no constructor

	static final _StringsWaitBoxEn _instance = _StringsWaitBoxEn._();

	String get message => 'Please wait...';
}

class _StringsServiceRunnerEn {
	_StringsServiceRunnerEn._(); // no constructor

	static final _StringsServiceRunnerEn _instance = _StringsServiceRunnerEn._();

	String get message => 'Network error!';
}

class _StringsPaginatorEn {
	_StringsPaginatorEn._(); // no constructor

	static final _StringsPaginatorEn _instance = _StringsPaginatorEn._();

	String get first => 'Go to first page.';
	String get previous => 'Go to previous page.';
	String get next => 'Go to next page.';
	String get last => 'Go to last page.';
	String get go => 'Go';
}

class _StringsImageChooserEn {
	_StringsImageChooserEn._(); // no constructor

	static final _StringsImageChooserEn _instance = _StringsImageChooserEn._();

	String get upload => 'Upload';
	String get reset => 'Reset';
	String get revert => 'Revert';
}

class _StringsTrashEn {
	_StringsTrashEn._(); // no constructor

	static final _StringsTrashEn _instance = _StringsTrashEn._();

	String get trash => 'View in Trash';
	String get normal => 'View Normal';
}

class _StringsAppBarEn {
	_StringsAppBarEn._(); // no constructor

	static final _StringsAppBarEn _instance = _StringsAppBarEn._();

	String get openMenu => 'Open Profile Menu';
	String get editProfileIcon => 'Edit Profile Icon...';
	String get editDisplayName => 'Edit Display Name...';
	String get editPassword => 'Edit Password...';
	String get needRelogin => 'You have to re-login!';
	String get logout => 'Logout';
}

class _StringsSearchBarEn {
	_StringsSearchBarEn._(); // no constructor

	static final _StringsSearchBarEn _instance = _StringsSearchBarEn._();

	String get open => 'Open search...';
	String get hint => 'Search...';
}

class _StringsEditProfileIconPageEn {
	_StringsEditProfileIconPageEn._(); // no constructor

	static final _StringsEditProfileIconPageEn _instance = _StringsEditProfileIconPageEn._();

	String get title => 'Edit Profile Icon';
	String get profileIcon => 'Profile Icon';
	String get profileIconUpload => 'Upload Profile Icon';
	String get profileIconReset => 'Reset Profile Icon';
}

class _StringsEditDisplayNamePageEn {
	_StringsEditDisplayNamePageEn._(); // no constructor

	static final _StringsEditDisplayNamePageEn _instance = _StringsEditDisplayNamePageEn._();

	String get title => 'Edit Display Name';
	String get displayName => 'Display Name';
	String get displayNameHint => 'min length: 4 characters, max length: 50 characters';
	String displayNameValidator({required Object name}) => 'Please input $name as 4-50 characters.';
}

class _StringsEditPasswordPageEn {
	_StringsEditPasswordPageEn._(); // no constructor

	static final _StringsEditPasswordPageEn _instance = _StringsEditPasswordPageEn._();

	String get title => 'Edit Password';
	String get password => 'Password';
	String get passwordHint => 'min length: 4 characters, max length: 20 characters';
	String passwordValidator({required Object name}) => 'Please input $name as 4-20 characters.';
	String get confirmPassword => 'Confirm Password';
	String get confirmPasswordHint => 'min length: 4 characters, max length: 20 characters';
	String confirmPasswordValidator({required Object name}) => 'Please input $name as 4-20 characters.';
}

class _StringsDrawerUiEn {
	_StringsDrawerUiEn._(); // no constructor

	static final _StringsDrawerUiEn _instance = _StringsDrawerUiEn._();

	String get title => 'Hello';
	String get home => 'Home';
	String get sku => 'SKU List';
	String get product => 'Product List';
}

class _StringsLoginPageEn {
	_StringsLoginPageEn._(); // no constructor

	static final _StringsLoginPageEn _instance = _StringsLoginPageEn._();

	String get title => 'Login';
	String get username => 'Username';
	String get password => 'Password';
	String get reset => 'Reset';
	String get ok => 'Login';
	String get or => '-- or --';
	String get register => 'Register...';
}

class _StringsRegisterPageEn {
	_StringsRegisterPageEn._(); // no constructor

	static final _StringsRegisterPageEn _instance = _StringsRegisterPageEn._();

	String get title => 'Register';
	String get username => 'Username';
	String get usernameHint => 'min length: 4 characters, max length: 20 characters';
	String usernameValidator({required Object name}) => 'Please input $name as 4-20 characters.';
	String get displayName => 'Display Name';
	String get displayNameHint => 'min length: 4 characters, max length: 50 characters';
	String displayNameValidator({required Object name}) => 'Please input $name as 4-50 characters.';
	String get password => 'Password';
	String get passwordHint => 'min length: 4 characters, max length: 20 characters';
	String passwordValidator({required Object name}) => 'Please input $name as 4-20 characters.';
	String get confirmPassword => 'Confirm Password';
	String get confirmPasswordHint => 'min length: 4 characters, max length: 20 characters';
	String confirmPasswordValidator({required Object name}) => 'Please input $name as 4-20 characters.';
}

class _StringsDashboardPageEn {
	_StringsDashboardPageEn._(); // no constructor

	static final _StringsDashboardPageEn _instance = _StringsDashboardPageEn._();

	String get title => 'Dashboard';
	String get displayName => 'Display Name';
	String get createdAi => 'Registered Date';
}

class _StringsSkuListPageEn {
	_StringsSkuListPageEn._(); // no constructor

	static final _StringsSkuListPageEn _instance = _StringsSkuListPageEn._();

	String get title => 'SKU List';
	String get sortById => 'ID';
	String get sortByCodeAsc => 'Code ASC';
	String get sortByCodeDesc => 'Code DESC';
	String get sortByBarcodeAsc => 'Barcode ASC';
	String get sortByBarcodeDesc => 'Barcode DESC';
	String get sortByCostAsc => 'Cost ASC';
	String get sortByCostDesc => 'Cost DESC';
	String get sortByPriceAsc => 'Price ASC';
	String get sortByPriceDesc => 'Price DESC';
	String get sortByQuantityAsc => 'Quantity ASC';
	String get sortByQuantityDesc => 'Quantity DESC';
	String barcodeFormat({required Object barcode}) => 'Barcode: $barcode';
	String get barcodeNotFound => 'Barcode not found.';
	String get create => 'Create SKU';
	String get createMore => 'Create SKU...';
	String get createHint => 'Create a new SKU.';
}

class _StringsSkuEditPageEn {
	_StringsSkuEditPageEn._(); // no constructor

	static final _StringsSkuEditPageEn _instance = _StringsSkuEditPageEn._();

	String title({required Object name}) => 'Edit $name';
	String get barcode => 'Barcode';
	String get barcodeHint => 'such as: 123456789012, 12 digits or leave blank';
	String barcodeValidator({required Object name}) => 'Please input $name as 12 characters or blank at all.';
	String get cost => 'Cost';
	String get costHint => 'cost to buy';
	String get price => 'Price';
	String get priceHint => 'price to sell';
	String get quantity => 'Quantity';
	String get quantityHint => 'quantity in stock';
	String get image => 'SKU Image';
}

class _StringsProductListPageEn {
	_StringsProductListPageEn._(); // no constructor

	static final _StringsProductListPageEn _instance = _StringsProductListPageEn._();

	String get title => 'Product List';
	String get sortById => 'ID';
	String get sortByNameAsc => 'Name ASC';
	String get sortByNameDesc => 'Name DESC';
	String get create => 'Create Product';
	String get createMore => 'Create Product...';
	String get createHint => 'Create a new Product.';
}

class _StringsProductEditPageEn {
	_StringsProductEditPageEn._(); // no constructor

	static final _StringsProductEditPageEn _instance = _StringsProductEditPageEn._();

	String title({required Object name}) => 'Edit $name';
}

class _StringsTh implements _StringsEn {
	_StringsTh._(); // no constructor

	static final _StringsTh _instance = _StringsTh._();

	@override String get app => 'ปืนกลเล็ก';
	@override _StringsSwitchLocaleTh get switchLocale => _StringsSwitchLocaleTh._instance;
	@override _StringsCommonTh get common => _StringsCommonTh._instance;
	@override _StringsQuestionTh get question => _StringsQuestionTh._instance;
	@override _StringsValidatorTh get validator => _StringsValidatorTh._instance;
	@override _StringsMessageBoxTh get messageBox => _StringsMessageBoxTh._instance;
	@override _StringsWaitBoxTh get waitBox => _StringsWaitBoxTh._instance;
	@override _StringsServiceRunnerTh get serviceRunner => _StringsServiceRunnerTh._instance;
	@override _StringsPaginatorTh get paginator => _StringsPaginatorTh._instance;
	@override _StringsImageChooserTh get imageChooser => _StringsImageChooserTh._instance;
	@override _StringsTrashTh get trash => _StringsTrashTh._instance;
	@override _StringsAppBarTh get appBar => _StringsAppBarTh._instance;
	@override _StringsSearchBarTh get searchBar => _StringsSearchBarTh._instance;
	@override _StringsEditProfileIconPageTh get editProfileIconPage => _StringsEditProfileIconPageTh._instance;
	@override _StringsEditDisplayNamePageTh get editDisplayNamePage => _StringsEditDisplayNamePageTh._instance;
	@override _StringsEditPasswordPageTh get editPasswordPage => _StringsEditPasswordPageTh._instance;
	@override _StringsDrawerUiTh get drawerUi => _StringsDrawerUiTh._instance;
	@override _StringsLoginPageTh get loginPage => _StringsLoginPageTh._instance;
	@override _StringsRegisterPageTh get registerPage => _StringsRegisterPageTh._instance;
	@override _StringsDashboardPageTh get dashboardPage => _StringsDashboardPageTh._instance;
	@override _StringsSkuListPageTh get skuListPage => _StringsSkuListPageTh._instance;
	@override _StringsSkuEditPageTh get skuEditPage => _StringsSkuEditPageTh._instance;
	@override _StringsProductListPageTh get productListPage => _StringsProductListPageTh._instance;
	@override _StringsProductEditPageTh get productEditPage => _StringsProductEditPageTh._instance;

	/// A flat map containing all translations.
	@override dynamic operator[](String key) => _translationMapTh[key];
}

class _StringsSwitchLocaleTh implements _StringsSwitchLocaleEn {
	_StringsSwitchLocaleTh._(); // no constructor

	static final _StringsSwitchLocaleTh _instance = _StringsSwitchLocaleTh._();

	@override String get english => 'English';
	@override String get thai => 'ไทย';
}

class _StringsCommonTh implements _StringsCommonEn {
	_StringsCommonTh._(); // no constructor

	static final _StringsCommonTh _instance = _StringsCommonTh._();

	@override String get close => 'ปิด';
	@override String get ok => 'ตกลง';
	@override String get cancel => 'ยกเลิก';
	@override String get yes => 'ใช่';
	@override String get no => 'ไม่ใช่';
	@override String get retry => 'ลองใหม่';
	@override String get name => 'ชื่อ';
	@override String get value => 'ค่า';
	@override String get create => 'สร้าง';
	@override String get createMore => 'สร้าง...';
	@override String get update => 'บันทึก';
	@override String get updateMore => 'บันทึก...';
	@override String get remove => 'ลบ';
	@override String get removeMore => 'ลบ...';
}

class _StringsQuestionTh implements _StringsQuestionEn {
	_StringsQuestionTh._(); // no constructor

	static final _StringsQuestionTh _instance = _StringsQuestionTh._();

	@override String get areYouSureToExit => 'คุณแน่ใจที่จะออกจากโปรแกรมนี้หรือไม่?';
	@override String get areYouSureToDelete => 'คุณแน่ใจที่จะลบข้อมูลนี้หรือไม่?';
	@override String get areYouSureToLeave => 'คุณแน่ใจที่จะออกจากหน้านี้โดยไม่เซฟข้อมูล?';
}

class _StringsValidatorTh implements _StringsValidatorEn {
	_StringsValidatorTh._(); // no constructor

	static final _StringsValidatorTh _instance = _StringsValidatorTh._();

	@override String isPositiveInt({required Object name}) => 'กรอก $name เป็นเลขจำนวนเต็มบวก';
	@override String isPositiveOrZeroInt({required Object name}) => 'กรอก $name เป็นเลขจำนวนเต็มบวกหรือศูนย์';
	@override String isNegativeInt({required Object name}) => 'กรอก $name เป็นเลขจำนวนเต็มลบ';
	@override String isNegativeOrZeroInt({required Object name}) => 'กรอก $name เป็นเลขจำนวนเต็มลบหรือศูนย์';
	@override String isPositiveFloat({required Object name}) => 'กรอก $name เป็นเลขจำนวนทศนิยมบวก';
	@override String isPositiveOrZeroFloat({required Object name}) => 'กรอก $name เป็นเลขจำนวนทศนิยมบวกหรือศูนย์';
	@override String isNegativeFloat({required Object name}) => 'กรอก $name เป็นเลขจำนวนทศนิยมลบ';
	@override String isNegativeOrZeroFloat({required Object name}) => 'กรอก $name เป็นเลขจำนวนทศนิยมลบหรือศูนย์';
	@override String isMoney({required Object name}) => 'กรอก $name เป็นเลขจำนวนเงิน.';
}

class _StringsMessageBoxTh implements _StringsMessageBoxEn {
	_StringsMessageBoxTh._(); // no constructor

	static final _StringsMessageBoxTh _instance = _StringsMessageBoxTh._();

	@override String get info => 'ข้อมูลข่าวสาร';
	@override String get warning => 'แจ้งเตือน';
	@override String get error => 'เกิดข้อผิดพลาด';
	@override String get question => 'คำถาม';
}

class _StringsWaitBoxTh implements _StringsWaitBoxEn {
	_StringsWaitBoxTh._(); // no constructor

	static final _StringsWaitBoxTh _instance = _StringsWaitBoxTh._();

	@override String get message => 'โปรดรอสักครู่...';
}

class _StringsServiceRunnerTh implements _StringsServiceRunnerEn {
	_StringsServiceRunnerTh._(); // no constructor

	static final _StringsServiceRunnerTh _instance = _StringsServiceRunnerTh._();

	@override String get message => 'เกิดข้อผิดพลาดบนเน็ตเวิร์ค!';
}

class _StringsPaginatorTh implements _StringsPaginatorEn {
	_StringsPaginatorTh._(); // no constructor

	static final _StringsPaginatorTh _instance = _StringsPaginatorTh._();

	@override String get first => 'ไปยังหน้าแรก';
	@override String get previous => 'ไปยังหน้าที่แล้ว';
	@override String get next => 'ไปยังหน้าถัดไป';
	@override String get last => 'ไปยังหน้าสุดท้าย';
	@override String get go => 'ไป';
}

class _StringsImageChooserTh implements _StringsImageChooserEn {
	_StringsImageChooserTh._(); // no constructor

	static final _StringsImageChooserTh _instance = _StringsImageChooserTh._();

	@override String get upload => 'อัพโหลด';
	@override String get reset => 'รีเซ็ต';
	@override String get revert => 'ย้อนกลับ';
}

class _StringsTrashTh implements _StringsTrashEn {
	_StringsTrashTh._(); // no constructor

	static final _StringsTrashTh _instance = _StringsTrashTh._();

	@override String get trash => 'ดูในถังขยะ';
	@override String get normal => 'ดูปกติ';
}

class _StringsAppBarTh implements _StringsAppBarEn {
	_StringsAppBarTh._(); // no constructor

	static final _StringsAppBarTh _instance = _StringsAppBarTh._();

	@override String get openMenu => 'เปิดโปรไฟล์เมนู';
	@override String get editProfileIcon => 'ปรับปรุงโปรไฟล์ไอคอน...';
	@override String get editDisplayName => 'แก้ไขชื่อของท่าน...';
	@override String get editPassword => 'เปลี่ยนแปลงรหัสผ่าน...';
	@override String get needRelogin => 'คุณต้องเข้าสู่ระบบอีกครั้ง!';
	@override String get logout => 'ออกจากระบบ';
}

class _StringsSearchBarTh implements _StringsSearchBarEn {
	_StringsSearchBarTh._(); // no constructor

	static final _StringsSearchBarTh _instance = _StringsSearchBarTh._();

	@override String get open => 'เปิดการค้นหา...';
	@override String get hint => 'ค้นหา...';
}

class _StringsEditProfileIconPageTh implements _StringsEditProfileIconPageEn {
	_StringsEditProfileIconPageTh._(); // no constructor

	static final _StringsEditProfileIconPageTh _instance = _StringsEditProfileIconPageTh._();

	@override String get title => 'ปรับปรุงโปรไฟล์ไอคอน';
	@override String get profileIcon => 'โปรไฟล์ไอคอน';
	@override String get profileIconUpload => 'อัพโหลดรูปโปรไฟล์';
	@override String get profileIconReset => 'รีเซตเป็นค่าเดิม';
}

class _StringsEditDisplayNamePageTh implements _StringsEditDisplayNamePageEn {
	_StringsEditDisplayNamePageTh._(); // no constructor

	static final _StringsEditDisplayNamePageTh _instance = _StringsEditDisplayNamePageTh._();

	@override String get title => 'แก้ไขชื่อของท่าน';
	@override String get displayName => 'ชื่อของท่าน';
	@override String get displayNameHint => 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 50 ตัวอักษร';
	@override String displayNameValidator({required Object name}) => 'กรอก $name เป็นจำนวน 4-50 ตัวอักษร';
}

class _StringsEditPasswordPageTh implements _StringsEditPasswordPageEn {
	_StringsEditPasswordPageTh._(); // no constructor

	static final _StringsEditPasswordPageTh _instance = _StringsEditPasswordPageTh._();

	@override String get title => 'เปลี่ยนแปลงรหัสผ่าน';
	@override String get password => 'รหัสผ่าน';
	@override String get passwordHint => 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร';
	@override String passwordValidator({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร';
	@override String get confirmPassword => 'ยืนยันรหัสผ่าน';
	@override String get confirmPasswordHint => 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร';
	@override String confirmPasswordValidator({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร';
}

class _StringsDrawerUiTh implements _StringsDrawerUiEn {
	_StringsDrawerUiTh._(); // no constructor

	static final _StringsDrawerUiTh _instance = _StringsDrawerUiTh._();

	@override String get title => 'สวัสดี';
	@override String get home => 'เริ่มต้น';
	@override String get sku => 'รายการ SKU';
	@override String get product => 'รายการสินค้า';
}

class _StringsLoginPageTh implements _StringsLoginPageEn {
	_StringsLoginPageTh._(); // no constructor

	static final _StringsLoginPageTh _instance = _StringsLoginPageTh._();

	@override String get title => 'เข้าสู่ระบบ';
	@override String get username => 'ชื่อผู้ใช้';
	@override String get password => 'รหัสผ่าน';
	@override String get reset => 'รีเซ็ต';
	@override String get ok => 'เข้าสู่ระบบ';
	@override String get or => '-- หรือ --';
	@override String get register => 'ลงทะเบียน...';
}

class _StringsRegisterPageTh implements _StringsRegisterPageEn {
	_StringsRegisterPageTh._(); // no constructor

	static final _StringsRegisterPageTh _instance = _StringsRegisterPageTh._();

	@override String get title => 'ลงทะเบียน';
	@override String get username => 'ชื่อผู้ใช้';
	@override String get usernameHint => 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร';
	@override String usernameValidator({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร';
	@override String get displayName => 'ชื่อของท่าน';
	@override String get displayNameHint => 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 50 ตัวอักษร';
	@override String displayNameValidator({required Object name}) => 'กรอก $name เป็นจำนวน 4-50 ตัวอักษร';
	@override String get password => 'รหัสผ่าน';
	@override String get passwordHint => 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร';
	@override String passwordValidator({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร';
	@override String get confirmPassword => 'ยืนยันรหัสผ่าน';
	@override String get confirmPasswordHint => 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร';
	@override String confirmPasswordValidator({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร';
}

class _StringsDashboardPageTh implements _StringsDashboardPageEn {
	_StringsDashboardPageTh._(); // no constructor

	static final _StringsDashboardPageTh _instance = _StringsDashboardPageTh._();

	@override String get title => 'กระดานของคุณ';
	@override String get displayName => 'ชื่อของท่าน';
	@override String get createdAi => 'วันที่ลงทะเบียน';
}

class _StringsSkuListPageTh implements _StringsSkuListPageEn {
	_StringsSkuListPageTh._(); // no constructor

	static final _StringsSkuListPageTh _instance = _StringsSkuListPageTh._();

	@override String get title => 'รายการ SKU';
	@override String get sortById => 'ID';
	@override String get sortByCodeAsc => 'Code น้อยไปมาก';
	@override String get sortByCodeDesc => 'Code มากไปน้อย';
	@override String get sortByBarcodeAsc => 'บาร์โค๊ด น้อยไปมาก';
	@override String get sortByBarcodeDesc => 'บาร์โค๊ด มากไปน้อย';
	@override String get sortByCostAsc => 'ต้นทุน น้อยไปมาก';
	@override String get sortByCostDesc => 'ต้นทุน มากไปน้อย';
	@override String get sortByPriceAsc => 'ราคา น้อยไปมาก';
	@override String get sortByPriceDesc => 'ราคา มากไปน้อย';
	@override String get sortByQuantityAsc => 'จำนวน น้อยไปมาก';
	@override String get sortByQuantityDesc => 'จำนวน มากไปน้อย';
	@override String barcodeFormat({required Object barcode}) => 'บาร์โค๊ด: $barcode';
	@override String get barcodeNotFound => 'ไม่พบบาร์โค๊ด';
	@override String get create => 'สร้าง SKU';
	@override String get createMore => 'สร้าง SKU...';
	@override String get createHint => 'สร้าง SKU ใหม่';
}

class _StringsSkuEditPageTh implements _StringsSkuEditPageEn {
	_StringsSkuEditPageTh._(); // no constructor

	static final _StringsSkuEditPageTh _instance = _StringsSkuEditPageTh._();

	@override String title({required Object name}) => 'แก้ไข $name';
	@override String get barcode => 'บาร์โค๊ด';
	@override String get barcodeHint => 'ตัวอย่าง: 123456789012, 12 ตัวอักษร';
	@override String barcodeValidator({required Object name}) => 'กรอก $name เป็นจำนวน 12 ตัวอักษร หรือ ไม่ต้องกรอก';
	@override String get cost => 'ต้นทุน';
	@override String get costHint => 'ต้นทุนที่ซื้อมา';
	@override String get price => 'ราคา';
	@override String get priceHint => 'ราคาที่ขายไป';
	@override String get quantity => 'จำนวน';
	@override String get quantityHint => 'จำนวนในสต๊อก';
	@override String get image => 'รูป SKU';
}

class _StringsProductListPageTh implements _StringsProductListPageEn {
	_StringsProductListPageTh._(); // no constructor

	static final _StringsProductListPageTh _instance = _StringsProductListPageTh._();

	@override String get title => 'รายการสินค้า';
	@override String get sortById => 'ID';
	@override String get sortByNameAsc => 'ชื่อ น้อยไปมาก';
	@override String get sortByNameDesc => 'ชื่อ มากไปน้อย';
	@override String get create => 'สร้างสินค้า';
	@override String get createMore => 'สร้างสินค้า...';
	@override String get createHint => 'สร้างสินค้าใหม่.';
}

class _StringsProductEditPageTh implements _StringsProductEditPageEn {
	_StringsProductEditPageTh._(); // no constructor

	static final _StringsProductEditPageTh _instance = _StringsProductEditPageTh._();

	@override String title({required Object name}) => 'แก้ไข $name';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

late final Map<String, dynamic> _translationMapEn = {
	'app': 'Minigun',
	'switchLocale.english': 'English',
	'switchLocale.thai': 'ไทย',
	'common.close': 'Close',
	'common.ok': 'OK',
	'common.cancel': 'Cancel',
	'common.yes': 'Yes',
	'common.no': 'No',
	'common.retry': 'Retry',
	'common.name': 'Name',
	'common.value': 'Value',
	'common.create': 'Create',
	'common.createMore': 'Create...',
	'common.update': 'Save',
	'common.updateMore': 'Save...',
	'common.remove': 'Delete',
	'common.removeMore': 'Delete...',
	'question.areYouSureToExit': 'Are you sure to exit this program?',
	'question.areYouSureToDelete': 'Are you sure to delete this item?',
	'question.areYouSureToLeave': 'Are you sure to leave without save data?',
	'validator.isPositiveInt': ({required Object name}) => 'Please input $name as positive integer.',
	'validator.isPositiveOrZeroInt': ({required Object name}) => 'Please input $name as positive integer or zero.',
	'validator.isNegativeInt': ({required Object name}) => 'Please input $name as negative integer.',
	'validator.isNegativeOrZeroInt': ({required Object name}) => 'Please input $name as negative integer or zero.',
	'validator.isPositiveFloat': ({required Object name}) => 'Please input $name as positive floating-point.',
	'validator.isPositiveOrZeroFloat': ({required Object name}) => 'Please input $name as positive floating-point or zero.',
	'validator.isNegativeFloat': ({required Object name}) => 'Please input $name as negative floating-point.',
	'validator.isNegativeOrZeroFloat': ({required Object name}) => 'Please input $name as negative floating-point or zero.',
	'validator.isMoney': ({required Object name}) => 'Please input $name as money.',
	'messageBox.info': 'Information',
	'messageBox.warning': 'Warning',
	'messageBox.error': 'Error',
	'messageBox.question': 'Question',
	'waitBox.message': 'Please wait...',
	'serviceRunner.message': 'Network error!',
	'paginator.first': 'Go to first page.',
	'paginator.previous': 'Go to previous page.',
	'paginator.next': 'Go to next page.',
	'paginator.last': 'Go to last page.',
	'paginator.go': 'Go',
	'imageChooser.upload': 'Upload',
	'imageChooser.reset': 'Reset',
	'imageChooser.revert': 'Revert',
	'trash.trash': 'View in Trash',
	'trash.normal': 'View Normal',
	'appBar.openMenu': 'Open Profile Menu',
	'appBar.editProfileIcon': 'Edit Profile Icon...',
	'appBar.editDisplayName': 'Edit Display Name...',
	'appBar.editPassword': 'Edit Password...',
	'appBar.needRelogin': 'You have to re-login!',
	'appBar.logout': 'Logout',
	'searchBar.open': 'Open search...',
	'searchBar.hint': 'Search...',
	'editProfileIconPage.title': 'Edit Profile Icon',
	'editProfileIconPage.profileIcon': 'Profile Icon',
	'editProfileIconPage.profileIconUpload': 'Upload Profile Icon',
	'editProfileIconPage.profileIconReset': 'Reset Profile Icon',
	'editDisplayNamePage.title': 'Edit Display Name',
	'editDisplayNamePage.displayName': 'Display Name',
	'editDisplayNamePage.displayNameHint': 'min length: 4 characters, max length: 50 characters',
	'editDisplayNamePage.displayNameValidator': ({required Object name}) => 'Please input $name as 4-50 characters.',
	'editPasswordPage.title': 'Edit Password',
	'editPasswordPage.password': 'Password',
	'editPasswordPage.passwordHint': 'min length: 4 characters, max length: 20 characters',
	'editPasswordPage.passwordValidator': ({required Object name}) => 'Please input $name as 4-20 characters.',
	'editPasswordPage.confirmPassword': 'Confirm Password',
	'editPasswordPage.confirmPasswordHint': 'min length: 4 characters, max length: 20 characters',
	'editPasswordPage.confirmPasswordValidator': ({required Object name}) => 'Please input $name as 4-20 characters.',
	'drawerUi.title': 'Hello',
	'drawerUi.home': 'Home',
	'drawerUi.sku': 'SKU List',
	'drawerUi.product': 'Product List',
	'loginPage.title': 'Login',
	'loginPage.username': 'Username',
	'loginPage.password': 'Password',
	'loginPage.reset': 'Reset',
	'loginPage.ok': 'Login',
	'loginPage.or': '-- or --',
	'loginPage.register': 'Register...',
	'registerPage.title': 'Register',
	'registerPage.username': 'Username',
	'registerPage.usernameHint': 'min length: 4 characters, max length: 20 characters',
	'registerPage.usernameValidator': ({required Object name}) => 'Please input $name as 4-20 characters.',
	'registerPage.displayName': 'Display Name',
	'registerPage.displayNameHint': 'min length: 4 characters, max length: 50 characters',
	'registerPage.displayNameValidator': ({required Object name}) => 'Please input $name as 4-50 characters.',
	'registerPage.password': 'Password',
	'registerPage.passwordHint': 'min length: 4 characters, max length: 20 characters',
	'registerPage.passwordValidator': ({required Object name}) => 'Please input $name as 4-20 characters.',
	'registerPage.confirmPassword': 'Confirm Password',
	'registerPage.confirmPasswordHint': 'min length: 4 characters, max length: 20 characters',
	'registerPage.confirmPasswordValidator': ({required Object name}) => 'Please input $name as 4-20 characters.',
	'dashboardPage.title': 'Dashboard',
	'dashboardPage.displayName': 'Display Name',
	'dashboardPage.createdAi': 'Registered Date',
	'skuListPage.title': 'SKU List',
	'skuListPage.sortById': 'ID',
	'skuListPage.sortByCodeAsc': 'Code ASC',
	'skuListPage.sortByCodeDesc': 'Code DESC',
	'skuListPage.sortByBarcodeAsc': 'Barcode ASC',
	'skuListPage.sortByBarcodeDesc': 'Barcode DESC',
	'skuListPage.sortByCostAsc': 'Cost ASC',
	'skuListPage.sortByCostDesc': 'Cost DESC',
	'skuListPage.sortByPriceAsc': 'Price ASC',
	'skuListPage.sortByPriceDesc': 'Price DESC',
	'skuListPage.sortByQuantityAsc': 'Quantity ASC',
	'skuListPage.sortByQuantityDesc': 'Quantity DESC',
	'skuListPage.barcodeFormat': ({required Object barcode}) => 'Barcode: $barcode',
	'skuListPage.barcodeNotFound': 'Barcode not found.',
	'skuListPage.create': 'Create SKU',
	'skuListPage.createMore': 'Create SKU...',
	'skuListPage.createHint': 'Create a new SKU.',
	'skuEditPage.title': ({required Object name}) => 'Edit $name',
	'skuEditPage.barcode': 'Barcode',
	'skuEditPage.barcodeHint': 'such as: 123456789012, 12 digits or leave blank',
	'skuEditPage.barcodeValidator': ({required Object name}) => 'Please input $name as 12 characters or blank at all.',
	'skuEditPage.cost': 'Cost',
	'skuEditPage.costHint': 'cost to buy',
	'skuEditPage.price': 'Price',
	'skuEditPage.priceHint': 'price to sell',
	'skuEditPage.quantity': 'Quantity',
	'skuEditPage.quantityHint': 'quantity in stock',
	'skuEditPage.image': 'SKU Image',
	'productListPage.title': 'Product List',
	'productListPage.sortById': 'ID',
	'productListPage.sortByNameAsc': 'Name ASC',
	'productListPage.sortByNameDesc': 'Name DESC',
	'productListPage.create': 'Create Product',
	'productListPage.createMore': 'Create Product...',
	'productListPage.createHint': 'Create a new Product.',
	'productEditPage.title': ({required Object name}) => 'Edit $name',
};

late final Map<String, dynamic> _translationMapTh = {
	'app': 'ปืนกลเล็ก',
	'switchLocale.english': 'English',
	'switchLocale.thai': 'ไทย',
	'common.close': 'ปิด',
	'common.ok': 'ตกลง',
	'common.cancel': 'ยกเลิก',
	'common.yes': 'ใช่',
	'common.no': 'ไม่ใช่',
	'common.retry': 'ลองใหม่',
	'common.name': 'ชื่อ',
	'common.value': 'ค่า',
	'common.create': 'สร้าง',
	'common.createMore': 'สร้าง...',
	'common.update': 'บันทึก',
	'common.updateMore': 'บันทึก...',
	'common.remove': 'ลบ',
	'common.removeMore': 'ลบ...',
	'question.areYouSureToExit': 'คุณแน่ใจที่จะออกจากโปรแกรมนี้หรือไม่?',
	'question.areYouSureToDelete': 'คุณแน่ใจที่จะลบข้อมูลนี้หรือไม่?',
	'question.areYouSureToLeave': 'คุณแน่ใจที่จะออกจากหน้านี้โดยไม่เซฟข้อมูล?',
	'validator.isPositiveInt': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนเต็มบวก',
	'validator.isPositiveOrZeroInt': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนเต็มบวกหรือศูนย์',
	'validator.isNegativeInt': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนเต็มลบ',
	'validator.isNegativeOrZeroInt': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนเต็มลบหรือศูนย์',
	'validator.isPositiveFloat': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนทศนิยมบวก',
	'validator.isPositiveOrZeroFloat': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนทศนิยมบวกหรือศูนย์',
	'validator.isNegativeFloat': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนทศนิยมลบ',
	'validator.isNegativeOrZeroFloat': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนทศนิยมลบหรือศูนย์',
	'validator.isMoney': ({required Object name}) => 'กรอก $name เป็นเลขจำนวนเงิน.',
	'messageBox.info': 'ข้อมูลข่าวสาร',
	'messageBox.warning': 'แจ้งเตือน',
	'messageBox.error': 'เกิดข้อผิดพลาด',
	'messageBox.question': 'คำถาม',
	'waitBox.message': 'โปรดรอสักครู่...',
	'serviceRunner.message': 'เกิดข้อผิดพลาดบนเน็ตเวิร์ค!',
	'paginator.first': 'ไปยังหน้าแรก',
	'paginator.previous': 'ไปยังหน้าที่แล้ว',
	'paginator.next': 'ไปยังหน้าถัดไป',
	'paginator.last': 'ไปยังหน้าสุดท้าย',
	'paginator.go': 'ไป',
	'imageChooser.upload': 'อัพโหลด',
	'imageChooser.reset': 'รีเซ็ต',
	'imageChooser.revert': 'ย้อนกลับ',
	'trash.trash': 'ดูในถังขยะ',
	'trash.normal': 'ดูปกติ',
	'appBar.openMenu': 'เปิดโปรไฟล์เมนู',
	'appBar.editProfileIcon': 'ปรับปรุงโปรไฟล์ไอคอน...',
	'appBar.editDisplayName': 'แก้ไขชื่อของท่าน...',
	'appBar.editPassword': 'เปลี่ยนแปลงรหัสผ่าน...',
	'appBar.needRelogin': 'คุณต้องเข้าสู่ระบบอีกครั้ง!',
	'appBar.logout': 'ออกจากระบบ',
	'searchBar.open': 'เปิดการค้นหา...',
	'searchBar.hint': 'ค้นหา...',
	'editProfileIconPage.title': 'ปรับปรุงโปรไฟล์ไอคอน',
	'editProfileIconPage.profileIcon': 'โปรไฟล์ไอคอน',
	'editProfileIconPage.profileIconUpload': 'อัพโหลดรูปโปรไฟล์',
	'editProfileIconPage.profileIconReset': 'รีเซตเป็นค่าเดิม',
	'editDisplayNamePage.title': 'แก้ไขชื่อของท่าน',
	'editDisplayNamePage.displayName': 'ชื่อของท่าน',
	'editDisplayNamePage.displayNameHint': 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 50 ตัวอักษร',
	'editDisplayNamePage.displayNameValidator': ({required Object name}) => 'กรอก $name เป็นจำนวน 4-50 ตัวอักษร',
	'editPasswordPage.title': 'เปลี่ยนแปลงรหัสผ่าน',
	'editPasswordPage.password': 'รหัสผ่าน',
	'editPasswordPage.passwordHint': 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร',
	'editPasswordPage.passwordValidator': ({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร',
	'editPasswordPage.confirmPassword': 'ยืนยันรหัสผ่าน',
	'editPasswordPage.confirmPasswordHint': 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร',
	'editPasswordPage.confirmPasswordValidator': ({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร',
	'drawerUi.title': 'สวัสดี',
	'drawerUi.home': 'เริ่มต้น',
	'drawerUi.sku': 'รายการ SKU',
	'drawerUi.product': 'รายการสินค้า',
	'loginPage.title': 'เข้าสู่ระบบ',
	'loginPage.username': 'ชื่อผู้ใช้',
	'loginPage.password': 'รหัสผ่าน',
	'loginPage.reset': 'รีเซ็ต',
	'loginPage.ok': 'เข้าสู่ระบบ',
	'loginPage.or': '-- หรือ --',
	'loginPage.register': 'ลงทะเบียน...',
	'registerPage.title': 'ลงทะเบียน',
	'registerPage.username': 'ชื่อผู้ใช้',
	'registerPage.usernameHint': 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร',
	'registerPage.usernameValidator': ({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร',
	'registerPage.displayName': 'ชื่อของท่าน',
	'registerPage.displayNameHint': 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 50 ตัวอักษร',
	'registerPage.displayNameValidator': ({required Object name}) => 'กรอก $name เป็นจำนวน 4-50 ตัวอักษร',
	'registerPage.password': 'รหัสผ่าน',
	'registerPage.passwordHint': 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร',
	'registerPage.passwordValidator': ({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร',
	'registerPage.confirmPassword': 'ยืนยันรหัสผ่าน',
	'registerPage.confirmPasswordHint': 'ความยาวต่ำสุด: 4 ตัวอักษร, ความยาวสูงสุด: 20 ตัวอักษร',
	'registerPage.confirmPasswordValidator': ({required Object name}) => 'กรอก $name เป็นจำนวน 4-20 ตัวอักษร',
	'dashboardPage.title': 'กระดานของคุณ',
	'dashboardPage.displayName': 'ชื่อของท่าน',
	'dashboardPage.createdAi': 'วันที่ลงทะเบียน',
	'skuListPage.title': 'รายการ SKU',
	'skuListPage.sortById': 'ID',
	'skuListPage.sortByCodeAsc': 'Code น้อยไปมาก',
	'skuListPage.sortByCodeDesc': 'Code มากไปน้อย',
	'skuListPage.sortByBarcodeAsc': 'บาร์โค๊ด น้อยไปมาก',
	'skuListPage.sortByBarcodeDesc': 'บาร์โค๊ด มากไปน้อย',
	'skuListPage.sortByCostAsc': 'ต้นทุน น้อยไปมาก',
	'skuListPage.sortByCostDesc': 'ต้นทุน มากไปน้อย',
	'skuListPage.sortByPriceAsc': 'ราคา น้อยไปมาก',
	'skuListPage.sortByPriceDesc': 'ราคา มากไปน้อย',
	'skuListPage.sortByQuantityAsc': 'จำนวน น้อยไปมาก',
	'skuListPage.sortByQuantityDesc': 'จำนวน มากไปน้อย',
	'skuListPage.barcodeFormat': ({required Object barcode}) => 'บาร์โค๊ด: $barcode',
	'skuListPage.barcodeNotFound': 'ไม่พบบาร์โค๊ด',
	'skuListPage.create': 'สร้าง SKU',
	'skuListPage.createMore': 'สร้าง SKU...',
	'skuListPage.createHint': 'สร้าง SKU ใหม่',
	'skuEditPage.title': ({required Object name}) => 'แก้ไข $name',
	'skuEditPage.barcode': 'บาร์โค๊ด',
	'skuEditPage.barcodeHint': 'ตัวอย่าง: 123456789012, 12 ตัวอักษร',
	'skuEditPage.barcodeValidator': ({required Object name}) => 'กรอก $name เป็นจำนวน 12 ตัวอักษร หรือ ไม่ต้องกรอก',
	'skuEditPage.cost': 'ต้นทุน',
	'skuEditPage.costHint': 'ต้นทุนที่ซื้อมา',
	'skuEditPage.price': 'ราคา',
	'skuEditPage.priceHint': 'ราคาที่ขายไป',
	'skuEditPage.quantity': 'จำนวน',
	'skuEditPage.quantityHint': 'จำนวนในสต๊อก',
	'skuEditPage.image': 'รูป SKU',
	'productListPage.title': 'รายการสินค้า',
	'productListPage.sortById': 'ID',
	'productListPage.sortByNameAsc': 'ชื่อ น้อยไปมาก',
	'productListPage.sortByNameDesc': 'ชื่อ มากไปน้อย',
	'productListPage.create': 'สร้างสินค้า',
	'productListPage.createMore': 'สร้างสินค้า...',
	'productListPage.createHint': 'สร้างสินค้าใหม่.',
	'productEditPage.title': ({required Object name}) => 'แก้ไข $name',
};
