import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  Map<String, String> _data = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _data = {
        'Full Name': prefs.getString('name') ?? '',
        'Phone': prefs.getString('phone') ?? '',
        'Email': prefs.getString('email') ?? '',
        'Life Story': prefs.getString('story') ?? '',
      };
      _loading = false;
    });
  }

  Future<void> _clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info'), centerTitle: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 48),
                  ),
                ),
                const SizedBox(height: 16),
                for (final e in _data.entries)
                  Card(
                    child: ListTile(
                      title: Text(e.key),
                      subtitle: Text(e.value.isEmpty ? '—' : e.value),
                    ),
                  ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _clear,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear saved data'),
                ),
              ],
            ),
    );
  }
}
