import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/models/basicuserinfomodel.dart';

Map<String, BasicUserInfoModel> allBasicInfoMap = {};

List<BasicUserInfoModel> getRequestUsersInfoFronUIDs(List<String> uids) {
  if (uids.isEmpty) {
    return [];
  }
  List<BasicUserInfoModel> infos = [];
  for (var e in uids) {
    dblog(
        "allBasicInfoMap.containsKey(e) ${allBasicInfoMap.containsKey(e)} : ${e}");
    if (allBasicInfoMap.containsKey(e)) {
      infos.add(allBasicInfoMap[e]!);
    }
  }
  return infos;
}

resetUserInfoMapFromUID(List<BasicUserInfoModel> list, {String? where}) async {
  for (var e in list) {
    allBasicInfoMap[e.uid] = e;
  }
  dblog("resetUserInfoMapFromUID ${allBasicInfoMap.length} : $where");
}
