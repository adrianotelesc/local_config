// GENERATED FILE — DO NOT EDIT

// ignore_for_file: unused_import
import 'package:flutter_test/flutter_test.dart';

import 'package:local_config/local_config.dart';
import 'package:local_config/src/common/extension/map_extension.dart';
import 'package:local_config/src/common/extension/string_extension.dart';
import 'package:local_config/src/common/util/json_safe_convert.dart';
import 'package:local_config/src/common/util/key_validation.dart';
import 'package:local_config/src/common/util/stringify.dart';
import 'package:local_config/src/core/di/service_locator.dart';
import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/default_key_value_data_source.dart';
import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/data/repository/default_config_repository.dart';
import 'package:local_config/src/data/repository/no_op_config_repository.dart';
import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/domain/manager/config_manager.dart';
import 'package:local_config/src/domain/manager/default_config_manager.dart';
import 'package:local_config/src/domain/policy/baseline_value_prune_policy.dart';
import 'package:local_config/src/domain/policy/composite_prune_policy.dart';
import 'package:local_config/src/domain/policy/mismatch_qualified_prefix_prune_policy.dart';
import 'package:local_config/src/domain/policy/missing_retained_key_prune_policy.dart';
import 'package:local_config/src/domain/policy/prune_policy.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';
import 'package:local_config/src/infra/di/get_it_service_locator.dart';
import 'package:local_config/src/infra/di/internal_service_locator.dart';
import 'package:local_config/src/infra/storage/secure_storage_key_value_store.dart';
import 'package:local_config/src/infra/storage/shared_preferences_key_value_store.dart';
import 'package:local_config/src/local_config.dart';
import 'package:local_config/src/ui/extension/config_display_extension.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations_en.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations_pt.dart';
import 'package:local_config/src/ui/local_config_entrypoint.dart';
import 'package:local_config/src/ui/local_config_routes.dart';
import 'package:local_config/src/ui/local_config_theme.dart';
import 'package:local_config/src/ui/page/config_edit_page.dart';
import 'package:local_config/src/ui/page/config_list_page.dart';
import 'package:local_config/src/ui/widget/callout.dart';
import 'package:local_config/src/ui/widget/clearable_search_bar.dart';
import 'package:local_config/src/ui/widget/extended_list_tile.dart';
import 'package:local_config/src/ui/widget/input_form_field.dart';
import 'package:local_config/src/ui/widget/root_aware_sliver_app_bar.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/json_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/string_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/text_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/text_editor.dart';

void main() {}
