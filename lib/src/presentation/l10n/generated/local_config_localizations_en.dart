// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'local_config_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LocalConfigLocalizationsEn extends LocalConfigLocalizations {
  LocalConfigLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localConfig => 'Local Config';

  @override
  String get search => 'Search';

  @override
  String get changesApplied => 'Changes applied';

  @override
  String get changed => 'Changed';

  @override
  String get revertAll => 'Revert all';

  @override
  String get revert => 'Revert';

  @override
  String get editParameter => 'Edit parameter';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get parameterName => 'Parameter name (key)';

  @override
  String get dataType => 'Data type';

  @override
  String get value => 'Value';

  @override
  String get close => 'Close';

  @override
  String get fullScreenEditor => 'Full screen editor';

  @override
  String get noResults =>
      'No parameters, values, or conditions matched your search criteria.';

  @override
  String get showOnlyChanged => 'Show only changed';

  @override
  String get noConfigs =>
      'No configurations are available. Ensure default parameters are set before accessing the configurations.';

  @override
  String get uninitialized =>
      'LocalConfig has not been initialized. Ensure it is initialized before accessing the configurations.';

  @override
  String get emptyString => '(empty string)';

  @override
  String get boolean => 'Boolean';

  @override
  String get number => 'Number';

  @override
  String get invalidBoolean => 'Invalid Boolean';

  @override
  String get invalidNumber => 'Invalid Number';

  @override
  String get invalidJson => 'Invalid JSON';

  @override
  String get validJson => 'Valid JSON';

  @override
  String get help =>
      'This is the key you\'ll pass to the Local Config SDK,\nfor example:\n';

  @override
  String get format => 'Format';

  @override
  String editorOf(Object type) {
    return '$type Editor';
  }
}
