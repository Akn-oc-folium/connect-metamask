import 'dart:js_interop';
import 'dart:js_util' as js_util;
import 'package:flutter/material.dart';
import 'package:web3_flutter/js_binding.dart';

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
  String error = '';
  String txHash = '';

  final TextEditingController amountController = TextEditingController();

  Future<void> connect() async {
    try {
      final promise = connectWallet();
      final result = await promise.toDart;

      if (result == null) {
        setState(() {
          error = "Received null result.";
        });
        return;
      }

      final obj = result as JSObject;
      final errorVal = js_util.getProperty(obj, 'error') as String?;
      if (errorVal != null && errorVal.isNotEmpty) {
        setState(() {
          error = errorVal;
        });
        return;
      }

      final acc = js_util.getProperty(obj, 'account') as String;
      final cid = js_util.getProperty(obj, 'chainId') as String;

      if (cid.toLowerCase() != '0x138c5') {
        final switchPromise = switchToBerachainBepolia();
        final switchResult = await switchPromise.toDart;
        final switchObj = switchResult as JSObject;
        final switchError = js_util.getProperty(switchObj, 'error') as String?;
        if (switchError != null && switchError.isNotEmpty) {
          setState(() {
            error = 'Network switch error: $switchError';
          });
          return;
        }
        final promise2 = connectWallet();
        final result2 = await promise2.toDart;
        final obj2 = result2 as JSObject;
        final newCid = js_util.getProperty(obj2, 'chainId') as String;
        setState(() {
          account = js_util.getProperty(obj2, 'account') as String;
          chainId = newCid;
          error = '';
        });
      } else {
        setState(() {
          account = acc;
          chainId = cid;
          error = '';
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  Future<void> sendBeraTokens() async {
    final amount = amountController.text.trim();

    if (amount.isEmpty) {
      setState(() {
        error = "Please provide amount in Bera.";
      });
      return;
    }

    try {
      final promise = sendBera(amount);
      final result = await promise.toDart;
      final obj = result as JSObject;
      final errorVal = js_util.getProperty(obj, 'error') as String?;
      if (errorVal != null && errorVal.isNotEmpty) {
        setState(() {
          error = errorVal;
          txHash = '';
        });
        return;
      }
      setState(() {
        txHash = js_util.getProperty(obj, 'txHash') as String;
        error = '';
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  void disconnect() {
    setState(() {
      account = '';
      chainId = '';
      error = '';
      txHash = '';
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send BERA on Berachain Bepolia',
      home: Scaffold(
        appBar: AppBar(title: const Text('Send BERA')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: connect,
                child: Text(account.isEmpty ? 'Connect Wallet' : 'Connected'),
              ),
              const SizedBox(height: 8),
              if (error.isNotEmpty)
                Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              if (account.isNotEmpty) Text('Account: $account'),
              if (chainId.isNotEmpty) Text('Chain ID: $chainId'),
              const Divider(height: 32),

              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Amount in Bera",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: sendBeraTokens,
                child: const Text('Send BERA'),
              ),
              if (txHash.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Transaction Hash: $txHash'),
                ),
              const Divider(height: 32),

              ElevatedButton(
                onPressed: disconnect,
                child: const Text('Disconnect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
