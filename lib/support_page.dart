import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact_card.dart';
import 'language_provider.dart';
import 'shop_page.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  Future<void> launchWatsApp(String phone) async {
    final Uri url = Uri.parse("https://wa.me/$phone");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  Future<void> launchFacebook(String urlPath) async {
    final Uri url = Uri.parse(urlPath);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShopPage()),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          lang.translate('الدعم الفني', 'Technical Support'),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ContactCard(
            title: lang.translate('واتساب', 'WhatsApp'),
            subtitle: '+218947722005',
            icon: IconData(FontAwesomeIcons.whatsapp.codePoint),
            onTap: () => launchWatsApp("218947722005"),
          ),
          ContactCard(
            title: lang.translate('فيسبوك', 'Facebook'),
            subtitle: lang.translate("صفحتنا الرسمية", "Our Official Page"),
            icon: IconData(FontAwesomeIcons.facebook.codePoint),
            onTap: () =>
                launchFacebook("https://www.facebook.com/share/17mWpmLxrb/"),
          ),
        ],
      ),
    );
  }
}
