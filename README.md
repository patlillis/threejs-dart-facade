# threejs-dart-facade
Autogenerated Dart facade for the THREE.js JavaScript framework.

This Dart facade was generated using the [js_facade_gen](https://github.com/dart-lang/js_facade_gen) tool, and is based on the [TypeScript definitions](https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/three) maintained in the DefinitelyType project. This Dart facade was generated for version 0.92 of three.js.

## Usage

Add a depency in your pubspec.yaml:

```yaml
dependencies:
    threejs_facade_test: ^0.0.2
```

Install the package using `pub`:

```bash
$> pub get
```

Finally, import and use it in your Dart code:

```dart
import 'package:threejs_facade_test/three.dart';

var camera = new PerspectiveCamera();
```

You must also include the three.js JavaScript itself, since this project only contains a Dart wrapper facade. The easiest way is to use a CDN:

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/92/three.js"></script>
```

Since this Dart facade was generated for version 0.92 of three.js, you should make sure that you include version 0.92 in your application.

## Example

There is a simple example in the [example](example) directory that displays 3D Hilbert Curves, and includes mouse interaction.

To run the example, clone this project, and use `pub` to serve the local files:

```bash
$> git clone https://github.com/patlillis/threejs-dart-facade.git
$> cd threejs-dart-facade
$> pub serve example
```

Then navigate to __localhost:8080__ in your browser.