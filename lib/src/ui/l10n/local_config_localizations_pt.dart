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
  String get showChangesOnly => 'Mostrar apenas as mudanças';

  @override
  String get noConfigsQuestion => 'SEM CONFIGURAÇÕES?!';

  @override
  String get possibleCauses => 'Isso pode acontecer por alguns motivos:';

  @override
  String get uninitializedTitle => '• A inicialização não foi feita.';

  @override
  String get uninitializedDescription =>
      'Tem certeza de que a biblioteca inicializada do jeito certo?';

  @override
  String get emptyConfigsTitle => '• As configurações estão vazias.';

  @override
  String get emptyConfigsDescription =>
      'Pode ser que você tenha passado as configs vazias na inicialização.';

  @override
  String get loadingConfigsTitle => '• As configs ainda não chegaram.';

  @override
  String get loadingConfigsDescription =>
      'É raro, mas dependendo da inicialização, pode haver um pequeno atraso.';

  @override
  String get openGitHubIssue =>
      'Se nada funcionar, abra uma issue no GitHub que a gente te ajuda.';

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
