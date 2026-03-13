const _snakeCasePattern = r'^[a-z0-9_]+$';

bool isSnakeCase(String value) =>
    value.isNotEmpty && RegExp(_snakeCasePattern).hasMatch(value);
