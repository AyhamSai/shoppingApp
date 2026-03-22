import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/carts.dart';
import 'package:shopping_app/shoes.dart';
import 'package:shopping_app/show_card.dart';
import 'language_provider.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).fetchCartFromFirebase();
    });
  }

  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          lang.translate('السلة', "Cart"),
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Icon(Icons.shopping_cart, color: Colors.white),
      ),
      body: StreamBuilder<List<Shoes>>(
        stream: Provider.of<CartProvider>(
          context,
          listen: false,
        ).getCartStreams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                lang.translate('السلة فارغة حاليا', 'Cart Page is Empty'),
              ),
            );
          }
          final cartItems = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.55,
            ),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return ShowCard(shoe: cartItems[index], isCartPage: true);
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final cartList = cartProvider.getCartItems();
          if (cartList.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                int currentStep = 1;
                showDialog(
                  context: context,
                  // barrierDismissible: false,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          content: buildDialogContent(currentStep, (newStep) {
                            setDialogState(() {
                              currentStep = newStep;
                            });
                          }, context),
                        );
                      },
                    );
                  },
                );
              },
              child: Text(
                lang.translate('ادفع الآن', 'Pay Now'),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDialogContent(
    int step,
    Function(int) onStepChanged,
    BuildContext context,
  ) {
    
    final cartProvider = Provider.of<CartProvider>(context);
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController otpController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    double total = cartProvider.getTotalPrice();
    var lang = Provider.of<LanguageProvider>(context);

    if (step == 1) {
      return Form(
        key: formKey,
        child: Column(
          key: ValueKey(1),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lang.translate('تفاصيل الدفع', 'Payment Details'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              lang.translate(
                'السعر الإجمالي  \$${total}',
                "Total Price \$${total}",
              ),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: phoneController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return lang.translate(
                    'رجاءأدخل رقم هاتفك',
                    "Please Enter Your phone Number",
                  );
                }
                if (value.length <= 7 || value.length >= 13) {
                  return lang.translate(
                    'الرقم يجب أن يكون بين 7 و 13',
                    "the number must be between 7 and 13",
                  );
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: lang.translate('رقم الهاتف', 'Phone Number'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lang.translate('تم إرسال الكود', 'code is sent'),
                        ),
                      ),
                    );
                    onStepChanged(2);
                  }
                },
                child: Text(
                  lang.translate('دفع', 'Pay'),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      );
    } else if (step == 2) {
      return Form(
        key: formKey,
        child: Column(
          key: ValueKey(2),
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.vibration, size: 40, color: Colors.blue),
            SizedBox(height: 5),
            Text(lang.translate('تحقق من هاتفك', 'Check Your Phone')),
            SizedBox(height: 5),
            Text(
              lang.translate(
                'أدخل الكود المكون من 6 أرقام',
                'Enter The Code Consisting of 6 digits',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: otpController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return lang.translate(
                    'رجاء أدخل كود OTP',
                    "Please Enter OTP Code",
                  );
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: lang.translate('أدخل كود OTP', 'Enter OTP Code'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 45),
              ),
              onPressed: ()  {
                      if (formKey.currentState!.validate()) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              lang.translate(
                                'تم التحقق بنجاح',
                                "Verified Successfully",
                              ),
                            ),
                          ),
                        );
                        onStepChanged(3);
                      }
                    },
              child: Text(lang.translate('تأكيد', 'Confirm')),
            ),
          ],
        ),
      );
    } else {
      return Column(
        key: ValueKey(3),
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 70),
          SizedBox(height: 15),
          Text(
            lang.translate('تم الدفع بنجاح', "Payment Successful"),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.pop(context);
            },
            child: Text(lang.translate('إغلاق', 'Close')),
          ),
        ],
      );
    }
  }
}
