import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/app_card.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authProvider.notifier)
          .login(_emailController.text, _passwordController.text);
      if (success) {
        final user = ref.read(authProvider).user;
        if (user?.role.name == 'teacher') {
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
                      'Examify',
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
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
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Login',
                      onPressed: _login,
                      isLoading: authState.isLoading,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Create an account',
                      onPressed: () => context.go('/register'),
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
