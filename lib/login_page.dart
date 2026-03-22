import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'new_login.dart';
import 'shop_page.dart';
import 'language_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          lang.translate("صفحة تسجيل الدخول", "Login Page"),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person,color: Colors.blueGrey[400],size: 100),
                Text(
                  lang.translate("أهلاً بعودتك", "Welcome Back"),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  lang.translate("سجل الدخول لتستمر", 'Login To Continue'),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.translate("رجاءً أدخل إيميلك", "Please Enter Your Email");
                    }
                    if (!value.contains("@gmail.com")) {
                      return lang.translate("يجب أن يحتوي الإيميل على gmail.com@", "The email must be as @gmail.com");
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
                    icon: Icon(Icons.email_outlined, color: Colors.blue),
                    labelText: lang.translate("الايميل", "Email"),
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(141, 33, 149, 243),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return lang.translate("رجاء أدخل كلمة المرور", "Please Enter Your Password");
                    }
                    if (value.length < 8) {
                      return lang.translate("كلمة المرور يجب أن تكون 8 خانات أو أكثر", "The password must be 8 characters or more");
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
                    icon: Icon(Icons.lock_outline, color: Colors.blue),
                    labelText: lang.translate("كلمة السر", 'Password'),
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(141, 33, 149, 243),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passController.text.trim(),
                        );
                        if (!mounted) return;
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(lang.translate("تم تسجيل الدخول بنجاح", "Login Successfuly"))),
                        );
                        Future.delayed(const Duration(seconds: 1), () {
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
                        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
                          message = lang.translate("الايميل أو كلمة السر خطأ", "Email or password are incorrect");
                        }
                        else if (e.code == "invalid=email") {
                          message = lang.translate("الايميل خطأ", "email is incorrect");
                        }
                      
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    lang.translate('تسجيل الدخول', 'Login'),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.translate('هل أنت جديد؟', 'ARE YOU NEW ?'),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewLogin()),
                        );
                      },
                      style: TextButton.styleFrom(
                        elevation: 5,
                      ),
                      child: Text(
                        lang.translate('اشترك الآن', 'SIGN UP'),
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          decorationThickness: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
