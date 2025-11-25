import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vba/core/commom/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:vba/core/commom/widgets/snackbar/custom_snackbar.dart';
import 'package:vba/presentation/login/bloc/login_bloc.dart';

class WidgetSignInForm extends StatefulWidget {
  const WidgetSignInForm({super.key});

  @override
  State<WidgetSignInForm> createState() => _WidgetSignInFormState();
}

class _WidgetSignInFormState extends State<WidgetSignInForm> {
  late AuthenticationBloc _authenticationBloc;
  late LoginBloc _loginBloc;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'participant100@vba.net.vn');
  final _passwordController = TextEditingController(text: 'user@123A');
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _authenticationBloc.add(LoggedIn());
          context.go('/');
        }

        if (state.isFailure) {
          CustomSnackBar.failure(context, msg: "Login Failed!");
        }

        if (state.isSubmitting) {
          CustomSnackBar.showLoading(context, msg: "Processing...");
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey.withAlpha(50),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        if (!value.contains('@')) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        // Vô hiệu hóa nút khi đang loading
                        onPressed: _login,
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _login() {
    // 1. Kiểm tra validate
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _loginBloc.add(LoginSubmitEmailPasswordEvent(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
