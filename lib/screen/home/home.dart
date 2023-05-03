import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int passLength = 16;
  bool _includeNumber = false;
  bool _includeLetter = false;
  bool _includeSymbol = false;
  String generatedPassword = '';
  @override
  void initState() {
    super.initState();
  }

  void _generate() {
    String password = GeneratePasswordService.generatePassword(
      includeLetters: _includeLetter,
      includeNumbers: _includeNumber,
      includeSymbols: _includeSymbol,
      length: passLength,
      context: context,
    );
    setState(() {
      generatedPassword = password;
    });
  }

  //! call back function to update include sumbols
  void _handleIncludeNumberChanged(bool value) {
    setState(() {
      _includeNumber = value;
    });
  }

  void _handleIncludeLetterChanged(bool value) {
    setState(() {
      _includeLetter = value;
    });
  }

  void _handleIncludeSymbolChanged(bool value) {
    setState(() {
      _includeSymbol = value;
    });
  }

  //! call back function to update password length
  void _updatePasswordLength(int length) {
    setState(() {
      passLength = length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DASHBOARD',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (generatedPassword.length < 5) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Oops!'),
                        content: const Text(
                            'Please generate a password before you can save it'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          )
                        ],
                      );
                    },
                  );
                } else {
                  context.goNamed(
                    'save password',
                    queryParameters: <String, String>{
                      'generatedPassword': generatedPassword
                    },
                  );
                }
              },
              icon: const Icon(
                Icons.cloud_upload,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                One(uid: uid),
                const SizedBox(height: 15),
                Two(generatedPassword: generatedPassword),
                const SizedBox(height: 10),
                Three(
                    length: passLength, onLengthChanged: _updatePasswordLength),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    'SETTING',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Four(
                  title: 'Include Numbers',
                  onIncludeSymbolChanged: _handleIncludeNumberChanged,
                ),
                Four(
                  title: 'Include Letters',
                  onIncludeSymbolChanged: _handleIncludeLetterChanged,
                ),
                Four(
                  title: 'Include Symbols',
                  onIncludeSymbolChanged: _handleIncludeSymbolChanged,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  style: ButtonStyle(
                    // remove border radius
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _generate();
                  },
                  child: const Text(
                    'GENERATE PASSWORD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

typedef OnIncludeChanged = void Function(bool value);

class Four extends StatefulWidget {
  final OnIncludeChanged onIncludeSymbolChanged;
  final String title;
  // i want to pass from the parent to child for bool includeSymbol
  const Four({
    required this.onIncludeSymbolChanged,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<Four> createState() => _FourState();
}

class _FourState extends State<Four> {
  bool includeSymbol = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Switch(
                inactiveThumbColor: Theme.of(context).primaryColor,
                inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
                value: includeSymbol,
                onChanged: (value) {
                  setState(() {
                    includeSymbol = value;
                  });
                  widget.onIncludeSymbolChanged(value);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Three extends StatefulWidget {
  const Three({
    required this.length,
    required this.onLengthChanged,
    Key? key,
  }) : super(key: key);

  final int length;
  final ValueChanged<int> onLengthChanged;

  @override
  State<Three> createState() => _ThreeState();
}

class _ThreeState extends State<Three> {
  late int _passwordLength;

  @override
  void initState() {
    super.initState();
    _passwordLength = widget.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Length: $_passwordLength',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
            ),
            Row(
              children: [
                Text(
                  '8',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _passwordLength.toDouble(),
                    min: 8,
                    max: 100,
                    inactiveColor: Theme.of(context).canvasColor,
                    // divisions: 55,
                    divisions: 42,
                    label: _passwordLength.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _passwordLength = value.toInt();
                        widget.onLengthChanged(_passwordLength);
                      });
                    },
                  ),
                ),
                Text(
                  '100',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Two extends StatefulWidget {
  const Two({
    required this.generatedPassword,
    super.key,
  });
  final String generatedPassword;

  @override
  State<Two> createState() => _TwoState();
}

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

class _TwoState extends State<Two> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.generatedPassword.isNotEmpty) {
          copyToClipboard(widget.generatedPassword);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Successful',
              ),
              content:
                  const Text('Password was successfully copied to clipboard.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('SAVE'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please generate a password')));
        }
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GENERATED PASSWORD',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor),
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text(
                    widget.generatedPassword.isNotEmpty
                        ? widget.generatedPassword
                        : 'PLEASE GENERATE',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Tap here copy generated password',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class One extends StatelessWidget {
  const One({
    super.key,
    required this.uid,
  });

  final String? uid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Generate Password",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        CircleAvatar(
          radius: 34,
          backgroundColor: Theme.of(context).primaryColor,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              "https://api.multiavatar.com/$uid Bond.png",
            ),
          ),
        )
      ],
    );
  }
}
