import 'dart:async';
import 'package:rxdart/rxdart.dart';

extension EverythingStreamSubscriptionExt on StreamSubscription {
  void disposed(List<StreamSubscription> subscription) {
    subscription.add(this);
  }
}

extension EverythingStreamListExt on List<StreamSubscription> {
  void close() {
    for (var element in this) {
      unawaited(element.cancel());
    }
  }
}

extension EverythingStreamExt on Stream<String> {
  Stream<Result> searchStream<Result>({
    Duration? debounceDuration,
    required Future<Result> Function(String keyword) fetchData,
    required Future<Result> Function() emptyResult,
  }) {
    return debounceTime(
      debounceDuration ??
          const Duration(
            milliseconds: 300,
          ),
    ).switchMap(
      (s) => Stream.fromFuture(s.trim().isEmpty ? emptyResult() : fetchData(s)),
    );
  }
}
