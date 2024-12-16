import 'package:alazan_app/features/models/alazan_model.dart';

abstract class AlazanState {}

class AlazanInitialState extends AlazanState {}

class AlazanLoadingState extends AlazanState {}

class AlazanSuccessState extends AlazanState {
  final AlazanModel? alazanModel;

  AlazanSuccessState(this.alazanModel);
}

class AlazanFailedState extends AlazanState {
  final String msg;

  AlazanFailedState({required this.msg});
}
