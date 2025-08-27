// OpenSCAD model of the Noperthedron
// Based on the paper "A convex polyhedron without Rupert's property"
// arXiv:2508.18475v1 [math.MG] by Jakob Steininger and Sergey Yurkevich.
//
// This model uses the corrected generator points for the Noperthedron. The
// coordinates are from 
//https://github.com/Jakob256/Rupert/blob/632e0fa5084a31f2a8c02a941208469b88b4f460/src/noperthedron.py#L5-L7

//=====================================================================
//          PARAMETERS
//=====================================================================
// Total size (diameter) of the model in millimeters.
// The default radius of the Noperthedron is 1 unit.
// A scale_factor of 50 would make the model's diameter 100 mm.
scale_factor = 50;

//=====================================================================
//          MODEL DEFINITION
//=====================================================================

// Custom function to rotate a vector 'v' around the Z-axis by 'angle' degrees.
// This is a compatible method that works in older versions of OpenSCAD.
function rotate_z(v, angle) = [
    v.x * cos(angle) - v.y * sin(angle),
    v.x * sin(angle) + v.y * cos(angle),
    v.z
];

// Corrected generator points C1, C2, C3 for the Noperthedron.
C1 = [152024884/259375205, 0, 210152163/259375205];
C2 = [6632738028/1e10, 6106948881/1e10, 3980949609/1e10];
C3 = [8193990033/1e10, 5298215096/1e10, 1230614493/1e10];

// Rescale the generator points for the final model size.
scaled_C1 = C1 * scale_factor;
scaled_C2 = C2 * scale_factor;
scaled_C3 = C3 * scale_factor;

eps = 0.001;

// The hull() function computes the convex hull of all child objects.
// We create a tiny, negligible sphere at each of the 90 vertex locations
// to serve as a point for the hull() operation.
hull() {
    // The group C_30 applies 15 rotations around the z-axis,
    // and for each resulting point P, it includes both P and -P.
    for (k = [0 : 14]) {
        // Calculate rotation angle in degrees for each step
        angle = k * (360 / 15);
        
        // --- Apply rotation to generate a set of vertices ---
        
        // Rotated version of C1
        rC1 = rotate_z(scaled_C1, angle);
        // Rotated version of C2
        rC2 = rotate_z(scaled_C2, angle);
        // Rotated version of C3
        rC3 = rotate_z(scaled_C3, angle);

        // --- Create placeholders for the hull() operation ---
        // For each rotated point, we add it and its point-symmetric partner.
        
        // Point from C1 orbit
        translate(rC1) sphere(r = eps);
        translate(-rC1) sphere(r = eps);

        // Point from C2 orbit
        translate(rC2) sphere(r = eps);
        translate(-rC2) sphere(r = eps);

        // Point from C3 orbit
        translate(rC3) sphere(r = eps);
        translate(-rC3) sphere(r = eps);
    }
}