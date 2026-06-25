// --- Horizontal Sliding T-Track Clamshell Grip ---
// All dimensions in millimeters (mm)

// --- Which part to render? ---
// Options: "assembled", "u_piece", "t_piece"
render_part = "assembled"; 

// --- 1. Core Dimensions ---
bar_width = 25;   // The flat edge (horizontal)
bar_height = 10;  // The short edge (vertical/front)
grip_length = 110;
//grip_length = 25;
outer_diameter = 46;

// --- 2. Fit & Clearances ---
bar_tol = 0.5;      // Clearance for the metal bar
slide_tol = 0.25;   // Clearance for the sliding T-piece (adjust if too tight/loose)

// Calculated inner channel for the metal bar
inner_w = bar_width + bar_tol;
inner_h = bar_height + bar_tol;
bw = inner_w / 2;
bh = inner_h / 2;

// --- 3. Horizontal T-Track Dimensions ---
// The dovetail grooves now expand vertically on the front (short) edge
wing_top = bh + 5.0;         // Dovetail wing expands 5mm UP
wing_bottom = -bh - 5.0;     // Dovetail wing expands 5mm DOWN
wing_outer_x = bw + 4.5;     // Wing extends 4.5mm outward

// --- Rendering Logic ---
if (render_part == "assembled") {
    color("dodgerblue") u_piece_3d();
    // Slides the T-piece halfway out along the Z-axis to show the lock
    color("darkorange") translate([0, 0, grip_length/2 + 10]) t_piece_3d();
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
        
        // The perfectly symmetric horizontal cutout for the bar AND the T-track
        polygon(points=[
            [-bw, bh],                  // Top-left of the metal bar cavity
            [bw, bh],                   // Top-right of the metal bar (starts T-track)
            [bw, wing_top],             // Up into top wing
            [wing_outer_x, wing_top],   // Right along top wing
            [wing_outer_x, bh],         // Down to the neck opening
            [outer_diameter, bh],       // Right to exterior (blows out the side)
            [outer_diameter, -bh],      // Down across the front neck opening
            [wing_outer_x, -bh],        // Left along bottom neck
            [wing_outer_x, wing_bottom],// Down into bottom wing
            [bw, wing_bottom],          // Left along bottom wing
            [bw, -bh],                  // Up to bottom-right of metal bar
            [-bw, -bh]                  // Left to bottom-left of metal bar
        ]);
    }
}

module t_piece_3d() {
    // Tolerances applied inward for a smooth sliding fit
    bw_t = bw + slide_tol;            // Left inner face
    wt_t = wing_top - slide_tol;      // Top of top wing
    wb_t = wing_bottom + slide_tol;   // Bottom of bottom wing
    wox_t = wing_outer_x - slide_tol; // Right edge of wings
    nt_t = bh - slide_tol;            // Top of front neck
    nb_t = -bh + slide_tol;           // Bottom of front neck
    
    linear_extrude(height=grip_length, center=true)
    intersection() {
        circle(d=outer_diameter, $fn=100);
        
        // The solid, perfectly symmetric horizontal T-piece
        polygon(points=[
            [bw_t, nt_t],
            [bw_t, wt_t],
            [wox_t, wt_t],
            [wox_t, nt_t],
            [outer_diameter, nt_t],
            [outer_diameter, nb_t],
            [wox_t, nb_t],
            [wox_t, wb_t],
            [bw_t, wb_t],
            [bw_t, nb_t]
        ]);
    }
}