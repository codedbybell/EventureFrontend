import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/logo.png', height: 300),
              const SizedBox(height: 2),

              Text('Email', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: colorScheme.onBackground),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              Text('Password', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                obscureText: !_isPasswordVisible,
                style: TextStyle(color: colorScheme.onBackground),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        activeColor: colorScheme.primary,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      Text('Remember Me', style: textTheme.bodySmall),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {},
                child: Text('LOG IN', style: textTheme.labelLarge),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
