import 'package:flutter/material.dart';

class EditAndDeleteButtons extends StatefulWidget {
  void Function()? onEditTapped;
  void Function()? onDeleteTapped;

  EditAndDeleteButtons({super.key, this.onEditTapped, this.onDeleteTapped});

  @override
  State<EditAndDeleteButtons> createState() => _EditAndDeleteButtonsState();
}

class _EditAndDeleteButtonsState extends State<EditAndDeleteButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: widget.onEditTapped,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: widget.onDeleteTapped,
        ),
      ],
    );
  }
}
