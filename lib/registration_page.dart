import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_info_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // FocusNodes
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  bool _hidePass = true;
  bool _hideConfirmPass = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _storyFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  // ---------- Validators ----------
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    if (!RegExp(r'^[0-9]+$').hasMatch(v)) return 'Digits only';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$')
        .hasMatch(v.trim());
    if (!ok) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != _passController.text) return 'Passwords do not match';
    return null;
  }

  // ---------- Submit ----------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text.trim());
    await prefs.setString('phone', _phoneController.text.trim());
    await prefs.setString('email', _emailController.text.trim());
    await prefs.setString('story', _storyController.text.trim());
    // Пароль намеренно НЕ сохраняем в открытом виде.

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserInfoPage()),
    );
  }

  Widget _clearButton(TextEditingController c) => IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => setState(c.clear),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Form'), centerTitle: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Full name
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_phoneFocus),
                  validator: _validateName,
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: _clearButton(_nameController),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocus),
                  validator: _validatePhone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    helperText: 'Digits only',
                    prefixIcon: const Icon(Icons.phone),
                    suffixIcon: _clearButton(_phoneController),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_storyFocus),
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email Address *',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),

                // Life story
                TextFormField(
                  controller: _storyController,
                  focusNode: _storyFocus,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Life Story',
                    helperText: 'Keep it short, this is just a demo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passController,
                  focusNode: _passFocus,
                  obscureText: _hidePass,
                  maxLength: 8,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_confirmPassFocus),
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    prefixIcon: const Icon(Icons.security),
                    suffixIcon: IconButton(
                      icon: Icon(_hidePass
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() => _hidePass = !_hidePass),
                    ),
                  ),
                ),

                // Confirm password
                TextFormField(
                  controller: _confirmPassController,
                  focusNode: _confirmPassFocus,
                  obscureText: _hideConfirmPass,
                  maxLength: 8,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: _validateConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password *',
                    prefixIcon: const Icon(Icons.border_color),
                    suffixIcon: IconButton(
                      icon: Icon(_hideConfirmPass
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _hideConfirmPass = !_hideConfirmPass),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _submit,
                    child: const Text('Submit Form'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
