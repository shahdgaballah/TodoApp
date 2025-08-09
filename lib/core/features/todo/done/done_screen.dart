import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/todo/controller/cubit.dart';
import '../../../layout/todo/controller/state.dart';
import '../../../shared/widgets/build_item.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var tasks = AppCubit.get(context).doneTasks;
        return BuildItem(tasks: tasks);
      },
    );

  }
}
