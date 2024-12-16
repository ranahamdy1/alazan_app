import 'package:alazan_app/core/helper/dio_helper.dart';
import 'package:alazan_app/core/utils/app_end_points.dart';
import 'package:alazan_app/features/models/alazan_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'alazan_state.dart';

class AlazansCubit extends Cubit<AlazanState> {
  AlazansCubit() : super(AlazanInitialState());

  static AlazansCubit get(context) => BlocProvider.of(context);
  AlazanModel? alazanModel;

  void getAlazan() {
    emit(AlazanLoadingState());
    DioHelper.getData(
      url: Endpoints.time,
    ).then((value) async {
      alazanModel = AlazanModel.fromJson(value.data);
      emit(AlazanSuccessState(alazanModel));
    }).catchError((onError) {
      emit(AlazanFailedState(msg: onError.toString()));
      print(onError);
    });
  }
}
