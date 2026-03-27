// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'local_config_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class LocalConfigLocalizationsPt extends LocalConfigLocalizations {
  LocalConfigLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get localConfig => 'Configuração Local';

  @override
  String get search => 'Buscar';

  @override
  String get changesApplied => 'Alterações aplicadas';

  @override
  String get changed => 'Alterado';

  @override
  String get revertAll => 'Reverter tudo';

  @override
  String get revert => 'Reverter';

  @override
  String get editParameter => 'Editar parâmetro';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Salvar';

  @override
  String get parameterName => 'Nome do parâmetro (chave)';

  @override
  String get dataType => 'Tipo de dado';

  @override
  String get value => 'Valor';

  @override
  String get close => 'Fechar';

  @override
  String get fullScreenEditor => 'Editor de tela cheia';

  @override
  String get noResults =>
      'Nenhum parâmetro, valor ou condição corresponde aos critérios de pesquisa.';

  @override
  String get showOnlyChanged => 'Mostrar apenas os alterados';

  @override
  String get noConfigs =>
      'Nenhum configuração está disponível. Certifique-se de que os parâmetros padrão estejam definidos antes de acessar as configurações.';

  @override
  String get uninitialized =>
      'LocalConfig não foi inicializado. Certifique-se de que esteja inicializado antes de acessar as configurações.';

  @override
  String get emptyString => '(string vazia)';

  @override
  String get boolean => 'Booleano';

  @override
  String get number => 'Número';

  @override
  String get invalidBoolean => 'Booleano Inválido';

  @override
  String get invalidNumber => 'Número Inválido';

  @override
  String get invalidJson => 'JSON Inválido';

  @override
  String get validJson => 'JSON Válido';

  @override
  String get help =>
      'Essa é a chave que você vai passar para o SDK da Configuração Local, por exemplo:\n';

  @override
  String get format => 'Formatar';

  @override
  String editorOf(Object type) {
    return 'Editor de $type';
  }
}
