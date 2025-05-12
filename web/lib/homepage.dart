import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:web/adminpage.dart';
import 'package:window_manager/window_manager.dart';

class KioskHomePage extends StatefulWidget {
  const KioskHomePage({super.key});

  @override
  State<KioskHomePage> createState() => _KioskHomePageState();
}

class _KioskHomePageState extends State<KioskHomePage> {
 
  static const String _correctPin = '2222';
  static const double _keyboardHeight = 300;
  
 
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _pinController = TextEditingController();
  
 
  bool _isKeyboardVisible = false;
  bool _isManuallyShown = false;

 
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 24,
      color: Colors.white,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  final errorPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 24,
      color: Colors.white,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.redAccent, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  void initState() {
    super.initState();
    _setupFocusListener();
  }

  void _setupFocusListener() {
    _focusNode.addListener(() {
      if (!mounted) return;
      setState(() {
        if (!_focusNode.hasFocus && !_isManuallyShown) {
          _isKeyboardVisible = false;
        }
      });
    });
  }

  void _handlePinInput(String pin) {
    if (pin.length == 4) {
      if (pin == _correctPin) {
        windowManager.destroy();
      }
      setState(() => _isKeyboardVisible = false);
    }
  }

  void _showKeyboard() {
    setState(() {
      _isKeyboardVisible = true;
      _isManuallyShown = true;
    });
  }

  Widget _buildAdminButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, right: 20.0),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
          ),
          child: const Text("Admin Login"),
        ),
      ),
    );
  }

  Widget _buildPinInput() {
    return Pinput(
      length: 4,
      controller: _pinController,
      focusNode: _focusNode,
      defaultPinTheme: defaultPinTheme,
      errorPinTheme: errorPinTheme,
      showCursor: true,
      onChanged: _handlePinInput,
      onTap: _showKeyboard,
      validator: (pin) => pin == _correctPin ? null : 'Pin is incorrect',
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 1,
            height: 24,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildVirtualKeyboard() {
    if (!_isKeyboardVisible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        _isManuallyShown = true;
        _focusNode.requestFocus();
      },
      child: Container(
        height: _keyboardHeight,
        color: Colors.deepPurple.shade900,
        child: VirtualKeyboard(
          height: _keyboardHeight,
          width: MediaQuery.of(context).size.width / 4,
          textColor: Colors.white,
          type: VirtualKeyboardType.Numeric,
          textController: _pinController,
          postKeyPress: (_) {
            if (_pinController.text.length < 4) {
              _focusNode.requestFocus();
              _isManuallyShown = true;
            } else {
              setState(() => _isKeyboardVisible = false);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade700,
      body: Column(
        children: [
          _buildAdminButton(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.lock, size: 100, color: Colors.white),
                  const Text(
                    'Device Locked',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                  const SizedBox(height: 30),
                  _buildPinInput(),
                ],
              ),
            ),
          ),
          _buildVirtualKeyboard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
