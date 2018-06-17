import 'package:threejs_facade_test/three.dart';

/// Generates 3D Coordinates for a Hilbert Curve in a very fast way.
///
/// @author Dylan Grafmyre
///
/// Based on work by:
/// @author Thomas Diewald
/// @link http://www.openprocessing.org/visuals/?visualID=15599
///
/// Based on `examples/canvas_lines_colors.html`:
/// @author OpenShift guest
/// @link https://github.com/mrdoob/three.js/blob/8413a860aa95ed29c79cbb7f857c97d7880d260f/examples/canvas_lines_colors.html
List<Vector3> hilbert3D(
    [Vector3 center,
    num size = 10,
    int iterations = 1,
    num v0 = 0,
    num v1 = 1,
    num v2 = 2,
    num v3 = 3,
    num v4 = 4,
    num v5 = 5,
    num v6 = 6,
    num v7 = 7]) {
  center ??= new Vector3(0, 0, 0);
  var half = size / 2;

  var vec_s = [
    new Vector3(center.x - half, center.y + half, center.z - half),
    new Vector3(center.x - half, center.y + half, center.z + half),
    new Vector3(center.x - half, center.y - half, center.z + half),
    new Vector3(center.x - half, center.y - half, center.z - half),
    new Vector3(center.x + half, center.y - half, center.z - half),
    new Vector3(center.x + half, center.y - half, center.z + half),
    new Vector3(center.x + half, center.y + half, center.z + half),
    new Vector3(center.x + half, center.y + half, center.z - half)
  ];

  var vec = [
    vec_s[v0],
    vec_s[v1],
    vec_s[v2],
    vec_s[v3],
    vec_s[v4],
    vec_s[v5],
    vec_s[v6],
    vec_s[v7]
  ];

  // Recurse iterations.
  if (--iterations >= 0) {
    var tmp = <Vector3>[];

    tmp.addAll(
        hilbert3D(vec[0], half, iterations, v0, v3, v4, v7, v6, v5, v2, v1));
    tmp.addAll(
        hilbert3D(vec[1], half, iterations, v0, v7, v6, v1, v2, v5, v4, v3));
    tmp.addAll(
        hilbert3D(vec[2], half, iterations, v0, v7, v6, v1, v2, v5, v4, v3));
    tmp.addAll(
        hilbert3D(vec[3], half, iterations, v2, v3, v0, v1, v6, v7, v4, v5));
    tmp.addAll(
        hilbert3D(vec[4], half, iterations, v2, v3, v0, v1, v6, v7, v4, v5));
    tmp.addAll(
        hilbert3D(vec[5], half, iterations, v4, v3, v2, v5, v6, v1, v0, v7));
    tmp.addAll(
        hilbert3D(vec[6], half, iterations, v4, v3, v2, v5, v6, v1, v0, v7));
    tmp.addAll(
        hilbert3D(vec[7], half, iterations, v6, v5, v2, v1, v0, v3, v4, v7));

    // Return recursive call.
    return tmp;
  }

  // Return complete Hilbert Curve.
  return vec;
}
