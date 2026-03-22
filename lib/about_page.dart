import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:shopping_app/shop_page.dart';

import 'language_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShopPage()),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          lang.translate('حول', 'About'),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/1.png",
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  SizedBox(height: 15),
                  Text(
                    lang.translate("حول هذا التطبيق", "About This App"),
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      lang.translate(
                        "وجهتك الأولى لأفخم الأحذية التي تدمج بين الأناقة والراحة.\n نسعى لتقديم جودة اسثنائية وتجربة مستخدم فريدة.",
                        "Your first destination for the plush of shoes that integrates between style and comfort. \n We seek deliver exceptional quality and unique user experience",
                      ),
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                lang.translate(
                  'ستيب اب.جميع الحقوق محفوظة @',
                  "StepUp.All Rights Reserved @",
                ),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
