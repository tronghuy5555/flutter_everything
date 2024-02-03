enum EverythingBasicStatus {
  initial,
  loading,
  error,
  success,
}

typedef ResultStateBuilder<R> = R Function();
typedef SuccessResultStateBuilder<R, T> = R Function(T? data);
typedef ErrorResultStateBuilder<R> = R Function(Object? error);

class EverythingBasicState<T> {
  final T? data;
  final Object? error;
  final Object? loadingData;
  final EverythingBasicStatus status;

  bool get hasData => data != null;
  bool get hasError => error != null;

  const EverythingBasicState({
    this.data,
    this.error,
    this.loadingData,
    this.status = EverythingBasicStatus.initial,
  });

  factory EverythingBasicState.initial() {
    return const EverythingBasicState(
      status: EverythingBasicStatus.initial,
    );
  }

  factory EverythingBasicState.loading({Object? loadingData}) {
    return EverythingBasicState(
      status: EverythingBasicStatus.loading,
      loadingData: loadingData,
    );
  }

  factory EverythingBasicState.success({required T? data}) {
    return EverythingBasicState(
      status: EverythingBasicStatus.success,
      data: data,
    );
  }

  factory EverythingBasicState.error({Object? error}) {
    return EverythingBasicState(
      status: EverythingBasicStatus.error,
      error: error,
    );
  }

  EverythingBasicState<E> copyWith<E>({
    E? data,
    Object? error,
    Object? loadingData,
    EverythingBasicStatus? status,
  }) {
    return EverythingBasicState<E>(
      data: data ?? (this.data is E ? (this.data as E) : null),
      error: error ?? this.error,
      loadingData: loadingData ?? this.loadingData,
      status: status ?? this.status,
    );
  }

  R? dataBuilder<R>({
    ResultStateBuilder<R>? onInitial,
    ResultStateBuilder<R>? onLoading,
    SuccessResultStateBuilder<R, T>? onSuccess,
    ErrorResultStateBuilder<R>? onError,
  }) {
    switch (status) {
      case EverythingBasicStatus.initial:
        return onInitial?.call();
      case EverythingBasicStatus.loading:
        if (hasData) {
          return onSuccess?.call(data);
        }
        return onLoading?.call();
      case EverythingBasicStatus.error:
        if (hasData) {
          return onSuccess?.call(data);
        }
        return onError?.call(error);
      case EverythingBasicStatus.success:
        return onSuccess?.call(data);
    }
  }

  R? listener<R>({
    ResultStateBuilder<R>? onInitial,
    ResultStateBuilder<R>? onLoading,
    SuccessResultStateBuilder<R, T>? onSuccess,
    ErrorResultStateBuilder<R>? onError,
  }) {
    switch (status) {
      case EverythingBasicStatus.initial:
        return onInitial?.call();
      case EverythingBasicStatus.loading:
        return onLoading?.call();
      case EverythingBasicStatus.error:
        return onError?.call(error);
      case EverythingBasicStatus.success:
        return onSuccess?.call(data);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EverythingBasicState<T> &&
        other.data == data &&
        other.error == error &&
        other.loadingData == loadingData &&
        other.status == status;
  }

  @override
  int get hashCode {
    return data.hashCode ^
        error.hashCode ^
        loadingData.hashCode ^
        status.hashCode;
  }
}
