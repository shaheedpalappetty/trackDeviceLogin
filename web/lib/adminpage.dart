import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:web/homepage.dart';
import 'package:window_manager/window_manager.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isManuallyShown = false;
  bool _isKeyboardVisible = false;

  TextEditingController? _activeController;
  FocusNode? _activeFocusNode;

  static const double _keyboardHeight = 300;
  static const double _inputWidth = 300;

  @override
  void initState() {
    super.initState();
    // Simplify focus listeners
    _usernameFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) return;

    if (_usernameFocusNode.hasFocus) {
      _updateActiveField(_usernameController, _usernameFocusNode);
    } else if (_passwordFocusNode.hasFocus) {
      _updateActiveField(_passwordController, _passwordFocusNode);
    } else if (!_isManuallyShown) {
      setState(() {
        _isKeyboardVisible = false;
        _activeController = null;
        _activeFocusNode = null;
      });
    }
  }

  void _updateActiveField(
      TextEditingController controller, FocusNode focusNode) {
    setState(() {
      _isKeyboardVisible = true;
      _activeController = controller;
      _activeFocusNode = focusNode;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_usernameController.text == 'admin' &&
          _passwordController.text == 'password') {
        windowManager.destroy();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
        onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const KioskHomePage()),
          (route) => false,
        ),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    bool isPassword = false,
  }) {
    return Container(
      width: _inputWidth,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        showCursor: true,
        obscureText: isPassword,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: focusNode.hasFocus
                ? Colors.white
                : Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            isPassword ? Icons.lock_outline : Icons.person_outline,
            color: Colors.white.withOpacity(0.7),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
        onTap: () {
          _isManuallyShown = true;
          _updateActiveField(controller, focusNode);
        },
        onTapOutside: (_) {
          _isManuallyShown = false;
        },
      ),
    );
  }

  Widget _buildVirtualKeyboard() {
    if (!_isKeyboardVisible || _activeController == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        _isManuallyShown = true;
        _activeFocusNode?.requestFocus();
      },
      child: Container(
        height: _keyboardHeight,
        color: Colors.deepPurple.shade900,
        child: VirtualKeyboard(
          height: _keyboardHeight,
          textController: _activeController!,
          width: MediaQuery.of(context).size.width / 2,
          textColor: Colors.white,
          type: VirtualKeyboardType.Alphanumeric,
          postKeyPress: (_) {
            _isManuallyShown = true;
            _activeFocusNode?.requestFocus();
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
          _buildBackButton(),
          Expanded(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.lock, size: 100, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      'Device Locked',
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      label: 'Username',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      label: 'Password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: const Text("Submit"),
                    ),
                  ],
                ),
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
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }
}
