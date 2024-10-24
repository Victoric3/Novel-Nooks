import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/common/constants/global_state.dart';
import 'package:flutter_ebook_app/src/features/auth/blocs/auth_handler.dart';

@RoutePage()
// ignore: must_be_immutable
class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});
  final formKey = GlobalKey<FormState>();

  final PageController _pageController = PageController();
  int _currentStep = 0;

  void nextPage() {
    if (_currentStep < 2) {
      _currentStep++;
      _pageController.animateToPage(_currentStep,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void previousPage() {
    if (_currentStep > 0) {
      _currentStep--;
      _pageController.animateToPage(_currentStep,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInProvider);
    final isLoading = ref.watch(loadingProvider);
    final errorMessage = ref.watch(errorProvider);
    final successMessage = ref.watch(successProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              toolbarHeight: 150,
              backgroundColor: lightAccent,
              automaticallyImplyLeading: false,
              title: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: previousPage, // Go to previous step
                      ),
                    ),
                  ),
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
                        const Text(
                          'NovelNooks',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                  left: 16,
                  right: 16,
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
                          SizedBox(
                            height: 400, // Fixed height for the form
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                // Step 1: Name Collection
                                Column(
                                  children: [
                                    const SizedBox(
                                        height: 20), // Space from the top
                                    const Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons
                                                .person, // Adding a person icon for the name fields
                                            size: 50,
                                            color: Colors
                                                .blueAccent, // Customize icon color
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Enter Your Details",
                                            style: TextStyle(
                                              fontSize:
                                                  24, // Make the font bigger
                                              fontWeight: FontWeight
                                                  .bold, // Make the text bold
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            20), // Space before the form fields

                                    // Firstname Field
                                    TextFormField(
                                      style: const TextStyle(
                                        fontSize:
                                            18, // Bigger text inside the field
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Firstname',
                                        labelStyle: const TextStyle(
                                          fontSize: 18, // Bigger label text
                                          fontWeight:
                                              FontWeight.bold, // Bold label
                                        ),
                                        prefixIcon: const Icon(
                                          Icons
                                              .person_outline, // Adding an icon to indicate name
                                          size: 24,
                                          color: Colors
                                              .blueAccent, // Customize icon color
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              15.0), // Rounded border
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xFFCCCCCC)),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 16.0,
                                          horizontal: 16.0,
                                        ),
                                      ),
                                      onChanged: (value) => signInState
                                          .collectFormData(value, 'firstname'),
                                    ),
                                    const SizedBox(height: 12.0),

                                    // Lastname Field
                                    TextFormField(
                                      style: const TextStyle(
                                        fontSize:
                                            18, // Bigger text inside the field
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Lastname',
                                        labelStyle: const TextStyle(
                                          fontSize: 18, // Bigger label text
                                          fontWeight:
                                              FontWeight.bold, // Bold label
                                        ),
                                        prefixIcon: const Icon(
                                          Icons
                                              .person_outline, // Same icon for consistency
                                          size: 24,
                                          color: Colors
                                              .blueAccent, // Customize icon color
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              15.0), // Rounded border
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xFFCCCCCC)),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 16.0,
                                          horizontal: 16.0,
                                        ),
                                      ),
                                      onChanged: (value) => signInState
                                          .collectFormData(value, 'lastname'),
                                    ),
                                    const SizedBox(height: 12.0),
                                  ],
                                ),
                                // Step 2: Date Collection
                                Column(
                                  children: [
                                    const SizedBox(
                                        height:
                                            40), // Add some space from the top
                                    Center(
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons
                                                .cake, // Replace with an appropriate icon
                                            size: 50,
                                            color: Colors
                                                .blueAccent, // Customize icon color
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Enter Your Birthdate",
                                            style: TextStyle(
                                              fontSize:
                                                  24, // Make the font bigger
                                              fontWeight: FontWeight
                                                  .bold, // Make the text bold
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          GestureDetector(
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now(),
                                              );

                                              if (pickedDate != null) {
                                                String formattedDate =
                                                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                                signInState.collectFormData(
                                                    formattedDate, 'birthdate');
                                              }
                                            },
                                            child: AbsorbPointer(
                                              child: TextFormField(
                                                style: const TextStyle(
                                                  fontSize:
                                                      18, // Bigger text inside the field
                                                ),
                                                decoration: InputDecoration(
                                                  labelText: 'Birthdate',
                                                  labelStyle: const TextStyle(
                                                    fontSize:
                                                        18, // Bigger label text
                                                    fontWeight: FontWeight
                                                        .bold, // Bold label
                                                  ),
                                                  prefixIcon: const Icon(
                                                    Icons
                                                        .calendar_today, // Adding a calendar icon
                                                    size: 24,
                                                    color: Colors
                                                        .blueAccent, // Customize icon color
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0), // Rounded border
                                                  ),
                                                ),
                                                controller:
                                                    TextEditingController(
                                                  text: signInState
                                                      .birthdate, // Display the selected birthdate
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Step 3: Interests Selection
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "What are your interests?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8.0,
                                      children: [
                                        for (var interest in [
                                          "Romance",
                                          "shortStory",
                                          "sci-Fi",
                                          "Fantasy",
                                          "Horror",
                                          "Mystery",
                                          "Non-Fiction",
                                          "Historical Fiction",
                                          "Multi-genre",
                                          "Adventure",
                                          "Biography",
                                          "Science",
                                          "Self-Help",
                                          "Personal-development"
                                        ])
                                          FilterChip(
                                            label: Text(interest),
                                            selected: signInState.interests
                                                .contains(interest),
                                            onSelected: (isSelected) {
                                              if (isSelected) {
                                                if (signInState
                                                        .interests.length <
                                                    3) {
                                                  signInState.collectFormData(
                                                      interest, 'interests');
                                                } else {
                                                  setMessages(ref,
                                                      errorMessage:
                                                          "You can select up to 3");
                                                }
                                              } else {
                                                // Deselect the interest
                                                signInState.interests
                                                    .remove(interest);
                                              }
                                            },
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          if (errorMessage != null)
                            Center(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: error),
                              ),
                            ),
                          if (successMessage != null && errorMessage == null)
                            Center(
                              child: Text(
                                successMessage,
                                style: const TextStyle(color: success),
                              ),
                            ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                backgroundColor: lightAccent,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (_currentStep < 2) {
                                    nextPage();
                                  } else {
                                    signInState.finishSignUp(context, ref);
                                  }
                                }
                              },
                              child: isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _currentStep == 2
                                          ? "Agree & Continue"
                                          : "Next",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
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
