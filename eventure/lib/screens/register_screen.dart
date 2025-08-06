import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;

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

              Text('First Name', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                style: TextStyle(color: colorScheme.onBackground),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              Text('Last Name', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextField(
                style: TextStyle(color: colorScheme.onBackground),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
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

              // Password Field
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
              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {},
                child: Text('REGISTER', style: textTheme.labelLarge),
              ),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Already have an account? Log In',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
