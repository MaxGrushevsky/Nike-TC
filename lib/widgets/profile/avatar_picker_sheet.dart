import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/safe_navigator.dart';

enum AvatarPickerSource {
  camera,
  gallery,
}

Future<AvatarPickerSource?> showAvatarPickerSheet(BuildContext context) {
  return showDialog<AvatarPickerSource>(
    context: context,
    builder: (dialogContext) {
      return SimpleDialog(
        title: const Text('Edit Photo'),
        children: [
          SimpleDialogOption(
            onPressed: () => safePop(dialogContext, AvatarPickerSource.camera),
            child: const ListTile(
              leading: Icon(Icons.photo_camera_outlined),
              title: Text('Take Photo'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => safePop(dialogContext, AvatarPickerSource.gallery),
            child: const ListTile(
              leading: Icon(Icons.photo_library_outlined),
              title: Text('Choose from Library'),
            ),
          ),
        ],
      );
    },
  );
}

Future<String?> pickAvatarImage(BuildContext context) async {
  final source = await showAvatarPickerSheet(context);
  if (source == null || !context.mounted) {
    return null;
  }

  final picker = ImagePicker();
  final imageSource = switch (source) {
    AvatarPickerSource.camera => ImageSource.camera,
    AvatarPickerSource.gallery => ImageSource.gallery,
  };

  final image = await picker.pickImage(
    source: imageSource,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );

  if (image == null) {
    return null;
  }

  return image.path;
}

Widget buildAvatarImage({
  required String? avatarPath,
  required double radius,
  Color backgroundColor = const Color(0xFFE0E0E0),
}) {
  final file = avatarPath == null ? null : File(avatarPath);
  final hasFile = file != null && file.existsSync();

  if (hasFile) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: FileImage(file),
    );
  }

  return CircleAvatar(
    radius: radius,
    backgroundColor: backgroundColor,
    child: Icon(Icons.person, size: radius, color: Colors.white),
  );
}
