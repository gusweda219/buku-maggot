import 'package:buku_maggot_app/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

class TransactionFormPage extends StatefulWidget {
  static const routeName = '/transaction_form_page';
  static const income = 'income';
  static const expense = 'expense';
  final String typeForm;

  const TransactionFormPage({Key? key, required this.typeForm})
      : super(key: key);

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final TextEditingController _calcController = TextEditingController();
  bool _isCalcKeyboardVisible = true;
  bool _isInputVisible = false;

  String _expression = '';
  String _history = '';
  String _display = '';
  bool _isOperatorActive = false;

  List<String> numberFormat() {
    final regex = RegExp(r"(?<=\+|-|\*|/|=)|(?=\+|-|\*|/|=)");
    final str = _expression;
    final splitList = str.split(regex);

    var formatter = NumberFormat("#,##0", "pt_BR");

    var temp = splitList.map((element) {
      if (element != '+' &&
          element != '-' &&
          element != '*' &&
          element != '/') {
        var arr = element.split(',');

        if (arr.length < 2) {
          return formatter.format(int.parse(element)).toString();
        } else {
          return formatter.format(int.parse(arr[0])).toString() + ',' + arr[1];
        }
      } else {
        return " $element ";
      }
    }).toList();

    return temp;
  }

  void numClick(String text) {
    if (_expression.isEmpty && (text == '0' || text == '00')) {
      return;
    }

    _expression += text;

    setState(() => _display = numberFormat().join());
    _isOperatorActive = false;
    _isInputVisible = true;

    evaluate('helo');
  }

  void opeClick(String text) {
    if (!_isOperatorActive) {
      if (_expression.isEmpty) {
        _expression = '0';
        _expression += text;
        setState(() => _display += " $text ");
        _isOperatorActive = true;
      } else {
        _expression += text;
        setState(() => _display += " $text ");
        _isOperatorActive = true;
      }
    } else {
      _expression = _expression.substring(0, _expression.length - 1);
      _display = _display.substring(0, _display.length - 1);
      _expression += text;
      setState(() => _display += " $text ");
    }
  }

  void clear(String text) {
    _expression = '';
    _isOperatorActive = false;
    _calcController.text = '';
    _calcController.selection = TextSelection.fromPosition(
        TextPosition(offset: _calcController.text.length));
    setState(() {
      _display = '';
      _isInputVisible = false;
    });
  }

  void delete(String text) {
    if (_expression.isEmpty) {
      return;
    } else {
      _expression = _expression.substring(0, _expression.length - 1);
      if (_expression.isEmpty) {
        setState(() {
          _isInputVisible = false;
        });
        _calcController.text = '';
        _calcController.selection = TextSelection.fromPosition(
            TextPosition(offset: _calcController.text.length));
      } else {
        setState(() {
          if (int.tryParse(_expression[_expression.length - 1]) != null) {
            _isOperatorActive = false;
          } else {
            _isOperatorActive = true;
          }
          _display = numberFormat().join();
        });
        evaluate('helo');
      }
    }
  }

  void evaluate(String text) {
    String finalUserInput = _expression;
    finalUserInput = _expression.replaceAll(',', '.');

    if (_isOperatorActive) {
      finalUserInput = finalUserInput.substring(0, finalUserInput.length - 1);
    }

    Parser p = Parser();
    Expression exp = p.parse(finalUserInput);
    ContextModel cm = ContextModel();

    var eval = exp.evaluate(EvaluationType.REAL, cm);

    if (eval == 0 || eval == double.infinity) {
      _calcController.text = '';
      _calcController.selection = TextSelection.fromPosition(
          TextPosition(offset: _calcController.text.length));
      _history = '';
    } else {
      var formatter = NumberFormat("#,##0", "pt_BR");
      if (eval % 1 == 0) {
        _calcController.text = formatter.format(eval).toString();
        _calcController.selection = TextSelection.fromPosition(
            TextPosition(offset: _calcController.text.length));
        _history = eval.toStringAsFixed(0);
      } else {
        var arr = eval.toStringAsFixed(2).split('.');
        _calcController.text =
            formatter.format(int.parse(arr[0])).toString() + ',' + arr[1];
        _calcController.selection = TextSelection.fromPosition(
            TextPosition(offset: _calcController.text.length));
        _history = eval.toStringAsFixed(2);
      }
    }
  }

  void done(String text) {
    FocusScope.of(context).unfocus();
    setState(() {
      _isInputVisible = false;
      _isCalcKeyboardVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: widget.typeForm == TransactionFormPage.income
            ? Text('Pemasukan')
            : Text('Pengeluaran'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.typeForm == TransactionFormPage.income
                      ? Text('Total Pemasukan')
                      : Text(' Total Pengeluaran'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue,
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Rp.'),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _calcController,
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  border: InputBorder.none,
                                ),
                                readOnly: true,
                                showCursor: true,
                                autofocus: true,
                                onTap: () {
                                  if (_history.isNotEmpty) {
                                    var a = _calcController.text;
                                    a.replaceAll('.', '');
                                    print('h');
                                    _expression = a;
                                    setState(() {
                                      _isInputVisible = true;
                                      _isCalcKeyboardVisible = true;
                                    });
                                  } else {
                                    setState(() {
                                      _isCalcKeyboardVisible = true;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _isInputVisible,
                          child: Text(
                            _display,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Tanggal'),
                  TextField(
                    onTap: () {
                      setState(() {
                        _isCalcKeyboardVisible = false;
                      });

                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2045),
                      );
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Catatan'),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'asd',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _isCalcKeyboardVisible = false;
                      });
                    },
                  ),
                  Container(
                    height: 1000,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isCalcKeyboardVisible,
            child: Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          calculatorKey('C', clear),
                          calculatorKey('/', opeClick),
                          calculatorKey('*', opeClick),
                          calculatorKey('DEL', delete),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          calculatorKey('7', numClick),
                          calculatorKey('8', numClick),
                          calculatorKey('9', numClick),
                          calculatorKey('-', opeClick),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          calculatorKey('4', numClick),
                          calculatorKey('5', numClick),
                          calculatorKey('6', numClick),
                          calculatorKey('+', opeClick),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          calculatorKey('1', numClick),
                          calculatorKey('2', numClick),
                          calculatorKey('3', numClick),
                          calculatorKey(',', opeClick),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          calculatorKey('0', numClick),
                          calculatorKey('00', numClick),
                          calculatorKey('000', numClick),
                          calculatorKey('DONE', done),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _calcController.dispose();
    super.dispose();
  }
}

Widget calculatorKey(String key, Function onTap) {
  return Expanded(
    child: GestureDetector(
      child: Container(
        color: Colors.white,
        child: Center(child: Text(key)),
      ),
      onTap: () {
        onTap(key);
      },
    ),
  );
}
