// --- Sliding T-Track Clamshell Grip (V11: 35mm Ultra-Ergo) ---
// All dimensions in millimeters (mm)

// --- Which part to render? ---
// Options: "assembled", "u_piece", "t_piece"
render_part = "u_piece"; 

// --- 1. Core Dimensions ---
bar_width = 25;
bar_height = 10;
grip_length = 110;
// grip_length = 35;
outer_diameter = 36;    // Shrunk to the ultimate 35mm ergonomic size

// --- 2. Fit & Clearances ---
bar_tol = 0.5;      // Clearance for the metal bar
slide_tol = 0.2;    // Clearance for the sliding T-piece (snug fit)

// Calculated inner channel for the metal bar
inner_w = bar_width + bar_tol;
inner_h = bar_height + bar_tol;
hw = inner_w / 2;

// --- 3. Perfectly Centered Y-Axis Layout ---
// At 35mm, we MUST center the internal void perfectly to save wall thickness
// Total void height is 14mm (10.5 bar + 3.5 wing). Centered at Y=0:
bar_top = 7.0;                  
bar_bottom = bar_top - inner_h; // Exactly -3.5

// --- 4. Micro T-Track Dimensions ---
wing_top = bar_bottom;          // Sits completely flush with the bottom of the bar
wing_thickness = 3.5;           // Thinner 3.5mm wings to save bottom wall thickness
wing_bottom = wing_top - wing_thickness; // Exactly -7.0
wing_depth = 1.5;               // Shallow 1.5mm wings to save side wall thickness
hgw = hw + wing_depth;          // Outer width of the wings from center

// --- Rendering Logic ---
if (render_part == "assembled") {
    color("dodgerblue") u_piece_3d();
    // Slides the T-piece halfway out to show the mechanism
    color("darkorange") translate([0, 0, grip_length/2 + 15]) t_piece_3d();
} else if (render_part == "u_piece") {
    u_piece_3d();
} else if (render_part == "t_piece") {
    t_piece_3d();
}

// --- Modules ---
module u_piece_3d() {
    linear_extrude(height=grip_length, center=true)
    difference() {
        circle(d=outer_diameter, $fn=100);
        
        // The perfectly centered cutout
        polygon(points=[
            [-hw, bar_top],                // Top left of bar cavity
            [hw, bar_top],                 // Top right of bar cavity
            [hw, wing_top],                // Down right side of metal bar
            [hgw, wing_top],               // Out to right wing top
            [hgw, wing_bottom],            // Down right wing
            [hw, wing_bottom],             // In to lower right stem
            [hw, -outer_diameter],         // Down to bottom exit
            [-hw, -outer_diameter],        // Across bottom exit
            [-hw, wing_bottom],            // Up to lower left stem
            [-hgw, wing_bottom],           // Out to left wing bottom
            [-hgw, wing_top],              // Up left wing
            [-hw, wing_top]                // In to left side of metal bar
        ]);
    }
}

module t_piece_3d() {
    // Tolerances applied inward for a smooth sliding fit
    hw_t = hw - slide_tol;
    hgw_t = hgw - slide_tol;
    wt_t = wing_top - slide_tol;
    wb_t = wing_bottom + slide_tol;
    
    linear_extrude(height=grip_length, center=true)
    intersection() {
        // Ensures the bottom perfectly matches the curved 35mm grip
        circle(d=outer_diameter, $fn=100);
        
        // The solid Micro T-piece
        polygon(points=[
            [-hgw_t, wt_t],                // Top left of the wide flat T-top
            [hgw_t, wt_t],                 // Top right of the wide flat T-top
            [hgw_t, wb_t],                 // Down right wing
            [hw_t, wb_t],                  // In to right stem
            [hw_t, -outer_diameter],       // Down right stem
            [-hw_t, -outer_diameter],      // Across bottom
            [-hw_t, wb_t],                 // Up left stem
            [-hgw_t, wb_t]                 // Out to left wing bottom
        ]);
    }
}