import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// 全局应用 logger。
final Logger appLogger = Logger('flstash');

/// 在 `main` 中调用，配置 logging 库的根级别与控制台输出。
void initLogging() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '[${record.level.name}] ${record.loggerName}: ${record.message}'
      '${record.error != null ? ' | ${record.error}' : ''}',
    );
    if (record.stackTrace != null) {
      debugPrint(record.stackTrace.toString());
    }
  });
}

/// 给 Service / Model 等使用的便捷日志封装。
void logMessage(
  Object? message, {
  Object? error,
  StackTrace? trace,
  Level level = Level.WARNING,
}) {
  appLogger.log(level, message, error, trace);
}
