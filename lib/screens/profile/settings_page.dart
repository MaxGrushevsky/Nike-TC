import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../router.dart';

class SettingsSection {
  const SettingsSection({
    required this.id,
    required this.title,
    required this.items,
  });

  final String id;
  final String title;
  final List<String> items;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _sections = [
    SettingsSection(
      id: 'account',
      title: 'Account',
      items: [
        'Country/Region',
        'Language',
        'Shopping Settings',
      ],
    ),
    SettingsSection(
      id: 'support',
      title: 'Support',
      items: [
        'About this Version',
        'Terms of Use',
        'Privacy Policy',
        'App FAQs',
        'Contact Us',
      ],
    ),
  ];

  String? _selectedItem;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      AppRouter.login,
      (route) => false,
    );
  }

  void _selectItem(String item) {
    setState(() => _selectedItem = item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 700;

          if (isTablet) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 320,
                  child: _SettingsMenu(
                    sections: _sections,
                    selectedItem: _selectedItem,
                    onItemTap: _selectItem,
                    onLogout: _logout,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _SettingsDetailPane(selectedItem: _selectedItem),
                ),
              ],
            );
          }

          return _SettingsMenu(
            sections: _sections,
            selectedItem: _selectedItem,
            onItemTap: _selectItem,
            onLogout: _logout,
          );
        },
      ),
    );
  }
}

class _SettingsMenu extends StatelessWidget {
  const _SettingsMenu({
    required this.sections,
    required this.selectedItem,
    required this.onItemTap,
    required this.onLogout,
  });

  final List<SettingsSection> sections;
  final String? selectedItem;
  final ValueChanged<String> onItemTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var index = 0; index < sections.length; index++) ...[
          if (index > 0) const _SectionDivider(),
          ...sections[index].items.map(
            (item) => _SettingsTile(
              title: item,
              isSelected: selectedItem == item,
              onTap: () => onItemTap(item),
            ),
          ),
        ],
        const _SectionDivider(),
        ListTile(
          title: const Text(
            'Log Out',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onLogout,
        ),
      ],
    );
  }
}

class _SettingsDetailPane extends StatelessWidget {
  const _SettingsDetailPane({required this.selectedItem});

  final String? selectedItem;

  @override
  Widget build(BuildContext context) {
    if (selectedItem == null) {
      return Center(
        child: Text(
          'Select a setting',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          selectedItem!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      selected: isSelected,
      onTap: onTap,
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      color: Colors.grey.shade100,
    );
  }
}
