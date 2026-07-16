import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../utils/safe_navigator.dart';
import '../../utils/validators.dart';
import '../../widgets/profile/avatar_picker_sheet.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _hometownController;
  late final TextEditingController _bioController;

  String? _firstNameError;
  String? _lastNameError;
  String? _hometownError;
  String? _bioError;
  String? _avatarPath;
  bool _canSave = false;
  bool _isPickingAvatar = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.profile.firstName);
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _hometownController = TextEditingController(text: widget.profile.hometown ?? '');
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _avatarPath = widget.profile.avatarPath;

    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _hometownController.addListener(_validateForm);
    _bioController.addListener(_validateForm);

    _validateForm();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _hometownController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final firstNameError = Validators.firstName(_firstNameController.text);
    final lastNameError = Validators.lastName(_lastNameController.text);
    final hometownError = Validators.optionalHometown(_hometownController.text);
    final bioError = Validators.optionalBio(_bioController.text);

    final canSave = firstNameError == null &&
        lastNameError == null &&
        hometownError == null &&
        bioError == null;

    setState(() {
      _firstNameError = firstNameError;
      _lastNameError = lastNameError;
      _hometownError = hometownError;
      _bioError = bioError;
      _canSave = canSave;
    });
  }

  Future<void> _editAvatar() async {
    if (_isPickingAvatar) return;

    setState(() => _isPickingAvatar = true);
    try {
      final path = await pickAvatarImage(context);
      if (path == null || !mounted) return;
      setState(() => _avatarPath = path);
    } finally {
      if (mounted) {
        setState(() => _isPickingAvatar = false);
      }
    }
  }

  void _save() {
    if (!_canSave) return;

    final hometown = _hometownController.text.trim();
    final bio = _bioController.text.trim();

    safePop(
      context,
      widget.profile.copyWith(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        hometown: hometown.isEmpty ? null : hometown,
        bio: bio.isEmpty ? null : bio,
        avatarPath: _avatarPath,
        clearHometown: hometown.isEmpty,
        clearBio: bio.isEmpty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          onPressed: () => safePop(context),
          child: const Text('Cancel'),
        ),
        leadingWidth: 88,
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _canSave ? _save : null,
            child: Text(
              'Save',
              style: TextStyle(
                color: _canSave ? Colors.blue : Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth >= 700 ? 560.0 : double.infinity;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _editAvatar,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              buildAvatarImage(
                                avatarPath: _avatarPath,
                                radius: 48,
                                backgroundColor: Colors.grey.shade400,
                              ),
                              if (_avatarPath == null)
                                Icon(
                                  Icons.photo_camera_outlined,
                                  size: 28,
                                  color: Colors.grey.shade700,
                                ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _editAvatar,
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ProfileTextField(
                    controller: _firstNameController,
                    hintText: 'First Name',
                    errorText: _firstNameError,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _ProfileTextField(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                    errorText: _lastNameError,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Hometown',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ProfileTextField(
                    controller: _hometownController,
                    hintText: 'Town/City, Country/Region',
                    errorText: _hometownError,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_bioController.text.length}/150',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _ProfileTextField(
                    controller: _bioController,
                    hintText: '150 characters',
                    errorText: _bioError,
                    maxLines: 4,
                    maxLength: 150,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.hintText,
    this.errorText,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        counterText: maxLength == null ? null : '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
