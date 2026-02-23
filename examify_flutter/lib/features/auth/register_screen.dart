import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_card.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _role = 'student';

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authProvider.notifier)
          .register(
            _nameController.text,
            _emailController.text,
            _passwordController.text,
            _role,
          );
      if (success) {
        if (_role == 'teacher') {
          context.go('/teacher');
        } else {
          context.go('/student');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AppCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (authState.error != null) ...[
                      Text(
                        authState.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                    AppTextField(
                      controller: _nameController,
                      label: 'Name',
                      validator: (v) => v!.isEmpty ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      validator: (v) => v!.isEmpty ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _role,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(
                          value: 'student',
                          child: Text('Student'),
                        ),
                        DropdownMenuItem(
                          value: 'teacher',
                          child: Text('Teacher'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _role = val);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Register',
                      onPressed: _register,
                      isLoading: authState.isLoading,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Back to Login',
                      onPressed: () => context.go('/'),
                      isSecondary: true,
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
