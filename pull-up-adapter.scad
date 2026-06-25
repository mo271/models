// --- Pivot-Lock Pull-up Grip (V6: Ramped Snap & Refined Hook) ---
// All dimensions in millimeters (mm)

// --- 1. Bar Dimensions ---
bar_width = 25;
bar_height = 10;

// --- 2. Tuning & Fit ---
tolerance = 0.5;      // Printer clearance 

// --- 3. Grip Dimensions ---
grip_length = 110;    // 110mm for larger hands
wall_thickness = 8;   // Thick 8mm walls to handle body weight
lip_thickness = 6;    // Height/Thickness of the bottom hooks

// --- 4. Hook & Snap Dimensions ---
hook_reach = 6.5;     // Reduced slightly from 8mm for easier fitting
small_snap = 2;       // Size of the snap lip on the back

// Calculated inner dimensions
inner_w = bar_width + tolerance;
inner_h = bar_height + tolerance;
outer_w = inner_w + 2 * wall_thickness;

// Extrude the 2D profile into a 3D object
linear_extrude(height = grip_length, center = true)
grip_profile();

module grip_profile() {
    difference() {
        union() {
            // --- Core Body Construction ---
            difference() {
                union() {
                    // Rounded top
                    translate([0, inner_h/2]) 
                        circle(d=outer_w, $fn=100);
                    // Rectangular main body
                    translate([-outer_w/2, -inner_h/2]) 
                        square([outer_w, inner_h]);
                }
                // Wipeout block to guarantee a perfectly flat bottom before adding hooks
                translate([-outer_w, -inner_h/2 - outer_w]) 
                    square([outer_w*2, outer_w]);
            }
            
            // --- Left Lip (Small Snap with Lead-in Ramp) ---
            // The diagonal angle physically guides the metal bar inward to spread the plastic
            polygon(points=[
                [-outer_w/2, -inner_h/2],                           // Top Left
                [-inner_w/2 + small_snap, -inner_h/2],              // Top Right (Snap catch)
                [-inner_w/2, -inner_h/2 - lip_thickness],           // Bottom Right (Ramp start)
                [-outer_w/2, -inner_h/2 - lip_thickness]            // Bottom Left
            ]);
            
            // --- Right Lip (Large Front Hook) ---
            polygon(points=[
                [inner_w/2 - hook_reach, -inner_h/2],               // Top Left (Hook tip)
                [outer_w/2, -inner_h/2],                            // Top Right
                [outer_w/2, -inner_h/2 - lip_thickness],            // Bottom Right
                [inner_w/2 - hook_reach, -inner_h/2 - lip_thickness]// Bottom Left
            ]);
        }

        // --- Cutout for the 25x10 metal bar ---
        // Extends slightly upwards (+1) to ensure OpenSCAD cuts it cleanly
        translate([-inner_w/2, -inner_h/2])
            square([inner_w, inner_h + 1]);
    }
}