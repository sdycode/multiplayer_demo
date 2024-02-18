// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/navigateWithTransition.dart';

import 'package:multiplayer_demo/models/group_model.dart';
import 'package:multiplayer_demo/screens/group_detail_page.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';

class GroupWidget extends StatelessWidget {
  final GroupModel groupModel;
  const GroupWidget({
    Key? key,
    required this.groupModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        navigateWithTransitionToScreen(
            context, GroupDetailedPage(groupModel: groupModel));
      },
      child: Card(
        child: Column(
          children: [
            TextWithFontWidget.black(text: groupModel.groupName),
          ],
        ).paddingWidget(),
      ),
    );
  }
}
