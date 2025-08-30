import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:student_system/config/app_colors.dart';
import 'package:student_system/providers/group_provider.dart';
import 'package:student_system/views/screens/group_screen.dart';
import 'package:student_system/views/widgets/custom_floating_action_button.dart';
import 'package:student_system/views/widgets/edit_and_delete_buttons.dart';

class GroupListView extends StatefulWidget {
  static String routeName = "/group_list_view";

  const GroupListView({super.key});

  @override
  State<GroupListView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadGroups();
    });
  }

  _loadGroups() async {
    final provider = Provider.of<GroupProvider>(context, listen: false);
    await provider.loadGroupsFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GroupProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(translate('groups'))),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, GroupScreen.routeName);
        },
      ),
      body: provider.groups.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.groups.length,
              itemBuilder: (context, index) {
                final group = provider.groups[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      group.name ?? 'Unnamed Group',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text('ID: ${group.id ?? 'N/A'}'),
                        if (group.createdAt != null)
                          Text('Created: ${group.createdAt!.toLocal().toString().split(' ')[0]}'),
                        if (group.updatedAt != null)
                          Text('Updated: ${group.updatedAt!.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                    trailing: EditAndDeleteButtons(
                      onDeleteTapped: () => provider.deleteGroupByIndex(index),
                      onEditTapped: () => provider.editGroup(context, group),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
