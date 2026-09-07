import 'package:example/providers/behavior.dart';
import 'package:example/services/behavior_service.dart';
import 'package:example/widgets/custom_button.dart';
import 'package:example/widgets/custom_popup_menu_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.notifier,
    required this.mode,
  });

  final ValueNotifier<ThemeMode> notifier;
  final ThemeMode mode;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  String _message     = '';
  String _localError  = '';
  bool _busy          = false;

  String get _session => BehaviorService.instance.sessionId;

  @override
  void initState() {
    super.initState();
    if (_session.isEmpty) {
      _launchInitialize();
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    super.dispose();
  }

  void _setError(String message) {
    if (!mounted) {
      return;
    }
    setState(() {
      _message = message;
    });
  }

  void _clearError() {
    if (!mounted) {
      return;
    }
    setState(() {
      _message    = '';
      _localError = '';
    });
  }

  Future<void> _launchInitialize() async {
    _clearError();
    setState(() => _busy = true);
    await launchInitialize(onError: _setError);
    if (mounted) {
      setState(() => _busy = false);
    }
  }

  Future<void> _launchClearSession() async {
    setState(() => _busy = true);
    await launchClearSession(onError: _setError);
    if (mounted) {
      setState(() => _busy = false);
    }
  }

  Future<void> _handleSubmit() async {
    final user = _userController.text.trim();
    if (user.isEmpty) {
      setState(() => _localError = 'User is required');
      return;
    }

    _clearError();
    setState(() => _busy = true);

    await launchSetUserId(user, onError: _setError);
    await launchSetPosition('Home', onError: _setError);

    if (!mounted) {
      return;
    }

    setState(() => _busy = false);
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onUserChanged(String value) {
    launchRegisterField(value: value, fieldType: 'user');
  }

  @override
  Widget build(BuildContext context) {
    final String errorText = _localError.isNotEmpty ? _localError : _message;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('360 Behavior', style: TextStyle(fontSize: 24, color: Colors.white)),
        actions: [
          CustomPopupMenuBtn(notifier: widget.notifier, mode: widget.mode),
        ],
        backgroundColor: const Color(0xFF0099af),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Sign in', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Behavior 360 sample',
                  style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6))
                ),
                if (errorText.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(errorText, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFDC143C), fontSize: 16))
                ],
                const SizedBox(height: 24),
                TextField(
                  controller: _userController,
                  onChanged: _onUserChanged,
                  enabled: !_busy,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    hintText: 'User',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
                if (_busy)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: CircularProgressIndicator(color: Color(0xFF0099af))
                  )
                else if (_session.isNotEmpty) ...[
                  CustomButton(text: 'Login', function: _handleSubmit),
                  CustomButton(text: 'Clear Session', outlined: true, function: _launchClearSession),
                ] else
                  CustomButton(text: 'Initialize', function: _launchInitialize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
