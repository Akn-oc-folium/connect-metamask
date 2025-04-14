@JS('berachain')
library berachain;

import 'dart:js_interop';

@JS()
external JSPromise connectWallet();

@JS()
external JSPromise switchToBerachainBepolia();

@JS()
external JSPromise sendBera(String amount);
