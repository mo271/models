// --- Main Parameters ---

// Dimensions for the cap body.

disc_diameter = 50.7;      // [mm] The overall diameter of the cap.
bottom_disc_height = 3.55; // [mm] The height of the full-disc base.
extra_width = 0.7;


// Prong 2 dimensions (outward-facing, on the round side)

prong2_width = 6.3;
prong2_thickness = 3;
prong2_height = 15;      // The total height of this prong from the base.

// Reinforcement for Prong 2

prong2_connector_thickness = 1; // [mm] Thickness of the base that connects prong 2.


// --- Model ---



// Calculated values

disc_radius = disc_diameter / 2;
cutter_size = disc_diameter * 1.5;

// Use union() to combine all parts into one object.

union() {

    // 1. The main body (bottom disc + top part with cuts)
    cylinder(h = bottom_disc_height, d = disc_diameter, $fn=200);

    // 2. 
    // This creates a solid, flat base for the prong to attach to.
    translate([
        -prong2_width / 2,                          // Match the prong's width and position
        disc_radius - prong2_connector_thickness,   // Sit behind the disc edge
        0                                           // Start from the bottom
    ]) {
        // The block is as wide as the prong and as tall as the main cap body.
        cube([prong2_width, prong2_connector_thickness*6, bottom_disc_height]);
    }
    // also the other side gets the nub
        translate([
        -prong2_width / 2,                          // Match the prong's width and position
        -disc_radius + prong2_connector_thickness - 6*prong2_connector_thickness,   // Sit behind the disc edge
        0                                           // Start from the bottom
    ]) {
        // The block is as wide as the prong and as tall as the main cap body.
        cube([prong2_width, prong2_connector_thickness*6, bottom_disc_height]);
    }
    // 4. Prong 1 (outward-facing, on positive-Y side)
    translate([
        -prong2_width / 2,
        disc_radius + extra_width,
        0
    ]) {
        cube([prong2_width, prong2_thickness, prong2_height]);
    }
    
       // 4. Prong 2 (outward-facing, on positive-Y side)
    translate([
        -prong2_width / 2,
        -disc_radius- prong2_thickness - extra_width,
        0
    ]) {
        cube([prong2_width, prong2_thickness, prong2_height]);
    }

}

