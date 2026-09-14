import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      home: CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _output = "0";
  String _currentInput = "0";
  String _history = ""; 
  
  List<String> _historyList = []; 
  
  double _num1 = 0;
  double _num2 = 0;
  String _operand = "";
  bool _isNewNumber = false;

  bool _isDarkMode = true;

  String _formatNumber(String s) {
    if (s == "Erro" || s.isEmpty || s == "-") return s;
    
    List<String> parts = s.split(".");
    String intPart = parts[0];
    String decPart = parts.length > 1 ? ".${parts[1]}" : "";
    
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    intPart = intPart.replaceAllMapped(reg, (Match m) => '${m[1]},');
    
    return intPart + decPart;
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "0";
        _history = "";
        _historyList.clear(); 
        _num1 = 0;
        _num2 = 0;
        _operand = "";
      } else if (buttonText == "⌫") {
        if (_currentInput.length > 1) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        } else {
          _currentInput = "0";
        }
        _output = _currentInput;
      } else if (buttonText == "+/-") {
        if (_currentInput != "0" && _currentInput.isNotEmpty) {
          if (_currentInput.startsWith("-")) {
            _currentInput = _currentInput.substring(1);
          } else {
            _currentInput = "-$_currentInput";
          }
          _output = _currentInput;
        }
      } else if (buttonText == "%") {
        double currentNum = double.tryParse(_currentInput) ?? 0;
        double resultPercent = 0;
        if (_operand == "+" || _operand == "-") {
          resultPercent = (_num1 * currentNum) / 100;
        } else {
          resultPercent = currentNum / 100;
        }
        
        resultPercent = double.parse(resultPercent.toStringAsFixed(10));
        
        _currentInput = resultPercent == resultPercent.truncateToDouble()
            ? resultPercent.toInt().toString()
            : resultPercent.toString();
        _output = _currentInput;
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
        _num1 = double.tryParse(_currentInput) ?? 0;
        _operand = buttonText;
        
        String strNum1 = _num1 == _num1.truncateToDouble() ? _num1.toInt().toString() : _num1.toString();
        _history = "${_formatNumber(strNum1)} $_operand";
        
        _isNewNumber = true;
      } else if (buttonText == "=") {
        _num2 = double.tryParse(_currentInput) ?? 0;
        double result = 0;

        if (_operand == "+") result = _num1 + _num2;
        else if (_operand == "-") result = _num1 - _num2;
        else if (_operand == "×") result = _num1 * _num2;
        else if (_operand == "÷") {
          if (_num2 == 0) {
            _output = "Erro";
            _currentInput = "0";
            _operand = "";
            return;
          }
          result = _num1 / _num2;
        } else {
          return;
        }

        result = double.parse(result.toStringAsFixed(10));

        String strNum1 = _num1 == _num1.truncateToDouble() ? _num1.toInt().toString() : _num1.toString();
        String strNum2 = _num2 == _num2.truncateToDouble() ? _num2.toInt().toString() : _num2.toString();
        String resultStr = result == result.truncateToDouble() ? result.toInt().toString() : result.toString();

        _historyList.add("${_formatNumber(strNum1)} $_operand ${_formatNumber(strNum2)} = ${_formatNumber(resultStr)}");
        if (_historyList.length > 2) {
          _historyList.removeAt(0);
        }

        _history = "${_formatNumber(strNum1)} $_operand ${_formatNumber(strNum2)}";
        _currentInput = resultStr;
        _output = _currentInput;
        _operand = "";
        _isNewNumber = true;
      } else {
        if (_isNewNumber) {
          _currentInput = buttonText == "." ? "0." : buttonText;
          _isNewNumber = false;
        } else {
          if (buttonText == ".") {
            if (_currentInput.contains(".")) return;
            _currentInput += buttonText;
          } else {
            if (_currentInput == "0") {
              _currentInput = buttonText;
            } else {
              _currentInput += buttonText;
            }
          }
        }
        _output = _currentInput;
      }
    });
  }

  Widget _buildButton(String text, Color textColor, Color bgColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = _isDarkMode ? const Color(0xFF17171C) : const Color(0xFFF1F2F3);
    Color textColor = _isDarkMode ? Colors.white : Colors.black;
    
    Color btnNumBg = _isDarkMode ? const Color(0xFF2E2F38) : Colors.white;
    Color btnNumText = _isDarkMode ? Colors.white : Colors.black;
    
    Color btnActionBg = _isDarkMode ? const Color(0xFF4E505F) : const Color(0xFFD2D3DA);
    Color btnActionText = _isDarkMode ? Colors.white : Colors.black;
    
    const Color btnGreenBg = Colors.green;
    const Color btnGreenText = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDarkMode = !_isDarkMode;
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 35,
                      decoration: BoxDecoration(
                        color: _isDarkMode ? const Color(0xFF2E2F38) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.wb_sunny_outlined, 
                               color: _isDarkMode ? Colors.grey : Colors.black, size: 20),
                          Icon(Icons.nightlight_round, 
                               color: _isDarkMode ? Colors.white : Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (String conta in _historyList)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          conta,
                          style: TextStyle(
                            fontSize: 18.0, 
                            color: _isDarkMode ? Colors.grey[700] : Colors.grey[400], 
                          ),
                        ),
                      ),
                    Text(
                      _history,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatNumber(_output),
                      style: TextStyle(
                        fontSize: 64.0,
                        fontWeight: FontWeight.w300,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, 
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton("C", Colors.white, Colors.red),
                      _buildButton("+/-", btnActionText, btnActionBg),
                      _buildButton("%", btnActionText, btnActionBg),
                      _buildButton("÷", btnGreenText, btnGreenBg), 
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("7", btnNumText, btnNumBg),
                      _buildButton("8", btnNumText, btnNumBg),
                      _buildButton("9", btnNumText, btnNumBg),
                      _buildButton("×", btnGreenText, btnGreenBg), 
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("4", btnNumText, btnNumBg),
                      _buildButton("5", btnNumText, btnNumBg),
                      _buildButton("6", btnNumText, btnNumBg),
                      _buildButton("-", btnGreenText, btnGreenBg), 
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("1", btnNumText, btnNumBg),
                      _buildButton("2", btnNumText, btnNumBg),
                      _buildButton("3", btnNumText, btnNumBg),
                      _buildButton("+", btnGreenText, btnGreenBg), 
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton(".", btnNumText, btnNumBg),
                      _buildButton("0", btnNumText, btnNumBg),
                      _buildButton("⌫", btnNumText, btnNumBg), 
                      _buildButton("=", btnGreenText, btnGreenBg), 
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}