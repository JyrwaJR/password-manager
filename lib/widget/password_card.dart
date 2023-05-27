import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class PasswordGroupCard extends StatelessWidget {
  const PasswordGroupCard({
    super.key,
    required this.groupPassword,
  });
  final GroupPassword groupPassword;

  @override
  Widget build(BuildContext context) {
    String groupId = groupPassword.groupId;
    void onSelectActionButton(
        String value, String groupId, BuildContext context) async {
      if (value == '0') {
        showModalBottomSheet(
          context: context,
          builder: (context) =>
              RenameGroupBottomSheet(groupId: groupId, isPasswordGroup: true),
        );
      } else if (value == '1') {
        showDialog(
          context: context,
          builder: (context) => const GetApiKeyNotYetImplemented(),
        );
      } else if (value == '2') {
        await deleteGroupWithGroupIdAlertBox(context, true, groupId);
      }
    }

    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BrandCircularAvatar(id: groupId, radius: 23),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    capitalizeFirstLetter(groupPassword.groupName),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              PopupMenuButton(
                onSelected: (value) {
                  onSelectActionButton(value, groupPassword.groupId, context);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: '0', child: Text('Rename')),
                  const PopupMenuItem(value: '1', child: Text('Get Key')),
                  const PopupMenuItem(value: '2', child: Text('Delete')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
