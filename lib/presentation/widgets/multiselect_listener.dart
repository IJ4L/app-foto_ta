import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_ta/presentation/cubits/foto_page_cubit.dart';
import 'package:foto_ta/presentation/cubits/multi_select_cubit.dart';

class MultiselectListener extends StatelessWidget {
  final Widget child;

  const MultiselectListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MultiSelectCubit, MultiSelectState>(
      listener: (context, state) {
        // Use BlocListener to avoid setState during build
        // Update the FotoPageCubit with the multi-select mode state
        context.read<FotoPageCubit>().setMultiSelectMode(
          state.isMultiSelectMode,
        );
      },
      child: child,
    );
  }
}
