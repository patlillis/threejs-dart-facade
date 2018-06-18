@JS("THREE")
library threejs_facade_test.three_smaapass;

import "package:js/js.dart";

@JS()
class SMAAPass {
  // @Ignore
  SMAAPass.fakeConstructor$();
  external factory SMAAPass(num width, num height);
  external bool get renderToScreen;
  external set renderToScreen(bool v);
}
