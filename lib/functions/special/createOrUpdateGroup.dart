import 'package:firebase_database/firebase_database.dart';
import 'package:multiplayer_demo/functions/common/debugLog.dart';
import 'package:multiplayer_demo/functions/special/is_valid_currentuser.dart';
import 'package:multiplayer_demo/models/group_model.dart';

Future createOrUpdateGroup(GroupModel groupModel) async {
  final ref =
      FirebaseDatabase.instance.ref().child("groups").child(groupModel.id);
  await ref.update(groupModel.toMap());

  await addGroupidToUsersGroupIdList(
      groupId: groupModel.id, userUid: groupModel.adminUid);
  await Future.forEach(groupModel.membersIds, (memberId) async {
    await addGroupidToUsersGroupIdList(
        groupId: groupModel.id, userUid: memberId);
  });
}

Future addNewmemberToGroupUsingGroupModel(
    {required String memberUid, required GroupModel groupModel}) async {
  groupModel.membersIds.add(memberUid);
  await createOrUpdateGroup(groupModel);
}

Future<bool> addNewmemberToGroupUsingGroupId(
    {required String memberUid, required String groupId}) async {
  GroupModel? group = await getGroupInfo(groupId: groupId);
  if (group != null) {
    group.membersIds.add(memberUid);
    await createOrUpdateGroup(group);
    return true;
  }
  return false;
}

/// remove

Future<bool> removeMemberFromGroupModel(
    {required String memberUid, required GroupModel groupModel}) async {
  if (groupModel.membersIds.contains(memberUid)) {
    dblog("members befor ${groupModel.membersIds.length}");
    groupModel.membersIds.remove(memberUid);
    dblog("members after ${groupModel.membersIds.length}");

    await createOrUpdateGroup(groupModel);
    return true;
  } else {
    return false;
  }
}

///
Future<GroupModel?> getGroupInfo({required String groupId}) async {
  final ref = FirebaseDatabase.instance.ref().child("groups").child(groupId);
  Map? map = (await ref.once()).snapshot.value as Map?;
  try {
    if (map != null) {
      GroupModel groupModel = GroupModel.fromMap(map!);
      return groupModel;
    }
  } catch (e) {
    dblog("getGroups map err ${e}");
  }
  return null;
}

Future addGroupidToUsersGroupIdList(
    {required String userUid, required String groupId}) async {
  final ref = FirebaseDatabase.instance
      .ref()
      .child("groupidlist_of_user")
      .child(userUid)
      .child(groupId);
  ref.set(groupId);
}

Future<List<GroupModel>> getGroups({String? memberUid}) async {
  if (isInvalidCurrentUser && memberUid == null) {
    return [];
  }

  String uid = memberUid ?? validUser.uid;
  // dblog("getGroups $uid");
  final ref =
      FirebaseDatabase.instance.ref().child("groupidlist_of_user").child(uid);
  DatabaseEvent event = await ref.once();
  List<String> groupIds =
      event.snapshot.children.map((e) => e.value.toString()).toList();
  // dblog("getGroups ${groupIds}");
  List<GroupModel> groups = [];
  await Future.forEach(groupIds, (id) async {
    GroupModel? group = await getGroupInfo(groupId: id);
    if (group != null) {
      groups.add(group);
    }
  });
  dblog("getGroups total ${groups.length}");
  return groups;
}
