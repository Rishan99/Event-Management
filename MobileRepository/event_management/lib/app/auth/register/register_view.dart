import 'package:event_management/app/auth/authentication_view_model.dart';
import 'package:event_management/app/core/core.dart';
import 'package:event_management/core/theme/theme.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';

import 'register_view_model.dart';

class RegisterView extends StatelessWidget {
  final AuthenticationViewModel authenticationViewModel;

  RegisterView({super.key, required this.authenticationViewModel});
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BaseView<RegisterViewModel>(
        builder: ((context, model, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Register",
                  style: TextStyle(fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Please register to continue,",
                  style: TextStyle(fontSize: Theme.of(context).textTheme.titleMedium?.fontSize, fontWeight: FontWeight.w500),
                ),
                formSeperatorBox(),
                TextFormField(
                  controller: model.nameController,
                  validator: Validators.emptyFieldValidator,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                formSeperatorBox(),
                TextFormField(
                  controller: model.emailController,
                  validator: Validators.emailFieldController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                formSeperatorBox(),
                TextFormField(
                  controller: model.passwordController,
                  obscureText: model.obscure,
                  validator: Validators.emptyFieldValidator,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            model.updateObscure();
                          },
                          icon: model.obscure ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))),
                ),
                formSeperatorBox(),
                formSeperatorBox(),
                TextButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (formKey.currentState!.validate()) {
                        ProgressDialog pr = ProgressDialog(context);
                        try {
                          await pr.show();
                          await model.registerUser();
                          await pr.hide();
                          successSnackBar("User has been registered successfully");
                          authenticationViewModel.updateAuthenticationState(AuthenticationState.login);
                        } catch (e) {
                          await pr.hide();
                          failureSnackBar(e.toString());
                        }
                      }
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    )),
                formSeperatorBox(),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleSmall,
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              authenticationViewModel.updateAuthenticationState(AuthenticationState.login);
                            },
                          text: 'Login here',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
