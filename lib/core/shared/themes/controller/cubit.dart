import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/shared/themes/controller/state.dart';

import '../../network/cache_helper.dart';
class ThemeModeCubit extends Cubit<ThemeModeStates>{

  ThemeModeCubit(): super(InitialThemeModeState());

  static ThemeModeCubit get(context)=>BlocProvider.of(context);

  bool isDark = false;

  void changeThemeMode({
    bool? fromShared,
  })
  {
    if(fromShared != null){
      isDark = fromShared;
      emit(ChangeThemeModeState());
    }else{
      isDark = !isDark;
      CacheHelper.setData(key: 'isDark', value: isDark).then((value){
        emit(ChangeThemeModeState());
      });
    }
  }

}