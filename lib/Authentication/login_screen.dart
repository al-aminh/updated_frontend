import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/nav_shell.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscure = true;

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A1224), Color(0xFF060B14)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ Your logo
                      Image.asset(
                        "assets/images/CLogo.png",
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),

                      const Text(
                        "CheckAi",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Sign in to continue",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // Email
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: "Email",
                          errorText: emailError,
                          filled: true,
                          fillColor: const Color.fromARGB(255, 25, 2, 68),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: obscure,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: "Password",
                          errorText: passwordError,
                          filled: true,
                          fillColor: const Color.fromARGB(255, 25, 2, 68),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscure = !obscure),
                            icon: Icon(
                              obscure ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Forgot password (Supabase reset)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading ? null : _handleForgotPassword,
                          child: const Text("Forgot Password?"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2F57E5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(isLoading ? "Signing in..." : "Sign In"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Go to register
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text("No account?  Register"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= LOGIN =================
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;

    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (!_isValidEmail(email)) {
      setState(() => emailError = "Enter valid email address");
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = "Password required");
      return;
    }

    setState(() => isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // ✅ Go to your app shell (tabs)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavShell()),
      );
    } on AuthException catch (e) {
      // Supabase specific errors
      setState(() {
        final msg = e.message.toLowerCase();
        if (msg.contains("invalid login credentials")) {
          passwordError = "Email or password is incorrect";
        } else if (msg.contains("email not confirmed")) {
          emailError = "Please confirm your email first";
        } else {
          passwordError = e.message;
        }
      });
    } catch (e) {
      _snack("Login failed: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= FORGOT PASSWORD =================
  Future<void> _handleForgotPassword() async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim().toLowerCase();

    if (!_isValidEmail(email)) {
      setState(() => emailError = "Enter valid email first");
      return;
    }

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      _snack("Password reset email sent");
    } on AuthException catch (e) {
      _snack("Failed: ${e.message}");
    } catch (_) {
      _snack("Failed to send reset email");
    }
  }
}
