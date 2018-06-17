import 'dart:html';
import 'dart:math';

import 'package:threejs_facade_test/three.dart';

import 'hilbert.dart';

var mouseX = 0;
var mouseY = 0;

var windowHalfX = window.innerWidth / 2;
var windowHalfY = window.innerHeight / 2;

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;

void main() {
  init();
  animate();
}

void init() {
  camera = new PerspectiveCamera(
      33, window.innerWidth / window.innerHeight, 1, 10000);
  camera.position.z = 1000;

  scene = new Scene();
  renderer = new WebGLRenderer(new WebGLRendererParameters(antialias: true));
  renderer.setPixelRatio(window.devicePixelRatio);
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.append(renderer.domElement);

  var hilbertPoints = hilbert3D(new Vector3(0, 0, 0), 150, 2);

  var geometry1 = new BufferGeometry();
  var geometry2 = new BufferGeometry();
  var geometry3 = new BufferGeometry();
  {
    var subdivisions = 6;

    var vertices = [];
    var colors1 = [];
    var colors2 = [];
    var colors3 = [];

    var point = new Vector3();
    var color = new Color();

    var spline = new CatmullRomCurve3(hilbertPoints);

    for (var i = 0; i < hilbertPoints.length * subdivisions; i++) {
      var t = i / (hilbertPoints.length * subdivisions);
      point = spline.getPoint(t);
      vertices.addAll([point.x, point.y, point.z]);

      color.setHSL(0.6, 1.0, max(0, -point.x / 200) + 0.5);
      colors1.addAll([color.r, color.g, color.b]);

      color.setHSL(0.9, 1.0, max(0, -point.y / 200) + 0.5);
      colors2.addAll([color.r, color.g, color.b]);

      color.setHSL(i / (hilbertPoints.length * subdivisions), 1.0, 0.5);
      colors3.addAll([color.r, color.g, color.b]);
    }

    geometry1.addAttribute('position', new Float32BufferAttribute(vertices, 3));
    geometry2.addAttribute('position', new Float32BufferAttribute(vertices, 3));
    geometry3.addAttribute('position', new Float32BufferAttribute(vertices, 3));

    geometry1.addAttribute('color', new Float32BufferAttribute(colors1, 3));
    geometry2.addAttribute('color', new Float32BufferAttribute(colors2, 3));
    geometry3.addAttribute('color', new Float32BufferAttribute(colors3, 3));
  }

  var geometry4 = new BufferGeometry();
  var geometry5 = new BufferGeometry();
  var geometry6 = new BufferGeometry();
  {
    var vertices = [];
    var colors1 = [];
    var colors2 = [];
    var colors3 = [];

    var color = new Color();

    for (var i = 0; i < hilbertPoints.length; i++) {
      var point = hilbertPoints[i];

      vertices.addAll([point.x, point.y, point.z]);

      color.setHSL(0.6, 1.0, max(0, (200 - point.x) / 400) * 0.5 + 0.5);
      colors1.addAll([color.r, color.g, color.b]);

      color.setHSL(0.3, 1.0, max(0, (200 + point.x) / 400) * 0.5);
      colors2.addAll([color.r, color.g, color.b]);

      color.setHSL(i / hilbertPoints.length, 1.0, 0.5);
      colors3.addAll([color.r, color.g, color.b]);
    }

    geometry4.addAttribute('position', new Float32BufferAttribute(vertices, 3));
    geometry5.addAttribute('position', new Float32BufferAttribute(vertices, 3));
    geometry6.addAttribute('position', new Float32BufferAttribute(vertices, 3));

    geometry4.addAttribute('color', new Float32BufferAttribute(colors1, 3));
    geometry5.addAttribute('color', new Float32BufferAttribute(colors2, 3));
    geometry6.addAttribute('color', new Float32BufferAttribute(colors3, 3));
  }

  // Create lines and add to scene.
  var material = new LineBasicMaterial(new LineBasicMaterialParameters(
      color: 0xffffff, vertexColors: VertexColors));
  var scale = 0.3;
  var d = 225;
  var parameters = [
    [
      material,
      scale * 1.5,
      [-d, -d / 2, 0],
      geometry1
    ],
    [
      material,
      scale * 1.5,
      [0, -d / 2, 0],
      geometry2
    ],
    [
      material,
      scale * 1.5,
      [d, -d / 2, 0],
      geometry3
    ],
    [
      material,
      scale * 1.5,
      [-d, d / 2, 0],
      geometry4
    ],
    [
      material,
      scale * 1.5,
      [0, d / 2, 0],
      geometry5
    ],
    [
      material,
      scale * 1.5,
      [d, d / 2, 0],
      geometry6
    ],
  ];

  for (var i = 0; i < parameters.length; i++) {
    var p = parameters[i];
    var line = new Line(p[3], p[0]);
    line.scale.x = line.scale.y = line.scale.z = p[1];
    line.position.x = p[2][0];
    line.position.y = p[2][1];
    line.position.z = p[2][2];
    scene.add(line);
  }

  document.onMouseMove.listen(onDocumentMouseMove);
  document.onTouchStart.listen(onDocumentTouchStart);
  document.onTouchMove.listen(onDocumentTouchMove);

  window.onResize.listen(onWindowResize);
}

void onWindowResize(_) {
  windowHalfX = window.innerWidth / 2;
  windowHalfY = window.innerHeight / 2;

  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);
}

void onDocumentMouseMove(MouseEvent e) {
  mouseX = e.client.x - windowHalfX;
  mouseY = e.client.y - windowHalfY;
}

void onDocumentTouchStart(TouchEvent e) {
  if (e.touches.length > 1) {
    e.preventDefault();
    mouseX = e.touches.first.page.x - windowHalfX;
    mouseY = e.touches.first.page.y - windowHalfY;
  }
}

void onDocumentTouchMove(TouchEvent e) {
  if (e.touches.length == 1) {
    e.preventDefault();
    mouseX = e.touches.first.page.x - windowHalfX;
    mouseY = e.touches.first.page.y - windowHalfY;
  }
}

void animate([_]) {
  window.requestAnimationFrame(animate);
  render();
}

void render() {
  camera.position.x += (mouseX - camera.position.x) * 0.05;
  camera.position.y += (-mouseY + 200 - camera.position.y) * 0.05;

  camera.lookAt(scene.position);

  var time = new DateTime.now().millisecondsSinceEpoch * 0.0005;
  for (var i = 0; i < scene.children.length; i++) {
    var object = scene.children[i];
    if (object is Line) {
      object.rotation.y = time * (i % 2 == 0 ? 1 : -2);
    }
  }

  renderer.render(scene, camera);
}
