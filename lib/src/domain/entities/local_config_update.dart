import 'package:collection/collection.dart';

/// Represents an update to the parameters, containing the keys that were updated.
class LocalConfigUpdate {
  LocalConfigUpdate(this.updatedKeys);

  final Set<String> updatedKeys;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalConfigUpdate &&
          SetEquality<String>().equals(updatedKeys, other.updatedKeys);

  @override
  int get hashCode => SetEquality<String>().hash(updatedKeys);
}
