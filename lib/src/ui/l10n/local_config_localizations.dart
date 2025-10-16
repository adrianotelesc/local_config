import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'local_config_localizations_en.dart';
import 'local_config_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of LocalConfigLocalizations
/// returned by `LocalConfigLocalizations.of(context)`.
///
/// Applications need to include `LocalConfigLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/local_config_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: LocalConfigLocalizations.localizationsDelegates,
///   supportedLocales: LocalConfigLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the LocalConfigLocalizations.supportedLocales
/// property.
abstract class LocalConfigLocalizations {
  LocalConfigLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static LocalConfigLocalizations? of(BuildContext context) {
    return Localizations.of<LocalConfigLocalizations>(context, LocalConfigLocalizations);
  }

  static const LocalizationsDelegate<LocalConfigLocalizations> delegate = _LocalConfigLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @localConfig.
  ///
  /// In en, this message translates to:
  /// **'Local Config'**
  String get localConfig;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @changesApplied.
  ///
  /// In en, this message translates to:
  /// **'Changes applied'**
  String get changesApplied;

  /// No description provided for @changed.
  ///
  /// In en, this message translates to:
  /// **'Changed'**
  String get changed;

  /// No description provided for @revertAll.
  ///
  /// In en, this message translates to:
  /// **'Revert all'**
  String get revertAll;

  /// No description provided for @revert.
  ///
  /// In en, this message translates to:
  /// **'Revert'**
  String get revert;

  /// No description provided for @editParameter.
  ///
  /// In en, this message translates to:
  /// **'Edit parameter'**
  String get editParameter;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @parameterName.
  ///
  /// In en, this message translates to:
  /// **'Parameter name (key)'**
  String get parameterName;

  /// No description provided for @dataType.
  ///
  /// In en, this message translates to:
  /// **'Data type'**
  String get dataType;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @fullScreenEditor.
  ///
  /// In en, this message translates to:
  /// **'Full screen editor'**
  String get fullScreenEditor;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No parameters, values, or conditions matched your search criteria.'**
  String get noResults;

  /// No description provided for @showChangesOnly.
  ///
  /// In en, this message translates to:
  /// **'Show changes only'**
  String get showChangesOnly;

  /// No description provided for @noConfigsQuestion.
  ///
  /// In en, this message translates to:
  /// **'NO CONFIGS!?'**
  String get noConfigsQuestion;

  /// No description provided for @possibleCauses.
  ///
  /// In en, this message translates to:
  /// **'This might be happening for a few reasons:'**
  String get possibleCauses;

  /// No description provided for @uninitializedTitle.
  ///
  /// In en, this message translates to:
  /// **'• The initialization wasn\'t done.'**
  String get uninitializedTitle;

  /// No description provided for @uninitializedDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you initialized the lib the right way?'**
  String get uninitializedDescription;

  /// No description provided for @emptyConfigsTitle.
  ///
  /// In en, this message translates to:
  /// **'• The configs are empty.'**
  String get emptyConfigsTitle;

  /// No description provided for @emptyConfigsDescription.
  ///
  /// In en, this message translates to:
  /// **'You might have passed empty configs in the initialization.'**
  String get emptyConfigsDescription;

  /// No description provided for @loadingConfigsTitle.
  ///
  /// In en, this message translates to:
  /// **'• The configs haven\'t arrived yet.'**
  String get loadingConfigsTitle;

  /// No description provided for @loadingConfigsDescription.
  ///
  /// In en, this message translates to:
  /// **'It\'s rare, but depending on the initialization, there might be a small delay.'**
  String get loadingConfigsDescription;

  /// No description provided for @openGitHubIssue.
  ///
  /// In en, this message translates to:
  /// **'If nothing works, open a GitHub issue that we\'ll help you.'**
  String get openGitHubIssue;

  /// No description provided for @emptyString.
  ///
  /// In en, this message translates to:
  /// **'(empty string)'**
  String get emptyString;

  /// No description provided for @boolean.
  ///
  /// In en, this message translates to:
  /// **'Boolean'**
  String get boolean;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @invalidBoolean.
  ///
  /// In en, this message translates to:
  /// **'Invalid Boolean'**
  String get invalidBoolean;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Number'**
  String get invalidNumber;

  /// No description provided for @invalidJson.
  ///
  /// In en, this message translates to:
  /// **'Invalid JSON'**
  String get invalidJson;

  /// No description provided for @validJson.
  ///
  /// In en, this message translates to:
  /// **'Valid JSON'**
  String get validJson;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'This is the key you\'ll pass to the Local Config SDK,\nfor example:\n'**
  String get help;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @editorOf.
  ///
  /// In en, this message translates to:
  /// **'{type} Editor'**
  String editorOf(Object type);
}

class _LocalConfigLocalizationsDelegate extends LocalizationsDelegate<LocalConfigLocalizations> {
  const _LocalConfigLocalizationsDelegate();

  @override
  Future<LocalConfigLocalizations> load(Locale locale) {
    return SynchronousFuture<LocalConfigLocalizations>(lookupLocalConfigLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalConfigLocalizationsDelegate old) => false;
}

LocalConfigLocalizations lookupLocalConfigLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return LocalConfigLocalizationsEn();
    case 'pt': return LocalConfigLocalizationsPt();
  }

  throw FlutterError(
    'LocalConfigLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
