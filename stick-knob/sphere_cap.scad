// ----------------------------------------
// 3D Model: Spherical Cap for Cylindrical Stick
// ----------------------------------------
// Description: Creates a cap with a spherical outer shape and
//              a cylindrical + cone inner cavity, closed at one end.

// --- User Defined Parameters ---

// Diameter of the stick the cap should fit onto (in mm)
stick_diameter = 27.5;

// Outer diameter of the SPHERE (in mm)
sphere_diameter = 44;

// How far the cap should cover the stick length (inner cavity depth) (in mm)
cap_inner_depth = 26;


// The height of the cone placed on top of the cylindrical inner cavity
cone_height = 8;

// Thickness of the material at the very top (closed end) of the inner cavity,
// measured inwards from the sphere's surface along the Z-axis. (in mm)
top_thickness = 10;


// --- Calculated Parameters --- (Do not change these directly)
inner_radius = (stick_diameter) / 2;
sphere_radius = sphere_diameter / 2;

// Calculate the Z-level for the flat base opening.
// This positions the top of the inner cavity 'top_thickness' below the sphere's top Z point.
cavity_base_z = sphere_radius - top_thickness - cap_inner_depth;

// Safety check: Ensure cavity doesn't extend beyond the sphere's bottom opening
if (inner_radius > sqrt(pow(sphere_radius, 2) - pow(cavity_base_z, 2))) {
    echo("Warning: Inner cavity diameter might be too large for the sphere cut at this depth!");
    // This calculates the sphere's radius at the 'cavity_base_z' level.
}


// --- Model Resolution ---
$fn = 200;


// We use difference() to subtract the cavity from the main shape.
difference() {

    // 1. Create the main outer shape: A sphere cut flat at the bottom.
    // We achieve this by intersecting a sphere with a large box/shape
    // that occupies the space *above* the desired flat base level (cavity_base_z).
    intersection() {
        // The full sphere, centered at origin
        sphere(r = sphere_radius);

        // A large box positioned to keep everything at or above cavity_base_z
        large_dim = sphere_diameter * 4; // Make sure box is wider than sphere
        // Box starts at cavity_base_z and goes upwards well beyond the sphere top
        box_height = sphere_radius - cavity_base_z ; // Height from base to sphere top + buffer
        translate([ -large_dim/2, -large_dim/2, cavity_base_z]) // Position bottom-corner
            cube([large_dim, large_dim, box_height]);
    }

    // 2. Create the inner cylindrical +cone cavity to be subtracted.
    // It starts at the flat base (cavity_base_z) and goes up by cap_inner_depth.
    // We make it slightly taller (+1mm) to ensure a clean boolean operation.
    union() {
        translate([0, 0, cavity_base_z]) {
            cylinder(h = cap_inner_depth + 1, r = inner_radius, center = false);
        }

        translate([0, 0, cavity_base_z + (cap_inner_depth) + 1]) {
            cylinder(h = cone_height, r1 = inner_radius, r2 = 0, center = false);
        }
    }

}
