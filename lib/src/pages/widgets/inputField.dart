// import 'package:flutter/material.dart';

// class SigningInput extends StatefulWidget {
//   TextEditingController controller;
//   // String Function(String) validator;
//   String initialValue;
//   SigningInput(
//       {@required this.controller, @required this.validator, this.initialValue});

//   @override
//   _SigningInputState createState() => _SigningInputState();
// }

// class _SigningInputState extends State<SigningInput> {
//   TextEditingController _controller;
//   TextEditingController get _effectiveController =>
//       widget.controller ?? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.initialValue);
//   }

//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: _effectiveController,

//     );
//   }
// }
