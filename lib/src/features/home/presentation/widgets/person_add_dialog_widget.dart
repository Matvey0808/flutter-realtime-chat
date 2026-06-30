import 'package:flutter/material.dart';

void showDialogPersonAdd(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return PersonAddDialogWidget();
    },
  );
}

class PersonAddDialogWidget extends StatelessWidget {
  const PersonAddDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Center(child: Text("Persons"))],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Alice"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Bob"),
            ),
          ],
        ),
      ],
    );
  }
}
