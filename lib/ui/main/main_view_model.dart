import 'package:currency_exchange/data/repository/rate_repository.dart';
import 'package:flutter/material.dart';

import 'main_state.dart';

class MainViewModel extends ChangeNotifier {
  final RateRepository _rateRepository;

  MainState _state = const MainState();

  MainState get state => _state;

  MainViewModel({
    required RateRepository rateRepository,
  }) : _rateRepository = rateRepository {
    _updateRateResult(state.baseCode);
  }

  Future<void> _updateRateResult(String baseCode) async {
    final result = await _rateRepository.getRateResult(baseCode);
    _state = state.copyWith(rateResult: result);
    notifyListeners();
  }

  void inputBaseMoney(num baseMoney) {
    var rate = state.rateResult!.rates.firstWhere((rate) => rate.code == state.targetCode).rate;

    _state = state.copyWith(
      baseMoney: baseMoney,
      targetMoney: baseMoney * rate,
    );
    notifyListeners();
  }

  void inputBaseCode(String baseCode) async {
    if (baseCode == _state.targetCode) {
      _state = state.copyWith(baseCode: baseCode, targetCode: _state.baseCode);
    } else {
      _state = state.copyWith(baseCode: baseCode);
    }

    await _updateRateResult(baseCode);

    var rate = state.rateResult!.rates.firstWhere((rate) => rate.code == state.targetCode).rate;

    _state = state.copyWith(targetMoney: state.baseMoney * rate);

    notifyListeners();
  }

  void targetBaseMoney(num targetMoney) async {
    var rate = state.rateResult!.rates.firstWhere((rate) => rate.code == state.targetCode).rate;

    _state = state.copyWith(
      targetMoney: targetMoney,
      baseMoney: targetMoney / rate,
    );
    notifyListeners();
  }

  void targetBaseCode(String targetCode) async {
    if (targetCode == _state.baseCode) {
      await _updateRateResult(state.baseCode);
      _state = state.copyWith(baseCode: _state.targetCode, targetCode: targetCode);
    } else {
      _state = state.copyWith(targetCode: targetCode);
    }
    var rate = state.rateResult!.rates.firstWhere((rate) => rate.code == state.targetCode).rate;

    _state = state.copyWith(
      baseMoney: state.targetMoney / rate,
    );

    notifyListeners();
  }
}
