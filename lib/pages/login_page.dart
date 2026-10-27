import 'package:flutter/material.dart';
import 'home_page.dart';
import 'sign_up_page.dart';
import 'package:provider/provider.dart';
import '../state/user_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (mounted && response.user != null) {
        // Fetch member_id from database and save to UserState provider
        try {
          final memberResponse = await Supabase.instance.client
              .from("MEMBER")
              .select("member_id")
              .eq("user_id", response.user!.id)
              .single();
          final memberId = memberResponse["member_id"];

          if (mounted) {
            context.read<UserState>().setMemberId(memberId);
          }
        } catch (e) {
          debugPrint("Error fetching member ID on login: $e");
        }

        // Navigate to HomePage on success
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during login: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // MAIN BUILD METHOD
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient Container
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8D909B), Color(0xFF4D80D1)],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFormCard(),
                ),
              ),
            ),
          ),

          // 2. Floating Back Button (Top-Left)
          _buildBackButton(),
        ],
      ),
    );
  }

  // ===========================================================================
  // MODULAR UI COMPONENTS
  // ===========================================================================

  /// White rounded card containing all input fields and buttons
  Widget _buildFormCard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            _buildTitle(),
            const SizedBox(height: 20),
            _buildEmailField(),
            const SizedBox(height: 20),
            _buildPasswordField(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
            const SizedBox(height: 15),
            _buildForgotPasswordRow(),
            _buildSignUpRow(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// Title header: "Welcome!"
  Widget _buildTitle() {
    return const Text(
      'Welcome!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
        fontFamily: 'Caprasimo',
        color: Color(0xFF5A6FC4),
      ),
    );
  }

  /// Email Input Field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(
        fontFamily: 'Yeseva',
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          fontFamily: 'Yeseva',
          fontSize: 16,
          color: Colors.black54,
        ),
        prefixIcon: Icon(Icons.email),
        border: UnderlineInputBorder(),
      ),
    );
  }

  /// Password Input Field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      style: const TextStyle(
        fontFamily: 'Yeseva',
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          fontFamily: 'Yeseva',
          fontSize: 16,
          color: Colors.black54,
        ),
        prefixIcon: Icon(Icons.lock),
        border: UnderlineInputBorder(),
      ),
    );
  }

  /// Primary Action Button (Log In)
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: const Color(0xFF5A6FC4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                'Log In',
                style: TextStyle(fontFamily: 'Yeseva', fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }

  /// Forgot Password link row
  Widget _buildForgotPasswordRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Having trouble?",
          style: TextStyle(fontFamily: 'Yeseva', color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            // TODO: Password reset flow
          },
          child: const Text(
            "Forgot my Password",
            style: TextStyle(
              fontFamily: 'Yeseva',
              color: Color(0xFF5A6FC4),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Link to switch to Sign Up
  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(fontFamily: 'Yeseva', color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          child: const Text(
            "Sign up here",
            style: TextStyle(
              fontFamily: 'Yeseva',
              color: Color(0xFF5A6FC4),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Floating Back Button (Top-Left)
  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 16,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
