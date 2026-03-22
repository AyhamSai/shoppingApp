import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/user_provider.dart';
import 'language_provider.dart';
import 'shop_page.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewLogin extends StatefulWidget {
  const NewLogin({super.key});

  @override
  State<NewLogin> createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  bool isLoading = false;
  PhoneNumber? tempPhoneNumber;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          lang.translate('صفحة الاشتراك', 'Sign Up'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lang.translate(
                    'أدخل معلوماتك الآن',
                    'Enter Your Information',
                  ),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.translate(
                        "رجاءً أدخل اسمك الكامل",
                        "Please Enter Your Full Name",
                      );
                    }
                    RegExp nameRegExp = RegExp(r"^[A-Z][a-z]*$");
                    if (!nameRegExp.hasMatch(value)) {
                      return lang.translate(
                        'الاسم يجب أن يبدأ بحرف كبير',
                        "The name must start by capital character",
                      );
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    icon: Icon(
                      Icons.person_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    labelText: lang.translate('الاسم الكامل', 'userName'),
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(141, 33, 149, 243),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.translate(
                        "رجاءً أدخل إيميلك",
                        "Please Enter Your Email",
                      );
                    }
                    if (!value.contains("@gmail.com")) {
                      return lang.translate(
                        "يجب أن يحتوي الإيميل على gmail.com@",
                        "The email must be as @gmail.com",
                      );
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    labelText: lang.translate("الايميل", "Email"),
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(141, 33, 149, 243),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber phone) {
                    tempPhoneNumber = phone;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.translate(
                        'رجاءً أدخل رقم هاتفك',
                        "Please Enter Your Phone",
                      );
                    }
                    if (value.startsWith('0')) {
                      return lang.translate(
                        'رقم الهاتف لا يجب أن يبدأ ب 0',
                        "Phone Number cannot start with 0",
                      );
                    }
                    String cleanNumber = value.replaceAll(RegExp(r'\D'), '');
                    if (cleanNumber.length < 7) {
                      return lang.translate(
                        'الرقم قصير جداً أقل من 7',
                        "The Number is too short less than 7 ",
                      );
                    }
                    if (cleanNumber.length > 13) {
                      return lang.translate(
                        'الرقم طويل جداً أكثر من 13',
                        "The Number is too long(more than 13)",
                      );
                    }
                    return null;
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DROPDOWN,
                    showFlags: true,
                    setSelectorButtonAsPrefixIcon: true,
                    leadingPadding: 10,
                  ),
                  textFieldController: numberController,
                  initialValue: PhoneNumber(isoCode: 'SY'),
                  inputDecoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    icon: Icon(
                      Icons.phone_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    labelText: lang.translate('رقم الهاتف', 'Phone Number'),
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(141, 33, 149, 243),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: pass,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.translate(
                        "رجاء أدخل كلمة المرور",
                        "Please Enter Your Password",
                      );
                    }
                    if (value.length < 8) {
                      return lang.translate(
                        "كلمة المرور يجب أن تكون 8 خانات أو أكثر",
                        "The password must be 8 characters or more",
                      );
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    icon: Icon(
                      Icons.lock_outline,
                      color: Colors.blue,
                      size: 30,
                    ),
                    labelText: lang.translate("كلمة السر", 'Password'),
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(141, 33, 149, 243),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: confirmPass,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.translate(
                        "رجاء أكد كلمة المرور",
                        "Please Confirm Your Password",
                      );
                    }
                    if (value.length < 8) {
                      return lang.translate(
                        "كلمة المرور يجب أن تكون 8 خانات أو أكثر",
                        "The password must be 8 characters or more",
                      );
                    }
                    if (value != pass.text) {
                      return lang.translate('كلمات المرور غير متشابهة', "Passwords don't match");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    icon: Icon(
                      Icons.lock_outline,
                      color: Colors.blue,
                      size: 30,
                    ),
                    labelText: lang.translate("تأكيد كلمة السر", 'Confirm Password'),
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(141, 33, 149, 243),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: pass.text.trim(),
                            );
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(credential.user!.uid)
                            .set({
                              'name': nameController.text.trim(),
                              'phone': tempPhoneNumber?.phoneNumber ?? "",
                              'email': emailController.text.trim(),
                              'imageUrl': '',
                            });
                        if (!mounted) return;
                        Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).saveUserDate(
                          nameController.text,
                          emailController.text,
                          tempPhoneNumber?.phoneNumber ?? "",
                          tempPhoneNumber?.isoCode ?? "SA",
                          pass.text,
                        );
                        setState(() {
                          isLoading = true;
                        });
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(lang.translate("تم تسجيل الدخول بنجاح", "Login Successfuly"))),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ShopPage()),
                          );
                        });
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        if (!mounted) return;
                        String message = lang.translate("خطأ في التسجيل", "error when login");
                        if (e.code == 'email-already-in-use') {
                          message = lang.translate("الايميل موجود مسبقا", "Email is Used before");
                        } else if (e.code == 'weak-password') {
                          message = lang.translate('كلمة المرور ضعيفة', "the password is weak");
                        }
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          lang.translate('تسجيل', 'Login'),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
