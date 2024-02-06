import 'package:flutter/material.dart';
import 'dart:math';


void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";

  void _onButtonPressed(String buttonText) {
    setState(() {
      _output = Calculator.calculate(_output, buttonText);
    });
  }

  void _onClearPressed() {
    setState(() {
      _output = "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: TextStyle(fontSize: 48.0),
              ),
            ),
          ),
          _buildButtonRow(["7", "8", "9", "/"]),
          _buildButtonRow(["4", "5", "6", "x"]),
          _buildButtonRow(["1", "2", "3", "-"]),
          _buildButtonRow(["0", "C", "=", "+"]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onClearPressed,
        tooltip: 'Clear',
        child: Icon(Icons.clear),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttonValues) {
    return Expanded(
      child: Row(
        children: buttonValues
            .map((buttonValue) => _buildCalculatorButton(buttonValue))
            .toList(),
      ),
    );
  }

  Widget _buildCalculatorButton(String buttonText) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _onButtonPressed(buttonText);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }
}

class Calculator {
  static String calculate(String currentOutput, String buttonText) {
    if (buttonText == "C") {
      return _clearDisplay();
    } else if (buttonText == "=") {
      return _evaluateExpression(currentOutput);
    } else {
      return _appendDigit(currentOutput, buttonText);
    }
  }

  static String _clearDisplay() {
    return "0";
  }

  static String _evaluateExpression(String expression) {
    try {
      return _parseAndEvaluate(expression).toString();
    } catch (e) {
      return "baki ta pari na";
    }
  }

  static double _parseAndEvaluate(String expression) {
    List<String> tokens = expression.split(RegExp(r'([+/\-*])'));

    double result = _safeConvert(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = _safeConvert(tokens[i + 1]);

      if (operator == '+') {
        result += operand;
      } else if (operator == '-') {
        result -= operand;
      } else if (operator == 'x') {
        result *= operand;
      } else if (operator == '/') {
        result /= operand;
      }
    }

    return result;
  }

  static double _safeConvert(String value) {
    double? result = double.tryParse(value);
    if (result != null) {
      return result;
    } else {
      throw FormatException("Invalid number format");
    }
  }

  static String _appendDigit(String currentOutput, String digit) {
    if (currentOutput == "0" || currentOutput == "Error") {
      return digit;
    } else {
      return currentOutput + digit;
    }
  }
}

