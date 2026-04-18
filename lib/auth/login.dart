import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleSocialLogin(Future<void> Function() loginMethod) async {
    setState(() => _isLoading = true);
    try {
      await loginMethod();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ThachinChord Login")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Email Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleSocialLogin(
                        () => ref
                            .read(authServiceProvider)
                            .signIn(
                              _emailController.text,
                              _passwordController.text,
                            ),
                      ),
                      child: const Text("Login with Email"),
                    ),
                  ),

                  const Divider(height: 40),

                  // Google Login
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.g_mobiledata, size: 30),
                      label: const Text("Sign in with Google"),
                      onPressed: () => _handleSocialLogin(
                        () => ref.read(authServiceProvider).signInWithGoogle(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Facebook Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.facebook),
                      label: const Text("Sign in with Facebook"),
                      onPressed: () => _handleSocialLogin(
                        () =>
                            ref.read(authServiceProvider).signInWithFacebook(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
