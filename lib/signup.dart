// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:hrms/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:image_picker/image_picker.dart';

final _formKey = GlobalKey<FormState>();

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  // File? _image;
  // Future<void> _pickImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  //   print(_image.toString());
  // }

  //Controllers
  final _nameController = TextEditingController();
  final _employeeId = TextEditingController();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _emailTextController = TextEditingController();

  bool _obscureText = true;
  String? uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF443ca9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Employee Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    
                  ),
                  // textAlign: TextAlign.center,
                ),
                //Login Form Below
                loginForm(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            //Name Field

            const SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.name,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person),
                prefixIconColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: _nameValidator,
            ),

            //Employee ID
            const SizedBox(height: 30),
            TextFormField(
              controller: _employeeId,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Employee ID",
                prefixIcon: Icon(Icons.person),
                prefixIconColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: _employeeIdValidator,
            ),

            //Email Field

            const SizedBox(height: 20),
            TextFormField(
              controller: _emailTextController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                prefixIconColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: _emailValidator,
            ),

            //Phone Field

            const SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Phone",
                prefixIcon: Icon(Icons.phone),
                prefixIconColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: _phoneValidator,
            ),

            //Password Field
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _passwordController,
              obscureText: _obscureText,
              keyboardType: TextInputType.visiblePassword,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.password),
                prefixIconColor: Colors.white,
                suffixIconColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: _passValidator,
            ),

            //ConfirmPassword Field
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _confirmPassController,
              obscureText: _obscureText,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: const Icon(Icons.password),
                prefixIconColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                suffixIconColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.white),
                border: const OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.white),
                    ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: _confPassValidator,
            ),

            //Submit Button
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: _validateSubmit,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ),

            //Login Button
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already Have An Account?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Login In",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 191, 255),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//Name Validation
  String? _nameValidator(String? value) {
    if (value!.isEmpty) {
      return "Field Cannot be Empty";
    }
    return null;
  }

//Employee ID Validation
  String? _employeeIdValidator(String? value) {
    if (value!.isEmpty) {
      return "Field Cannot be Empty";
    }

    if (value.length < 6 || value.length > 6) {
      return "Enter Valid 6 character ID";
    }
    return null;
  }

  //Email Validation
  String? _emailValidator(String? value) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value!.isEmpty) {
      return "Field cannot Be Empty";
    }
    if (!regex.hasMatch(value)) {
      return "Enter a Valid E-Mail";
    }
    return null;
  }

  //phone Validation
  String? _phoneValidator(String? value) {
    // final RegExp simplePhoneRegex = RegExp(r'^[0-9]+$');
    if (value!.isEmpty) {
      return "Field cannot Be Empty";
    }
    if (value.length < 10 || value.length > 10) {
      return "Enter 10-Digit Number";
    }
    return null;
  }

  //Password Validation
  String? _passValidator(String? value) {
    final RegExp whitespaceRegex = RegExp(r'\s+');
    if (value!.isEmpty) {
      return "Field Cannot Be Empty";
    }
    if (value.length < 5) {
      return "Password should be atleast 6 characters";
    }
    if (whitespaceRegex.hasMatch(value)) {
      return "Password cannot contain Whitespaces";
    }
    return null;
  }

  //Confirm Validation
  String? _confPassValidator(String? value) {
    if (value!.isEmpty) {
      return "Field Cannot Be Empty";
    }
    if (value != _passwordController.text) {
      return "Password do not match";
    }
    return null;
  }

  // Validate Submit Button
  void _validateSubmit() {
    if (_formKey.currentState!.validate()) {
      createUser();
    }
  }

  Future<void> createUser() async {
    try {
      UserCredential userCred = await auth.createUserWithEmailAndPassword(
          email: _emailTextController.text,
          password: _confirmPassController.text);

      Fluttertoast.showToast(msg: "User Created..");
      uid = userCred.user!.uid;
      writeToData();
      print(uid);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      print(e);
    }
  }

  void writeToData() {
    final Employees = <String, String>{
      "Name": _nameController.text,
      "Employee ID": _employeeId.text,
      "Email": _emailTextController.text,
      "Phone": _phoneController.text,
      "Password": _confirmPassController.text,
    };

    db
        .collection("Employees")
        .doc(uid)
        .set(Employees)
        .onError((error, StackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }
}

// auth
//           .createUserWithEmailAndPassword(
//               email: _emailTextController.text,
//               password: _confirmPassController.text)
//           .then((value) {
//         // writeToData();
//         Fluttertoast.showToast(msg: "User created Successfully....");
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const LoginScreen()));
//       }).onError((error, StackTrace) {
//         Fluttertoast.showToast(
//             msg: "Unable to create User ${error.toString()}");
//       });
