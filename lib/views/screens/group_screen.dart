import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:student_system/models/group.dart';
import 'package:student_system/providers/group_provider.dart';
import 'package:student_system/views/widgets/custom_text_form_field.dart';

class GroupScreen extends StatefulWidget {
  final Group? group;
  static String routeName = "/group_screen";

  const GroupScreen({super.key, this.group});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final _formKey = GlobalKey<FormState>();
  late Group _editGroup;

  @override
  void initState() {
    super.initState();
    _editGroup = widget.group ?? Group();
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.group == null
              ? translate("add_group")
              : translate("edit_group"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                hintText: "group_name",
                value: _editGroup.name,
                onChanged: (value) {
                  _editGroup.name = value!;
                  setState(() {});
                },
                required: true,
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _saveGroup(groupProvider),
                child: Text(
                  widget.group == null
                      ? translate("add_group")
                      : translate("edit_group"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveGroup(GroupProvider groupProvider) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.group == null) {
          // Add new group
          await groupProvider.addGroup(_editGroup);
        } else {
          // Update existing group
          await groupProvider.updateGroup(_editGroup);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving group: ${e.toString()}')),
        );
      }
    }
  }
}
