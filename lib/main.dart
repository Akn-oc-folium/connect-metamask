import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:web3_flutter/js_binding.dart';
import 'dart:js_util' as js_util;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String account = '';
  String chainId = '';
  String blockNumber = '';
  String error = '';

  Future<void> connect() async {
    try {
      final promise = connectWallet() as JSPromise;
      final result = await promise.toDart;

      if (result == null) {
        setState(() {
          error = "Received null result from connectWallet.";
        });
        return;
      }

      if (result is! JSObject) {
        setState(() {
          error = "Unexpected result type: ${result.runtimeType}";
        });
        return;
      }

      final obj = result as JSObject;
      final acc = js_util.getProperty(obj, 'account') as String?;
      final chain = js_util.getProperty(obj, 'chainId') as String?;
      final errMsg = js_util.getProperty(obj, 'error') as String?;

      if (errMsg != null && errMsg.isNotEmpty) {
        setState(() {
          error = errMsg;
        });
        return;
      }

      if (acc == null || chain == null) {
        setState(() {
          error = "Missing account or chainId in response.";
        });
        return;
      }

      setState(() {
        account = acc;
        chainId = chain;
        error = '';
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  Future<void> getBlock() async {
    try {
      final promise = getBlockNumber() as JSPromise;
      final result = await promise.toDart;
      setState(() {
        blockNumber = "Block #: ${result.toString()}";
      });
    } catch (e) {
      setState(() {
        blockNumber = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berachain Dart Interop',
      home: Scaffold(
        appBar: AppBar(title: const Text('Berachain Wallet Connect')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: connect,
                child: const Text('Connect Wallet'),
              ),
              if (error.isNotEmpty) Text('Error: $error'),
              if (account.isNotEmpty) Text('Account: $account'),
              if (chainId.isNotEmpty) Text('Chain ID: $chainId'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: getBlock,
                child: const Text('Get Block Number'),
              ),
              if (blockNumber.isNotEmpty) Text(blockNumber),
            ],
          ),
        ),
      ),
    );
  }
}
