@JS("THREE")
library threejs_facade_test.three_copyshader;

import "package:js/js.dart";
import "three-core.dart" show Shader;

@JS()
external Shader get CopyShader;
@JS()
external set CopyShader(Shader v);
