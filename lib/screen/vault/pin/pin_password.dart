import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/export.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinPassword extends StatefulWidget {
  const PinPassword({super.key});

  @override
  State<PinPassword> createState() => _PinPasswordState();
}

class _PinPasswordState extends State<PinPassword> {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    String isSecureCode = '';

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Verify'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          BrandTitle(
            title: 'Security Pin',
            id: uid ?? '',
          ),
          isSecureCode.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                )
              : const SizedBox(
                  height: 20,
                ),
          isSecureCode.isNotEmpty
              ? VerifiedPin(uid: uid ?? '', correctPin: '1234')
              : const SetUpPin(),
        ],
      ),
    );
  }
}

class VerifiedPin extends StatefulWidget {
  const VerifiedPin({
    super.key,
    required this.uid,
    required this.correctPin,
  });
  final String uid;
  final String correctPin;
  @override
  State<VerifiedPin> createState() => _VerifiedPinState();
}

class _VerifiedPinState extends State<VerifiedPin> {
  final TextEditingController _pinController = TextEditingController();
  int pin = 0;
  void _onSubmitPin(String value) {
    if (int.parse(value) != widget.correctPin) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text('Please enter a correct pin to continue'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else {
      // TODO if pin is correct
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please enter your security pin',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: SizedBox(
            height: 100,
            child: Center(
              child: PinCodeTextField(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                useHapticFeedback: true,
                appContext: context,
                length: 4,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveFillColor: Colors.transparent,
                  inactiveColor: Theme.of(context).primaryColor,
                  activeFillColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                animationDuration: const Duration(milliseconds: 300),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                enableActiveFill: true,
                controller: _pinController,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  _onSubmitPin(v);
                },
                onChanged: (value) {
                  setState(() {
                    pin = int.parse(value);
                  });
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BrandButton(
            onPressed: () {
              _onSubmitPin(pin.toString());
            },
            title: 'Continue')
      ],
    );
  }
}

class SetUpPin extends StatefulWidget {
  const SetUpPin({super.key});

  @override
  State<SetUpPin> createState() => _SetUpPinState();
}

final TextEditingController _pin = TextEditingController();
final TextEditingController _confirmPin = TextEditingController();

class _SetUpPinState extends State<SetUpPin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please set a vault PIN',
          style: TextStyle(
              // color: Theme.of(context).hintColor,
              fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
              fontWeight: FontWeight.bold),
        ),
        Text(
          '* Note: This pin will b use to open your vault.',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Enter PIN',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        // CardPinTry(controller: _pin),
        Card(
          child: SizedBox(
            height: 100,
            child: Center(
              child: PinCodeTextField(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                useHapticFeedback: true,
                appContext: context,
                length: 4,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveFillColor: Colors.transparent,
                  inactiveColor: Theme.of(context).primaryColor,
                  activeFillColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                animationDuration: const Duration(milliseconds: 300),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                enableActiveFill: true,
                // controller: controller,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  // onSubmit(v);
                },
                onChanged: (value) {
                  // onSubmit(value);
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Confirm PIN',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Card(
          child: SizedBox(
            height: 100,
            child: Center(
              child: PinCodeTextField(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                useHapticFeedback: true,
                appContext: context,
                length: 4,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveFillColor: Colors.transparent,
                  inactiveColor: Theme.of(context).primaryColor,
                  activeFillColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                animationDuration: const Duration(milliseconds: 300),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                enableActiveFill: true,
                // controller: controller,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  // onSubmit(v);
                },
                onChanged: (value) {
                  // onSubmit(value);
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BrandButton(
            onPressed: () {
              // _onSubmitPin(pin.toString());
            },
            title: 'Submit')
      ],
    );
  }
}

class CardPinTry extends StatelessWidget {
  const CardPinTry({
    super.key,
    required this.controller,
    required this.onSubmit,
  });
  final TextEditingController controller;
  final Function(String) onSubmit;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: PinCodeTextField(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            useHapticFeedback: true,
            appContext: context,
            length: 4,
            obscureText: true,
            obscuringCharacter: '*',
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              inactiveFillColor: Colors.transparent,
              inactiveColor: Theme.of(context).primaryColor,
              activeFillColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            animationDuration: const Duration(milliseconds: 300),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            enableActiveFill: true,
            controller: controller,
            keyboardType: TextInputType.number,
            onCompleted: (v) {
              onSubmit(v);
            },
            onChanged: (value) {
              onSubmit(value);
            },
            beforeTextPaste: (text) {
              return true;
            },
          ),
        ),
      ),
    );
  }
}
