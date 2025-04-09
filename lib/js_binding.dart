@JS('berachain')
library berachain;

import 'dart:js_interop';

@JS()
external JSAny connectWallet();

@JS()
external JSAny getBlockNumber();
