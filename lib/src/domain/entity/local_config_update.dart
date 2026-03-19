/// Represents an update to the parameters, containing the keys that were updated.
class LocalConfigUpdate {
  final Set<String> updatedKeys;

  LocalConfigUpdate(this.updatedKeys);
}
