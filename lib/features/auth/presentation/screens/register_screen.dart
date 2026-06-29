import 'package:field_track/core/di/injection.dart';
import 'package:field_track/core/router/app_routes.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/features/auth/presentation/bloc/register_bloc.dart';
import 'package:field_track/features/auth/presentation/bloc/register_event.dart';
import 'package:field_track/features/auth/presentation/bloc/register_state.dart';
import 'package:field_track/features/auth/presentation/widgets/auth_screen_layout.dart';
import 'package:field_track/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:field_track/features/auth/presentation/widgets/field_track_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<RegisterBloc>().add(RegisterSubmitted(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(sl()),
      child: BlocListener<RegisterBloc, RegisterState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == RegisterStatus.success) {
            context.go(AppRoutes.home);
          } else if (state.status == RegisterStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: AuthScreenLayout(
          children: [
            const Center(child: FieldTrackLogo()),
            const SizedBox(height: 30),
            Text(
              'Create account',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Sign up to start your shift',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 26),
            AuthTextField(
              label: 'Full name',
              hint: 'John Doe',
              icon: Icons.person_outline,
              controller: _nameController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              label: 'Email',
              hint: 'john.doe@example.com',
              icon: Icons.mail_outline,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              label: 'Password',
              hint: '••••••••',
              icon: Icons.lock_outline,
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(context),
            ),
            const SizedBox(height: 26),
            BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                final loading = state.status == RegisterStatus.loading;
                return FilledButton(
                  onPressed: loading ? null : () => _submit(context),
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.surface,
                          ),
                        )
                      : const Text('Create account'),
                );
              },
            ),
            const SizedBox(height: 22),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
