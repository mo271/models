/*
 * Raspberry Pi Camera Rain Hood / Conical Mount
 * 
 * This model creates a camera hood designed to slide over a circular camera lens
 * and connect to a box via a flat mounting base (like a traffic cone).
 *
 * Features:
 * - Flexible slip-on collar with relief slits for a snug, flexible fit over the lens.
 * - Conical hood section to bridge the lens collar and the box mounting base.
 * - Flat base flange for easy gluing/mounting to a box with a circular cutout.
 * - Fully parametric design: all dimensions can be easily adjusted below.
 */

// --- USER CONFIGURABLE PARAMETERS ---

// [Lens Collar (Slide Mechanism)]
// Outer diameter of the camera lens piece to slide over (mm)
lens_outer_diameter = 39.0; 
// Width/height of the slip-on collar section (mm)
collar_height = 8.7; 
// Tolerance added to the lens diameter for fitting (mm)
fit_tolerance = 0.1; 
// Wall thickness of the collar and cone (mm)
wall_thickness = 2.0; 
// Number of flex slits to make the collar flexible
num_slits = 6; 
// Width of each flex slit (mm)
slit_width = 2.0; 

// [Optional Lens Stop Lip]
// Set to true to add an internal lip to prevent the lens from sliding past the collar
add_lens_stop_lip = false; 
// Radial width of the stop lip (mm)
lens_stop_lip_width = 1.5; 
// Height/thickness of the stop lip (mm)
lens_stop_lip_height = 1.0; 

// [Cone Section]
// Height of the conical section between collar and base (mm)
cone_height = 30.0; 
// Inner diameter of the cone at the base/box end (mm)
cone_base_inner_diameter = 55.0; 

// [Base Flange]
// Additional width of the flat base flange for gluing to the box (mm)
flange_width = 12.0; 
// Thickness of the glue base flange (mm)
flange_thickness = 2.0; 

// [Rendering]
// Smoothness of circular geometries
$fn = 120;


// --- MODEL CALCULATION & GEOMETRY ---

collar_inner_diam = lens_outer_diameter + fit_tolerance;
collar_outer_diam = collar_inner_diam + 2 * wall_thickness;
cone_base_outer_diam = cone_base_inner_diameter + 2 * wall_thickness;
flange_outer_diam = cone_base_outer_diam + 2 * flange_width;

module camera_hood() {
    union() {
        difference() {
            // --- OUTER SOLID GEOMETRY ---
            union() {
                // 1. Base Flange (for gluing to the box)
                cylinder(h = flange_thickness, d = flange_outer_diam);
                
                // 2. Conical Section
                translate([0, 0, flange_thickness])
                    cylinder(h = cone_height, d1 = cone_base_outer_diam, d2 = collar_outer_diam);
                
                // 3. Lens Collar Section
                translate([0, 0, flange_thickness + cone_height])
                    cylinder(h = collar_height, d = collar_outer_diam);
            }
            
            // --- INNER HOLLOW CUTOUTS ---
            
            // 1. Inner Conical & Base Cutout (smooth internal taper)
            translate([0, 0, -0.01])
                cylinder(h = flange_thickness + cone_height + 0.02, d1 = cone_base_inner_diameter, d2 = collar_inner_diam);
                
            // 2. Inner Collar Cutout (cylindrical fit for the lens)
            translate([0, 0, flange_thickness + cone_height - 0.01])
                cylinder(h = collar_height + 0.02, d = collar_inner_diam);
                
            // 3. Flex Slits for Collar Flexibility
            if (num_slits > 0) {
                for (i = [0 : num_slits - 1]) {
                    rotate([0, 0, i * (360 / num_slits)]) {
                        // Vertical slit cut
                        translate([-slit_width / 2, 0, flange_thickness + cone_height])
                            cube([slit_width, collar_outer_diam / 2 + 1, collar_height + 1]);
                        
                        // Circular stress-relief hole at the base of the slit
                        translate([0, collar_inner_diam / 2 + wall_thickness / 2, flange_thickness + cone_height])
                            rotate([90, 0, 0])
                            cylinder(h = wall_thickness + 2, d = slit_width, center = true);
                    }
                }
            }
        }
        
        // --- OPTIONAL INTERNAL LENS STOP LIP ---
        if (add_lens_stop_lip) {
            translate([0, 0, flange_thickness + cone_height - lens_stop_lip_height])
                difference() {
                    cylinder(h = lens_stop_lip_height, d = collar_inner_diam + 0.02);
                    translate([0, 0, -0.01])
                        cylinder(h = lens_stop_lip_height + 0.02, d = collar_inner_diam - 2 * lens_stop_lip_width);
                }
        }
    }
}

// Render the final part
camera_hood();
