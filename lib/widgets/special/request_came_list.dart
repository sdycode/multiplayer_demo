import 'package:flutter/material.dart';
import 'package:multiplayer_demo/extensions/exte_paths.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/get_stream_for_came_requests.dart';
import 'package:multiplayer_demo/functions/special/reset_userinfo_map_from_uid.dart';
import 'package:multiplayer_demo/models/basicuserinfomodel.dart';
import 'package:multiplayer_demo/screens/signup_page.dart';
import 'package:multiplayer_demo/specials/enums.dart';
import 'package:multiplayer_demo/widgets/TextWithFontWidget.dart';
import 'package:multiplayer_demo/widgets/special/userslist.dart';
import 'package:tuple/tuple.dart';

class CameRequestListWidget extends StatefulWidget {
  const CameRequestListWidget({super.key});

  @override
  State<CameRequestListWidget> createState() => _CameRequestListWidgetState();
}

class _CameRequestListWidgetState extends State<CameRequestListWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStreamForCameRequests().then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Tuple2<BasicUserInfoModel, ConnectionRequest>>>(
        stream: cameRequestIdStream,
        builder: (_, data) {
          if (data.hasData) {
            List<Tuple2<BasicUserInfoModel, ConnectionRequest>>
                requestCameUsers = data.data
                    as List<Tuple2<BasicUserInfoModel, ConnectionRequest>>;
requestOfMaybeConnectedUsers =List.from(requestCameUsers);
            // dblog(                "requestCameUsers ${requestCameUsers.length} : ${uids.length} / ${allBasicInfoMap.length}");
            return Row(
              children: requestCameUsers
                  .map((e) => e.item1.uid == auth.currentUser!.uid
                      ? TextWithFontWidget.white(text: "Came requests")
                      : UserInfoWidgetFromReceiverSide(
                          userInfo: e.item1,
                          request: e.item2,
                        ))
                  .toList(),
            ).scrollRowWidget();
          }
          return FlutterLogo();
        });
  }
}
