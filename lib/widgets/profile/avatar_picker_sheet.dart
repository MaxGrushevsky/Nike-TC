import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum AvatarPickerSource {
  camera,
  gallery,
}

Future<AvatarPickerSource?> showAvatarPickerSheet(BuildContext context) {
  return showModalBottomSheet<AvatarPickerSource>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, AvatarPickerSource.camera),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Library'),
              onTap: () => Navigator.pop(context, AvatarPickerSource.gallery),
            ),
          ],
        ),
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
