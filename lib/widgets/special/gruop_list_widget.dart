import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/special/createOrUpdateGroup.dart';
import 'package:multiplayer_demo/models/group_model.dart';
import 'package:multiplayer_demo/widgets/special/group_widget.dart';

class GroupListWidget extends StatelessWidget {
  const GroupListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getGroups(),
        builder: (context, snap) {
          if (!snap.hasData) return SizedBox();
          List<GroupModel> groups = snap.data as List<GroupModel>;
          return Row(
            children: List.generate(
                groups.length, (i) => GroupWidget(groupModel: groups[i])),
          ).scrollRowWidget();
        });
  }
}
