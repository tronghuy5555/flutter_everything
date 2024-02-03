import 'package:flutter/material.dart';
import 'package:flutter_everything/src/src.dart';

abstract class EverythingPagingDelegate<T> {
  final EverythingPagingState<T> Function() getCurrentState;

  EverythingPagingDelegate({required this.getCurrentState});

  Future<bool> getData({bool isRefresh = true});

  Future<bool> getMoreData();
}

typedef OnChangePagingState<T> = void Function(T previous, T current);
typedef DefaultEverythingPagingDelegate<T>
    = EverythingPagingDelegateImpl<T, dynamic>;

class EverythingPagingDelegateImpl<T, Request>
    extends EverythingPagingDelegate<T> {
  final OnChangePagingState<EverythingPagingState<T>> onChangeState;
  final int initialPage;
  final int limit;
  final ValueChanged<bool>? onLoading;
  Request? _extraRequest;
  Request? get extraRequest => _extraRequest;

  final Future<EverythingBasicPagingState<T>> Function(
    int page,
    int limit,
    List<T> lastResult,
    Request? extraRequest,
  ) fetchDataFromSource;

  EverythingPagingDelegateImpl({
    this.initialPage = 1,
    this.limit = 20,
    this.onLoading,
    required this.fetchDataFromSource,
    required super.getCurrentState,
    required this.onChangeState,
  });
  EverythingPagingState<T> get currentState => getCurrentState();

  @override
  Future<bool> getData({
    bool isRefresh = true,
    EverythingExtraRequestConfig? extraRequest,
  }) async {
    if (isRefresh) {
      onChangeState(
        currentState,
        currentState.copyWith(status: EverythingBasicStatus.loading),
      );
    }

    onLoading?.call(isRefresh);
    final currentPage =
        isRefresh ? initialPage : (currentState.data?.page ?? initialPage);
    try {
      final lastResult =
          isRefresh ? <T>[] : (currentState.data?.data.toList() ?? <T>[]);
      final result = await fetchDataFromSource(
        currentPage,
        limit,
        lastResult,
        extraRequest?.request,
      );
      if (isRefresh && extraRequest?.isCleanUp == false) {
        _extraRequest = extraRequest?.request;
      }
      onChangeState(
        currentState,
        currentState.copyWith(
          data: result,
          status: EverythingBasicStatus.success,
        ),
      );
      return true;
    } catch (e) {
      onChangeState(
        currentState,
        currentState.copyWith(
          error: e,
          status: EverythingBasicStatus.error,
        ),
      );
      return false;
    }
  }

  @override
  Future<bool> getMoreData() {
    return getData(isRefresh: false);
  }
}

class EverythingExtraRequestConfig<T> {
  final T? request;
  final bool isCleanUp;

  EverythingExtraRequestConfig({
    required this.request,
    this.isCleanUp = false,
  });
}
