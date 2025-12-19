import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _biometricService = BiometricService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _biometricsAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await _biometricService.canCheckBiometrics();
    setState(() {
      _biometricsAvailable = available;
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email o contraseña incorrectos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginWithBiometrics() async {
    final authenticated = await _biometricService.authenticateWithBiometrics();
    
    if (authenticated && mounted) {
      // In a real app, you would retrieve stored credentials here
      // For demo, we'll use the test credentials
      _emailController.text = 'juan.perez@example.com';
      _passwordController.text = 'password123';
      await _login();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F1A2E),
              Color(0xFF1A2B4A),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'AB',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2B4A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Notaría\nPública 9',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Notario',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFB0C4DE),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo';
                        }
                        if (!value.contains('@')) {
                          return 'Ingrese un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Iniciar sesión'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Biometric Login Button
                    if (_biometricsAvailable)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _loginWithBiometrics,
                          icon: const FaIcon(FontAwesomeIcons.fingerprint, size: 20),
                          label: const Text('Iniciar con Face ID'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF4A9ECC)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Forgot Password
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: Color(0xFFB0C4DE),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
