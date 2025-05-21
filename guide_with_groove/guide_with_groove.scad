// --- Helper Modules for BOTTOM Chamfer Cutters ---

// Module to create a triangular prism for chamfering the bottom positive Y side
// (e.g., edge along Y=main_width, Z=0)
module chamfer_cutter_bottom_positive_y(length, obj_width, chamfer_dim) {
    points = [
        [0, obj_width - chamfer_dim, 0],               // 0: Bottom-Front-Inner (on Z=0 plane)
        [0, obj_width, chamfer_dim],                   // 1: Side-Front-Upper (on Y=obj_width plane, Z=chamfer_dim)
        [0, obj_width, 0],                             // 2: Bottom-Front-Outer (original corner at Y=obj_width, Z=0)
        [length, obj_width - chamfer_dim, 0],          // 3: Bottom-Back-Inner
        [length, obj_width, chamfer_dim],              // 4: Side-Back-Upper
        [length, obj_width, 0]                         // 5: Bottom-Back-Outer
    ];
    faces = [
        [0,1,2],      // Front triangle face
        [3,5,4],      // Back triangle face
        [0,3,4,1],    // Slanted chamfer surface
        [0,2,5,3],    // Bottom surface part (aligns with Z=0)
        [2,1,4,5]     // Side surface part (aligns with Y=obj_width)
    ];
    polyhedron(points=points, faces=faces);
}

// Module to create a triangular prism for chamfering the bottom negative Y side
// (e.g., edge along Y=0, Z=0)
module chamfer_cutter_bottom_negative_y(length, chamfer_dim) {
    points = [
        [0, chamfer_dim, 0],                           // 0: Bottom-Front-Inner (Y=chamfer_dim, Z=0)
        [0, 0, chamfer_dim],                           // 1: Side-Front-Upper (Y=0, Z=chamfer_dim)
        [0, 0, 0],                                     // 2: Bottom-Front-Outer (original corner at Y=0, Z=0)
        [length, chamfer_dim, 0],                      // 3: Bottom-Back-Inner
        [length, 0, chamfer_dim],                      // 4: Side-Back-Upper
        [length, 0, 0]                                 // 5: Bottom-Back-Outer
    ];
    faces = [
        [0,2,1],      // Front triangle face
        [3,4,5],      // Back triangle face
        [0,1,4,3],    // Slanted chamfer surface
        [0,3,5,2],    // Bottom surface part (aligns with Z=0)
        [2,5,4,1]     // Side surface part (aligns with Y=0)
    ];
    polyhedron(points=points, faces=faces);
}

// --- Main Model Code ---

// Dimensions of the main cuboid
main_length = 176; // Corresponds to X-axis
main_width  = 20;  // Corresponds to Y-axis (original full width)
main_height = 10.5; // Corresponds to Z-axis

// Desired base width after chamfering (at Z=0)
new_base_width = 12.4;

// Calculate chamfer dimension for bottom edges
bottom_chamfer_dimension = (main_width - new_base_width) / 2; // (20 - 12.4) / 2 = 3.8

// Dimensions of the main groove
groove_length = main_length;
groove_cut_width = 7.2;
groove_cut_depth = 6;

// Calculations for Main Groove Positioning
offset_y_groove = (main_width - groove_cut_width) / 2;
offset_z_groove = 0;

// Properties for the wider section of the groove
wide_groove_section_actual_length = 4.2;
wide_groove_section_actual_width  = 12.2;

// Calculations for Wider Groove Section Positioning
wide_groove_section_x_start = (main_length / 2) - (wide_groove_section_actual_length / 2);
wide_groove_section_y_offset = (main_width - wide_groove_section_actual_width) / 2;

// Cylinder Properties
cylinder_height_protrusion = 7;
cylinder_base_diameter = 7.5;
cylinder_base_radius = cylinder_base_diameter / 2;
cylinder_top_diameter = 8;
cylinder_top_radius = cylinder_top_diameter / 2;
cylinder_x_offset_from_center = 80;

// Slot Properties
slot_length = 7.4;
slot_width  = 1.0;
slot_depth  = 5.0; // User adapted

// Calculations for Cylinder Positioning
cyl1_x_local = (main_length / 2) - cylinder_x_offset_from_center;
cyl2_x_local = (main_length / 2) + cylinder_x_offset_from_center;
cyl_y_local = main_width / 2;
cyl_base_z_local = main_height; // Cylinders are on the top surface

// Smoothness for rendering
cylinder_smoothness = 100;


// --- Create the Model ---
rotate([-45, 0, 0]){

translate([-main_length/2, -main_width/2, -main_height/2]) { // Global centering
    union() {
        // 1. The main body (cuboid with groove and BOTTOM chamfers)
        difference() {
            // Base cuboid (defines the overall volume before subtractions)
            cube([main_length, main_width, main_height]);

            // --- Subtractions from main body ---
            // Original full-length groove
            translate([0, offset_y_groove, offset_z_groove]) {
                cube([groove_length, groove_cut_width, groove_cut_depth]);
            }

            // Wider section in the middle of the groove
            translate([wide_groove_section_x_start, wide_groove_section_y_offset, offset_z_groove]) {
                cube([wide_groove_section_actual_length, wide_groove_section_actual_width, groove_cut_depth]);
            }

            // Chamfer on the bottom positive Y side
            if (bottom_chamfer_dimension > 0) {
                chamfer_cutter_bottom_positive_y(main_length, main_width, bottom_chamfer_dimension);
            }

            // Chamfer on the bottom negative Y side
            if (bottom_chamfer_dimension > 0) {
                chamfer_cutter_bottom_negative_y(main_length, bottom_chamfer_dimension);
            }
        }

        // --- Additions to the model (cylinders) ---
        // These are added after the main body is formed and are not affected by its internal subtractions.

        // 2. First Tapered Cylinder with Slot
        translate([cyl1_x_local, cyl_y_local, cyl_base_z_local]) {
            difference() {
                cylinder(h = cylinder_height_protrusion, r1 = cylinder_base_radius, r2 = cylinder_top_radius, $fn = cylinder_smoothness);
                translate([0, 0, cylinder_height_protrusion - (slot_depth / 2)]) {
                    cube([slot_length, slot_width, slot_depth], center = true);
                }
            }
        }

        // 3. Second Tapered Cylinder with Slot
        translate([cyl2_x_local, cyl_y_local, cyl_base_z_local]) {
            difference() {
                cylinder(h = cylinder_height_protrusion, r1 = cylinder_base_radius, r2 = cylinder_top_radius, $fn = cylinder_smoothness);
                translate([0, 0, cylinder_height_protrusion - (slot_depth / 2)]) {
                    cube([slot_length, slot_width, slot_depth], center = true);
                }
            }
        }
    }
}
}

// --- End of Code ---