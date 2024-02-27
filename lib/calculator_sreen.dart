import 'package:calculator/Button_value.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String opeater = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$opeater$number2".isEmpty
                        ? "0"
                        : "$number1$opeater$number2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //Button

            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n1
                          ? ScreenSize.width / 2
                          : (ScreenSize.width / 4),
                      height: ScreenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (opeater.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;

    switch (opeater) {
      case Btn.add:
        result = num1 + num2;
        break;

      case Btn.subtract:
        result = num1 - num2;
        break;

      case Btn.multiply:
        result = num1 * num2;
        break;

      case Btn.devide:
        result = num1 / num2;
        break;

      default:
    }
    setState(() {
      number1 = "$result";

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      opeater = "";
      number2 = "";
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && opeater.isNotEmpty && number2.isNotEmpty) {}
    if (opeater.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      opeater = "";
      number2 = "";
    });
  }

  void clearAll() {
    setState(() {
      number1 = "";
      opeater = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (opeater.isNotEmpty) {
      opeater = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (opeater.isEmpty && number2.isNotEmpty) {}
      opeater = value;
    } else if (number1.isEmpty || opeater.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n1)) {
        value = "0.";
      }

      number1 += value;
    } else if (number2.isEmpty || opeater.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n1)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }
}

Color getBtnColor(value) {
  return [Btn.del, Btn.clr].contains(value)
      ? Colors.blueGrey
      : [
          Btn.per,
          Btn.multiply,
          Btn.add,
          Btn.subtract,
          Btn.devide,
          Btn.calculate,
        ].contains(value)
          ? Colors.orange
          : Colors.black87;
}
