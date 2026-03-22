import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/language_provider.dart';
import 'package:shopping_app/login_page.dart';
import 'package:shopping_app/shop_page.dart';
import 'about_page.dart';
import 'support_page.dart';

class SidebarDrawer extends StatefulWidget {
  const SidebarDrawer({super.key});

  @override
  State<SidebarDrawer> createState() => _SidebarDrawerState();
}

class _SidebarDrawerState extends State<SidebarDrawer> {
  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    final currentLang = Provider.of<LanguageProvider>(
      context,
      listen: false,
    ).currentLocale.languageCode;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Row(
              children: [
                Text(
                  'Step_Up_shop',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(width: 20),
                Image.asset(
                  "images/1.png",
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.5,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, size: 30, color: Colors.blue),
            title: Text(lang.translate('الرئيسية', 'Home')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShopPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent, size: 30, color: Colors.blue),
            title: Text(lang.translate('الدعم', "Support")),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language, size: 30, color: Colors.blue),
            title: Text(lang.translate('اللغة', "Language")),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String tempSelected = currentLang;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(
                          lang.translate('اختر اللغة ', "Select Language "),
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<String>(
                              title: Text(lang.translate('العربية', "Arabic")),
                              value: 'ar',
                              groupValue: tempSelected,
                              onChanged: (value) {
                                setState(() => tempSelected = value!);
                              },
                            ),
                            RadioListTile<String>(
                              title: Text(
                                lang.translate('الانجليزية', "English"),
                              ),
                              value: 'en',
                              groupValue: tempSelected,
                              onChanged: (value) {
                                setState(() => tempSelected = value!);
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(lang.translate('إلغاء', "Cancel")),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<LanguageProvider>(
                                context,
                                listen: false,
                              ).changLanguage(tempSelected);
                              Navigator.pop(context);
                            },
                            child: Text(lang.translate('تأكيد', "Confirm")),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, size: 30, color: Colors.blue),
            title: Text(lang.translate('حول', "About Us")),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          SizedBox(height: 10),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, size: 30, color: Colors.blue),
            title: Text(
              lang.translate('تسجيل الخروج', 'Log Out'),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    lang.translate(
                      'تم تسجيل الخروج بنجاح',
                      "Logout Successfuly",
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
