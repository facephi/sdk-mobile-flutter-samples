import 'package:example/providers/behavior.dart';
import 'package:example/services/behavior_service.dart';
import 'package:example/widgets/custom_button.dart';
import 'package:example/widgets/custom_popup_menu_button.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.notifier,
    required this.mode,
  });

  final ValueNotifier<ThemeMode> notifier;
  final ThemeMode mode;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _message = '';
  bool _busy = false;

  String get _user => BehaviorService.instance.userId;

  void _setError(String message) {
    if (!mounted) {
      return;
    }
    setState(() => _message = message);
  }

  Future<void> _goToHome() async {
    setState(() {
      _message = '';
      _busy = true;
    });
    await launchSetPosition('Home', onError: _setError);
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _onLogout() async {
    setState(() {
      _message = '';
      _busy = true;
    });
    BehaviorService.instance.userId = '';
    await launchSetPosition('Login', onError: _setError);
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
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
                const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Signed in as $_user', style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6))),
                if (_message.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(_message, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFDC143C), fontSize: 16)),
                ],
                const SizedBox(height: 24),
                if (_busy)
                  const CircularProgressIndicator(color: Color(0xFF0099af))
                else ...[
                  CustomButton(text: 'Go to Home', function: _goToHome),
                  CustomButton(text: 'Logout', outlined: true, function: _onLogout),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
