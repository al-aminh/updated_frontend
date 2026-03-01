import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/nav_shell.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool obscure = true;

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  // ✅ Regex
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z0-9_ ]{3,20}$');
  final RegExp _emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
  final RegExp _strongPassRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&._-])[A-Za-z\d@$!%*?&._-]{8,}$',
  );

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
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
                          "Create Account",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Register to use CheckAi",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),

                        // Name / Username
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline),
                            hintText: "Name / Username",
                            errorText: nameError,
                            filled: true,
                            fillColor: const Color.fromARGB(255, 25, 2, 68),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

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
                              onPressed:
                                  () => setState(() => obscure = !obscure),
                              icon: Icon(
                                obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Confirm password
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: "Confirm Password",
                            errorText: confirmPasswordError,
                            filled: true,
                            fillColor: const Color.fromARGB(255, 25, 2, 68),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Register button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F57E5),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              isLoading ? "Registering..." : "Register",
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text("Already have an account? Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    // ✅ Name regex
    if (name.isEmpty) {
      setState(() => nameError = "Name required");
      return;
    }
    if (!_nameRegex.hasMatch(name)) {
      setState(() => nameError = "3-20 chars (letters, numbers, space, _)");
      return;
    }

    // ✅ Email regex
    if (!_emailRegex.hasMatch(email)) {
      setState(() => emailError = "Enter valid email address");
      return;
    }

    // ✅ Strong password regex
    if (!_strongPassRegex.hasMatch(password)) {
      setState(
        () => passwordError = "Min 8, upper, lower, number, special char",
      );
      return;
    }

    if (password != confirmPassword) {
      setState(() => confirmPasswordError = "Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {"username": name}, // saved in user metadata
      );

      if (!mounted) return;

      // ✅ Go to NavShell (your app main shell)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      setState(() {
        if (msg.contains("already registered") || msg.contains("already")) {
          emailError = "Email already registered";
        } else {
          emailError = e.message;
        }
      });
    } catch (e) {
      _snack("Registration failed: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
