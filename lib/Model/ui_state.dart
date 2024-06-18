abstract class UIState {}

class ErrorUIState extends UIState {
  final String message;
  final int code;

  ErrorUIState(this.message, {this.code = 0});
}

class IdleUIState extends UIState {}

class LoadingUIState extends UIState {}

class NoResultUIState extends UIState {
  NoResultUIState();
}

class UnAuthenticatedUIState extends ErrorUIState {
  UnAuthenticatedUIState(super.message);
}

class ResultUIState<T, ContainerType> extends UIState {
  final ContainerType result;

  ResultUIState(this.result);
}
