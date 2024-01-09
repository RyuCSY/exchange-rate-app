import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const krw = 'KRW';
const usd = 'USD';
const defaultAmount = '1000';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _currencyList = [krw, usd];

  // 기준 통화
  String _baseCurrency = krw;

  // 대상 통화
  String _targetCurrency = usd;

  // 기준 통화 금액
  num _baseAmount = int.parse(defaultAmount);

  // 대상 통화 금액
  num _targetAmount = 0.0;

  TextEditingController _baseInputControl = TextEditingController(text: defaultAmount);
  TextEditingController _targetInputControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('환율 계산기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 기준 통화 금액 입력 필드
            TextField(
              controller: _baseInputControl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '기준 통화 금액',
              ),
              onChanged: (value) {
                _baseAmount = double.parse(value);
              },
            ),
            // 기준 통화 드롭다운 목록
            DropdownButton<String>(
              value: _baseCurrency,
              onChanged: (value) {
                _baseCurrency = value!;
              },
              items: _currencyList.map((e) => buildDropdownMenuItem(e)).toList(),
            ),
            // 대상 통화 금액 입력 필드
            TextField(
              controller: _targetInputControl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '대상 통화 금액',
              ),
            ),
            // 대상 통화 드롭다운 목록
            DropdownButton<String>(
              value: _targetCurrency,
              onChanged: (value) {
                _targetCurrency = value!;
                _updateTargetAmount();
              },
              items: _currencyList.map((e) => buildDropdownMenuItem(e)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildDropdownMenuItem(String currency) {
    currency = currency.toUpperCase();
    return DropdownMenuItem(
      value: currency,
      child: Text(currency),
    );
  }

  // 대상 통화 금액을 업데이트합니다.
  void _updateTargetAmount() {
    // 환율 정보를 가져옵니다.
    double rate = _getRate(_baseCurrency, _targetCurrency);
    // 대상 통화 금액을 계산합니다.
    _targetAmount = _baseAmount * rate;
    // 대상 통화 금액 입력 필드를 업데이트합니다.
    setState(() {
      _targetInputControl.text = '$_targetAmount';
    });
  }

  // 환율 정보를 가져옵니다.
  double _getRate(String base, String target) {
    // TODO: 실제 환율 정보를 가져오는 코드를 작성합니다.
    return 1.0;
  }
}
