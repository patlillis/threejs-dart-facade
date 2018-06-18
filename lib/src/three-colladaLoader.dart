@JS("THREE")
library threejs_facade_test.three_colladaLoader;

import "package:js/js.dart";
import "three-core.dart" show Scene;
import "dart:html" show ProgressEvent, ErrorEvent;

@anonymous
@JS()
abstract class ColladaLoaderReturnType {}

@JS()
class ColladaModel {
  // @Ignore
  ColladaModel.fakeConstructor$();
  external List<dynamic> get animations;
  external set animations(List<dynamic> v);
  external dynamic get kinematics;
  external set kinematics(dynamic v);
  external Scene get scene;
  external set scene(Scene v);
  external dynamic get JS$library;
  external set JS$library(dynamic v);
}

@JS()
class ColladaLoader {
  // @Ignore
  ColladaLoader.fakeConstructor$();
  external factory ColladaLoader();
  external void load(String url, void onLoad(ColladaModel model),
      [void onProgress(ProgressEvent request), void onError(ErrorEvent event)]);
  external void setCrossOrigin(dynamic value);
  external ColladaModel parse(String text);
}
