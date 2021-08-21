import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_riverpod/provider/orders_provider.dart';
import 'dart:math';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _orderProvider = useProvider(orderStateNotifierProvider.notifier);
    final List<SelectedProductServices> _serviceList = _orderProvider.getServices();
    return Scaffold(
        appBar: AppBar(
          title: Text('test'),
        ),
        body: Center(
          child:
          Consumer(
            builder: (_, watch, __) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (_serviceList.indexWhere((s) => s.id == 1) < 0)
                    GestureDetector(
                      onTap: () => _orderProvider.increment(productId: 1, serviceId: 1, serviceCost: 1),
                      child: Container(
                          width: 200.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.green,
                          ),
                          child: Text('ADD NEW ONE')),
                    )
                  else
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _orderProvider.clearAll(),
                            child: Container(
                                width: 200.0,
                                height: 50.0,
                                margin: EdgeInsets.only(bottom: 30.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Colors.red,
                                ),
                                child: Text('CLEAR ALL')),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => _orderProvider.decrement(productId: 1, serviceId: 1),
                                child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.purple,
                                    ),
                                    child: Text('-')),
                              ),
                              Text('     ${_serviceList[0].count}     '),
                              GestureDetector(
                                onTap: () => _orderProvider.increment(productId: 1, serviceId: 1, serviceCost: 1),
                                child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.yellow,
                                    ),
                                    child: Text('+')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ));
  }
}
