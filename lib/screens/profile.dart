import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loginuicolors/models/userModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

enum CardType { Master, Visa, Verve, Discover, AmericanExpress, DinersClub, Jcb, Others, Invalid }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  Future<UserModel?> readUser() async {
    final snapshot = await FirebaseFirestore.instance.doc('users/' + FirebaseAuth.instance.currentUser!.uid).get();

    if (snapshot.exists)
      return UserModel.fromJson(snapshot.data()!);
    else
      return null;
  }

  Widget buildUser(UserModel user) => ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  user.firstName + ' ' + user.lastName,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.white.withOpacity(0.3),
                  height: 10,
                  indent: 13,
                  endIndent: 13,
                  thickness: 0.5,
                ),
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    '+A' + user.phone.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Colors.white.withOpacity(0.3),
                  height: 1,
                  indent: 13,
                  endIndent: 13,
                  thickness: 0.5,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      child: Text(
                        'Payment Settings',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange.shade500,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => MokejimoInformacija('Tab1')));
                      },
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white.withOpacity(0.3),
                  height: 1,
                  indent: 13,
                  endIndent: 13,
                  thickness: 0.5,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(18, 12, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // fixedSize: Size(70, 20),                           /// override button size
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;
              return user == null ? Center(child: Text('No User')) : buildUser(user);
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.redAccent.shade100,
              ));
            }
          },
        ),
      ),
    );
  }
}

class MokejimoInformacija extends StatefulWidget {
  final String inTab;

  const MokejimoInformacija(this.inTab);

  @override
  State<MokejimoInformacija> createState() => _MokejimoInformacijaState();
}

class _MokejimoInformacijaState extends State<MokejimoInformacija> {
  TextEditingController cardNumberController = TextEditingController();
  CardType cardType = CardType.Invalid;

  void getCardTypeFrmNumber() {
    if (cardNumberController.text.length <= 6) {
      String input = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFrmNumber(input);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
  }

  @override
  void initState() {
    cardNumberController.addListener(
      () {
        getCardTypeFrmNumber();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New card")),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(23, 10, 23, 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: cardNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(19),
                            CardNumberInputFormatter(),
                          ],
                          decoration: InputDecoration(hintText: "Card number"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: TextFormField(
                            decoration: const InputDecoration(hintText: "Full name"),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  // Limit the input
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                decoration: const InputDecoration(hintText: "CVV"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  CardMonthInputFormatter(),
                                ],
                                decoration: const InputDecoration(hintText: "MM/YY"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  child: const Text("Add card"),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unfinished")));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class CardUtils {
  static CardType getCardTypeFrmNumber(String input) {
    CardType cardType;
    if (input.startsWith(RegExp(r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardType.Master;
    } else if (input.startsWith(RegExp(r'[4]'))) {
      cardType = CardType.Visa;
    } else if (input.startsWith(RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
      cardType = CardType.Verve;
    } else if (input.startsWith(RegExp(r'((34)|(37))'))) {
      cardType = CardType.AmericanExpress;
    } else if (input.startsWith(RegExp(r'((6[45])|(6011))'))) {
      cardType = CardType.Discover;
    } else if (input.startsWith(RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
      cardType = CardType.DinersClub;
    } else if (input.startsWith(RegExp(r'(352[89]|35[3-8][0-9])'))) {
      cardType = CardType.Jcb;
    } else if (input.length <= 8) {
      cardType = CardType.Others;
    } else {
      cardType = CardType.Invalid;
    }
    return cardType;
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static Widget? getCardIcon(CardType? cardType) {
    String img = "";
    Icon? icon;
    switch (cardType) {
      case CardType.Master:
        img = 'mastercard.png';
        break;
      case CardType.Visa:
        img = 'visa.png';
        break;
      case CardType.AmericanExpress:
        img = 'american_express.png';
        break;
      case CardType.Discover:
        img = 'discover.png';
        break;
      case CardType.DinersClub:
        img = 'dinners_club.png';
        break;
      case CardType.Jcb:
        img = 'jcb.png';
        break;
      case CardType.Others:
        icon = const Icon(
          Icons.credit_card,
          size: 24.0,
          color: Color(0xFFB8B5C3),
        );
        break;
      default:
        icon = const Icon(
          Icons.warning,
          size: 24.0,
          color: Color(0xFFB8B5C3),
        );
        break;
    }
    Widget? widget;
    if (img.isNotEmpty) {
      widget = Image.asset(
        'assets/images/$img',
        width: 40.0,
      );
    } else {
      widget = icon;
    }
    return widget;
  }

  static String? validateCardNum(String? input) {
    if (input == null || input.isEmpty) {
      return "This field is required";
    }
    input = getCleanedNumber(input);
    if (input.length < 8) {
      return "Card is invalid";
    }
    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);
// every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }
    if (sum % 10 == 0) {
      return null;
    }
    return "Card is invalid";
  }

  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    int year;
    int month;
    if (value.contains(RegExp(r'(/)'))) {
      var split = value.split(RegExp(r'(/)'));

      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }
    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Expiry month is invalid';
    }
    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Expiry year is invalid';
    }
    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }
    return null;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) || convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }
}
