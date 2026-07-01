import 'package:flutter/material.dart';
import 'package:flutter_realtime_chat/src/features/home/presentation/bloc/room_cubit.dart';

void showDialogPersonAdd(BuildContext context, RoomCubit cubit) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return PersonAddDialogWidget(cubit: cubit);
    },
  );
}

class PersonAddDialogWidget extends StatelessWidget {
  const PersonAddDialogWidget({super.key, required this.cubit});

  final RoomCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Center(child: Text("Persons"))],
      ),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            onPressed: () {
              cubit.createUsers();
            },
            child: Text("Create Users")
          ),
        ),
      ],
    );
  }
}
