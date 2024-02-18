import 'package:flutter/material.dart';
import 'package:multiplayer_demo/constants/paths.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/special/createOrUpdateGroup.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/models/group_model.dart';
import 'package:multiplayer_demo/specials/data.dart';

Future openGroupCreationSheet(
  BuildContext context,
  TextEditingController groupNameController,
) async {
  if (isInvalidCurrentUser) {
    return;
  }
  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        List<String> selectedMembers = [];
        // allUsers.map((e) => e.ui);
        return StatefulBuilder(builder: (context, state) {
          return Column(
            children: [
              TextField(
                controller: groupNameController,
              ),
              ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (c, i) {
                    return ElevatedButton.icon(
                        onPressed: () {
                          if (selectedMembers.contains(allUsers[i].uid)) {
                            selectedMembers.remove(allUsers[i].uid);
                          } else {
                            selectedMembers.add(allUsers[i].uid);
                          }
                          state(() {});
                        },
                        icon: Icon(selectedMembers.contains(allUsers[i].uid)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        label: Text(
                          allUsers[i].name + "\n" + allUsers[i].uid,
                          maxLines: 5,
                        ));
                  }).expnd(),
              "Create Group".roundButton(onTap: () async {
                if (groupNameController.text.isNotEmpty) {
                  String groupId =
                      "${validUser.uid}_${DateTime.now().millisecondsSinceEpoch}";

                  GroupModel groupModel = GroupModel(
                      id: groupId,
                      adminUid: validUser.uid,
                      groupName: groupNameController.text.trim(),
                      membersIds: selectedMembers);
                  await createOrUpdateGroup(groupModel);
                }
              }).paddingWidget()
            ],
          ).maxHeightForWidget(h * 0.8);
        });
      });
}
