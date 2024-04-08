import 'package:flutter/services.dart';

class CloudPaymentsService {
  static const platform = MethodChannel('com.example.yourapp/cloudpayments');

  static Future<void> startPayment() async {
    try {
      final String result = await platform.invokeMethod('startPayment', {
        "amount": "100.00", // Сумма оплаты
        "currency": "RUB", // Валюта
        "description": "Описание платежа", // Описание платежа
      });
      print(result); // Вывод результата
    } on PlatformException catch (e) {
      print("Failed to invoke method: '${e.message}'");
    }
  }
}
