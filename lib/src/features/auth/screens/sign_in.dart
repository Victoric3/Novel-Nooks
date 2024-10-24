import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/common/constants/global_state.dart';
import 'package:flutter_ebook_app/src/features/auth/blocs/auth_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInProvider);
    final isLoading = ref.watch(loadingProvider);
    final errorMessage = ref.watch(errorProvider);
    final successMessage = ref.watch(successProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              toolbarHeight: 120,
              backgroundColor: lightAccent,
              automaticallyImplyLeading: false,
              title: Stack(
                children: [
                  // Manually add a back button
                  Positioned(
                    left: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            size: 24), // Arrow back icon
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Go back to the previous screen
                        },
                      ),
                    ),
                  ),
                  // Centered title
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/app-icon.png',
                            fit: BoxFit.contain,
                            height: 50,
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Adjust space between icon and text
                        const Text(
                          'NovelNooks',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20), // Adjust text style as needed
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: lightAccent),
              child: Container(
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 25,
                  right: 25,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                ),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFFCCCCCC)),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) =>
                                signInState.validateForm(value, 'email'),
                            validator: (value) {
                              if (!signInState.emailRegExp.hasMatch(value!)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            // onSaved: (value) {
                            //   signInState.validateForm(value!, "email");
                            // },
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(
                                        0xFFCCCCCC)), // Border color when not focused
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  signInState.passwordVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  semanticLabel: signInState.passwordVisibility
                                      ? 'Hide password'
                                      : 'Show password',
                                ),
                                onPressed: signInState.togglePasswordVisibility,
                                iconSize: 18,
                              ),
                            ),
                            obscureText: !signInState.passwordVisibility,
                            onChanged: (value) =>
                                signInState.validateForm(value, 'password'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            // onSaved: (value) {
                            //   signInState.validateForm(value!, "password");
                            // },
                          ),
                          const SizedBox(height: 12.0),
                          if (errorMessage != null)
                            Text(
                              errorMessage,
                              style: const TextStyle(color: error),
                            ),
                          if (successMessage != null && errorMessage == null)
                            Text(
                              successMessage,
                              style: const TextStyle(color: success),
                            ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  disabledBackgroundColor:
                                      const Color(0xFF333333),
                                  backgroundColor: lightAccent),
                              onPressed: 
                              // signInState.continueButtonEnabled
                              //     ? 
                                  () {
                                      // if (formKey.currentState!.validate()) {
                                        print("supposed to have hit signIn");
                                        signInState.signIn(context, ref);
                                        formKey.currentState!.save();
                                      },
                                    // }
                                  // : null,
                              child: isLoading
                                  ? SizedBox(
                                      height: 24, // Set the size of the spinner
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "Continue",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                              endIndent: 8.0,
                              indent: 15.0,
                            ),
                          ),
                          Text("Or", style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                              indent: 8.0,
                              endIndent: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Action for Google Sign-in
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lightAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: const BorderSide(color: lightAccent),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'assets/images/google-logo.png',
                                    fit: BoxFit.contain,
                                    height: 23,
                                  ),
                                ),
                                const SizedBox(width: 50),
                                const Text(
                                  "Continue with Google",
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Action for Email Sign-in
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lightAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: const BorderSide(color: lightAccent),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.email, color: Colors.white),
                                SizedBox(width: 50),
                                Text(
                                  "Continue with Email",
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Action for Apple Sign-in
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lightAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: const BorderSide(color: lightAccent),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.apple, color: Colors.white),
                                SizedBox(width: 50),
                                Text(
                                  "Continue with Apple",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
