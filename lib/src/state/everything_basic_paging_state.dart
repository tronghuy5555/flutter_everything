import 'package:flutter/foundation.dart';

import 'package:flutter_everything/src/state/everything_basic_state.dart';

typedef EverythingPagingState<T>
    = EverythingBasicState<EverythingBasicPagingState<T>>;

class EverythingBasicPagingState<T> {
  final int limit;
  final int page;
  final num? total;
  final List<T> data;
  final bool isDirty;
  final bool shouldLoadMore;
  final dynamic extraData;

  bool get isFinish => !shouldLoadMore;

  const EverythingBasicPagingState({
    this.page = 1,
    required this.limit,
    required this.data,
    this.isDirty = false,
    this.shouldLoadMore = true,
    this.total,
    this.extraData,
  });

  factory EverythingBasicPagingState.basic({
    required int page,
    required int limit,
    required List<T> lastResult,
    required List<T> newResult,
    num? total,
  }) {
    final newData = <T>[...lastResult, ...newResult];

    return EverythingBasicPagingState<T>(
      limit: limit,
      page: page + 1,
      shouldLoadMore: newResult.length >= limit,
      data: newData,
      total: total,
    );
  }

  EverythingBasicPagingState<T> copyWith({
    int? limit,
    int? page,
    List<T>? data,
    bool? isDirty,
    bool? shouldLoadMore,
    num? total,
    dynamic extraData,
  }) {
    return EverythingBasicPagingState<T>(
      limit: limit ?? this.limit,
      page: page ?? this.page,
      data: data ?? this.data,
      isDirty: isDirty ?? this.isDirty,
      shouldLoadMore: shouldLoadMore ?? this.shouldLoadMore,
      total: total ?? this.total,
      extraData: extraData ?? this.extraData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EverythingBasicPagingState<T> &&
        other.limit == limit &&
        other.page == page &&
        listEquals(other.data, data) &&
        other.isDirty == isDirty &&
        other.shouldLoadMore == shouldLoadMore &&
        other.total == total &&
        other.extraData == extraData;
  }

  @override
  int get hashCode {
    return limit.hashCode ^
        page.hashCode ^
        data.hashCode ^
        isDirty.hashCode ^
        shouldLoadMore.hashCode ^
        total.hashCode ^
        extraData.hashCode;
  }

  @override
  String toString() {
    return 'EverythingBasicPagingState(limit: $limit, page: $page, data: $data, isDirty: $isDirty, shouldLoadMore: $shouldLoadMore, total: $total, extraData: $extraData)';
  }
}
