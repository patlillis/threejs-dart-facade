@JS("Detector")
library DefinitelyTyped.types.three.detector;

import "package:js/js.dart";
import "dart:html" show HtmlElement;

@JS()
external bool get canvas;
@JS()
external set canvas(bool v);
@JS()
external bool get webgl;
@JS()
external set webgl(bool v);
@JS()
external bool get workers;
@JS()
external set workers(bool v);
@JS()
external bool get fileapi;
@JS()
external set fileapi(bool v);
@JS()
external HtmlElement getWebGLErrorMessage();
@JS()
external void addGetWebGLMessage(
    [dynamic /*{id?: string; parent?: HTMLElement}*/ parameters]);
