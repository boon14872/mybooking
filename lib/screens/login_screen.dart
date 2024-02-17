import 'package:flutter/material.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // welcome text
                const Text(
                  'ยินดีต้อนรับเข้าสู่ MyBooking',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'เข้าสู่ระบบเพื่อเริ่มต้นใช้งาน',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24.0),
                // logo or image
                Image.asset(
                  'images/logo.png',
                  height: 250.0,
                ),
                const SizedBox(height: 16.0),

                _buildTextField(
                  label: 'รหัสนักศึกษา หรือ เลขบัตรประชาชน',
                  controller: _idController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณาระบุรหัสนักศึกษา หรือ เลขบัตรประชาชน';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: 'รหัสผ่าน',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณาระบุรหัสผ่าน';
                    }
                    return null;
                  },
                ),
                // forgot password
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {},
                  child: const Text('ลืมรหัสผ่าน?'),
                ),

                const SizedBox(height: 20.0),
                _buildElevatedButton(
                  text: 'เข้าสู่ระบบ',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      await _loginUser();
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: _isLoading ? const CircularProgressIndicator() : null,
                ),
                // error message
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _errorMessage.split('Exception: ').last,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
      obscureText: obscureText,
    );
  }

  Widget _buildElevatedButton(
      {String text = 'Login', Widget? child, Function()? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: Colors.blue[300],
        surfaceTintColor: Colors.blue[300],
      ),
      child: child ??
          Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
    );
  }

  // login user
  Future<void> _loginUser() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = await userProvider.loginUser(
        _idController.text,
        _passwordController.text,
      );
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
}
