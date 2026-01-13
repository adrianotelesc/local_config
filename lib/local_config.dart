import 'package:flutter/material.dart';
import 'package:local_config/src/data/manager/config_manager.dart';
import 'package:local_config/src/data/manager/default_config_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_config/src/core/di/service_locator.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/default_key_value_data_source.dart';
import 'package:local_config/src/data/repository/default_config_repository.dart';
import 'package:local_config/src/data/repository/no_op_config_repository.dart';
import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';
import 'package:local_config/src/infra/di/get_it_service_locator.dart';
import 'package:local_config/src/infra/storage/namespaced_key_value_store.dart';
import 'package:local_config/src/infra/storage/shared_preferences_key_value_store.dart';
import 'package:local_config/src/common/util/key_namespace.dart';
import 'package:local_config/src/ui/local_config_entrypoint.dart';

export 'package:local_config/src/infra/storage/shared_preferences_key_value_store.dart';
export 'package:local_config/src/infra/storage/secure_storage_key_value_store.dart';

part 'src/local_config.dart';
