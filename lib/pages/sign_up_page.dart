import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';
import 'encouragement_form_page.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // Helper function to handle signup
  // takes _email and _password from
  Future<void> _handlesSignUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        await Supabase.instance.client.auth.signUp(
          email: _email,
          password: _password,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created successfully!")),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EncouragementFormPage()),
          );
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
            SnackBar(content: Text("An unexpected error occurred: $e"), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    // 4. Clean up the controller when the widget is disposed
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
          // 1. Scrollable Background
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF315285), Color(0xFF545e6e)],
                ),
              ),
              // 2. Form Card Contents
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFormCard(),
                ),
              ),
            ),
          ),

          // 3. Back Button (Top Left)
          _buildBackButton(),
        ],
      ),
    );
  }

  // ===========================================================================
  // MODULAR UI COMPONENTS (EXTRACTED HELPER WIDGETS)
  // ===========================================================================

  /// The white rounded container card that holds all inputs
  Widget _buildFormCard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // TITLE
              _buildTitle(),
              const SizedBox(height: 20),

              // ENTER EMAIL
              _buildEmailField(),
              const SizedBox(height: 20),

              // CREATE PASSWORD
              _buildPasswordField(
                labelText: "Password",
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return "Password must be at least 8 characters long.";
                  }
                  return null;
                },
                onSaved: (value) => _password = value ?? "",
              ),
              const SizedBox(height: 20),

              // CONFIRM PASSWORD
              _buildPasswordField(
                labelText: "Confirm Password",
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Passwords do not match.";
                  }
                  return null;
                },
                onSaved: (_) {} // nothing to do, password was saved by previous field
              ),
              const SizedBox(height: 30),

              // SUBMIT BUTTON
              _buildSubmitButton(),
              const SizedBox(height: 20),

              // LOG IN OPTION
              _buildSignInRow(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  /// Title header: "Join Us!"
  Widget _buildTitle() {
    return const Text(
      'Join Us!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
        fontFamily: 'Caprasimo',
        color: Color(0xFF001A44),
      ),
    );
  }

  /// Email Input Field
  Widget _buildEmailField() {
    return TextFormField(
      style: const TextStyle(
        fontFamily: 'Yeseva',
        fontSize: 16,
        color: Colors.black,
      ),
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
      onSaved: (value) => _email = value ?? '',
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
  /// reusable so that we can have two password fields: one for creation and confirmation
  Widget _buildPasswordField({
      required String labelText,
      TextEditingController? controller,
      required String? Function(String?) validator,
      required void Function(String?) onSaved,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(
        fontFamily: 'Yeseva',
        fontSize: 16,
        color: Colors.black,
      ),
      validator: validator,
      onSaved: (value) => _password = value ?? '',
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Yeseva',
          fontSize: 16,
          color: Colors.black54,
        ),
        prefixIcon: const Icon(Icons.lock),
        border: const UnderlineInputBorder(),
      ),
    );
  }

  /// Primary Action Button (Create an Account)
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handlesSignUp,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: const Color(0xFF001A44),
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
                'Create an Account',
                style: TextStyle(fontFamily: 'Yeseva', fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }

  /// Bottom link to switch to Log In
  Widget _buildSignInRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(fontFamily: 'Yeseva', color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            "Log in here",
            style: TextStyle(
              fontFamily: 'Yeseva',
              color: Color(0xFF001A44),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Floating Back Button (Top Left)
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
