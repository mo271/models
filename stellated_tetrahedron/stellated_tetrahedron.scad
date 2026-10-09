// OpenSCAD model of the 11/20 stellated tetrahedron, a "Nopert":
// a convex polyhedron that does NOT have the Rupert property, i.e. it does
// not fit through a hole in a copy of itself.
//
// The polyhedron was suggested by Tony Zeng as a candidate for the simplest
// possible Nopert in
//   Tony Zeng, "A stellated tetrahedron that is probably not Rupert",
//   arXiv:2604.26531 (April 2026).
//
// That it is indeed not Rupert was then formally proved in Lean 4 / Mathlib
// by David Renshaw (dwrensha):
//   https://github.com/dwrensha/StellatedTetrahedron
// The main formal assertion there is `¬ IsRupert exactVerts`, with the
// vertices defined in Noperts/Stellated/Vertices.lean (scaled by 1/2 so that
// they lie in the unit ball). That project grew out of the Noperthedron
// formalization https://github.com/jcreedcmu/Noperthedron, see also the
// Noperthedron model in ../noperthedron.
//
// Vertices (unscaled, as in Zeng's paper):
//   p_i = (1,1,1), (1,-1,-1), (-1,1,-1), (-1,-1,1)   (a regular tetrahedron)
//   q_i = -a * p_i                                   with a = 11/20
// Each q_i sits above the face of the tetrahedron opposite p_i, so the convex
// hull is the tetrahedron with a low pyramid erected on each face:
// 8 vertices, 18 edges, 12 triangular faces.
//
// For comparison: with a = 3/5 one gets the triakis tetrahedron, which has
// long been known to be Rupert (it fits through itself).

//=====================================================================
//          PARAMETERS
//=====================================================================
// Stellation parameter a. 11/20 is the Nopert; 3/5 gives the (Rupert)
// triakis tetrahedron.
a = 11/20;

// Scale factor in mm per unit. The tetrahedron edge is 2*sqrt(2) units, so
// scale_factor = 30 gives an edge of about 85 mm and a circumradius
// (distance from center to a p_i) of about 52 mm.
scale_factor = 30;

// Lay the solid on one of its faces for printing (all 12 faces are equivalent
// by symmetry). The rotation is built from the exact face normal and an edge
// direction, not from rounded angles, so the three base vertices end up on
// z = 0 to floating-point precision. Set to false for the paper's coordinates.
lay_flat = true;

//=====================================================================
//          MODEL DEFINITION
//=====================================================================
p = [[1, 1, 1], [1, -1, -1], [-1, 1, -1], [-1, -1, 1]];
q = [for (v = p) -a * v];

verts = concat(p, q) * scale_factor;   // indices 0..3 = p_i, 4..7 = q_i

// For every i, the face of the tetrahedron opposite p_i is spanned by the
// other three p_j; it gets replaced by three triangles meeting in q_i.
// The vertex order below gives outward-facing (clockwise from outside)
// triangles as OpenSCAD expects.
others = [[1, 2, 3], [0, 3, 2], [0, 1, 3], [0, 2, 1]];
faces = [
    for (i = [0 : 3])
        for (k = [0 : 2])
            [4 + i, others[i][k], others[i][(k + 1) % 3]]
];

// --- lay-flat rotation ---------------------------------------------------
// Base face: the triangle (q_0, p_1, p_2), i.e. faces[0]. Its outward normal
// is proportional to -(1-a, 1-a, 2a); the edge p_1 -> p_2 is along (-1, 1, 0).
// We build an orthonormal frame (e1, e2, e3) with e3 = -outward normal, so
// the face normal maps to -z (face down), and e2 = e3 x e1 makes it a proper
// rotation (determinant +1, face orientation preserved).
function unit(v) = v / norm(v);
e3 = unit([1 - a, 1 - a, 2 * a]);
e1 = unit([1, -1, 0]);
e2 = cross(e3, e1);
function rot(v) = [e1 * v, e2 * v, e3 * v];

base = [4, 1, 2];
// Rotate, then shift so the base face lies on z = 0 and its centroid is at
// the origin (the shift is the rotated centroid of the base triangle; all
// three base vertices share the same z by construction).
centroid = (rot(verts[base[0]]) + rot(verts[base[1]]) + rot(verts[base[2]])) / 3;
// The subtraction leaves the base vertices at |z| ~ 1e-15 (floating-point
// noise); snap that to an exact 0 so the STL has a perfectly flat bottom.
verts_flat = [for (v = verts) let(w = rot(v) - centroid)
    [w.x, w.y, abs(w.z) < 1e-9 ? 0 : w.z]];

polyhedron(points = lay_flat ? verts_flat : verts, faces = faces, convexity = 2);
