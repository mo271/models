// --- Sliding Dovetail Clamshell Grip (V14: Self-Locking Angle) ---
// All dimensions in millimeters (mm)

// --- Which part to render? ---
// Options: "assembled", "u_piece", "t_piece"
render_part = "u_piece"; 

// --- 1. Core Dimensions ---
bar_width = 25;
bar_height = 8;
grip_length = 107;
outer_diameter = 36;    

// --- 2. Fit & Clearances ---
bar_tol = 0.5;      
slide_tol = 0.15;   // Perfect middle ground: glides smoothly but doesn't rattle

// Calculated inner channel for the metal bar
inner_w = bar_width + bar_tol;
inner_h = bar_height + bar_tol;
hw = inner_w / 2;

// --- 3. Perfectly Centered Y-Axis Layout ---
bar_top = 7.0;                  
bar_bottom = bar_top - inner_h; 

// --- 4. Dovetail (Angled T-Track) Dimensions ---
wing_top = bar_bottom;          
wing_thickness = 4.5;           // Increased to 4.5mm for massive shear strength
wing_bottom = wing_top - wing_thickness; 

// The Dovetail Angle: Top is wide (3mm), Bottom is narrow (1mm)
wing_depth_top = 3.0;           
wing_depth_bottom = 1.0;        
hgw_top = hw + wing_depth_top;  
hgw_bottom = hw + wing_depth_bottom;

// --- 5. Snap-Fit Detent Settings ---
wing_y_center = (wing_top + wing_bottom) / 2; 
hgw_mid = (hgw_top + hgw_bottom) / 2; // Finds the exact middle of the angled slope
bump_r = 0.6;       
hole_r = 0.7;       

// --- Rendering Logic ---
if (render_part == "assembled") {
    color("dodgerblue") u_piece_3d();
    color("darkorange") translate([0, 0, grip_length/2 + 25]) t_piece_3d();
} else if (render_part == "u_piece") {
    u_piece_3d();
} else if (render_part == "t_piece") {
    t_piece_3d();
}

// --- Modules ---
module u_piece_3d() {
    difference() {
        linear_extrude(height=grip_length, center=true)
        difference() {
            circle(d=outer_diameter, $fn=100);
            
            // The newly angled dovetail cutout
            polygon(points=[
                [-hw, bar_top],                
                [hw, bar_top],                 
                [hw, wing_top],                
                [hgw_top, wing_top],           // Out to WIDE upper wing
                [hgw_bottom, wing_bottom],     // Angled down to NARROW lower wing
                [hw, wing_bottom],             
                [hw, -outer_diameter],         
                [-hw, -outer_diameter],        
                [-hw, wing_bottom],            
                [-hgw_bottom, wing_bottom],    // Angled up to NARROW lower left wing
                [-hgw_top, wing_top],          // Angled up to WIDE upper left wing
                [-hw, wing_top]                
            ]);
        }
        
        // The receiving oval divots on the angled face
        translate([hgw_mid, wing_y_center, 0]) scale([1, 1, 4]) sphere(r=hole_r, $fn=30);
        translate([-hgw_mid, wing_y_center, 0]) scale([1, 1, 4]) sphere(r=hole_r, $fn=30);
    }
}

module t_piece_3d() {
    hw_t = hw - slide_tol;
    hgw_top_t = hgw_top - slide_tol;
    hgw_bottom_t = hgw_bottom - slide_tol;
    wt_t = wing_top - slide_tol;
    wb_t = wing_bottom + slide_tol;
    hgw_mid_t = hgw_mid - slide_tol;
    
    union() {
        linear_extrude(height=grip_length, center=true)
        intersection() {
            circle(d=outer_diameter, $fn=100);
            
            // The solid Dovetail T-piece
            polygon(points=[
                [-hgw_top_t, wt_t],                
                [hgw_top_t, wt_t],                 
                [hgw_bottom_t, wb_t],                 
                [hw_t, wb_t],                  
                [hw_t, -outer_diameter],       
                [-hw_t, -outer_diameter],      
                [-hw_t, wb_t],                 
                [-hgw_bottom_t, wb_t]                 
            ]);
        }
        
        // The locking bumps added to the angled dovetail faces
        translate([hgw_mid_t, wing_y_center, 0]) scale([1, 1, 4]) sphere(r=bump_r, $fn=30);
        translate([-hgw_mid_t, wing_y_center, 0]) scale([1, 1, 4]) sphere(r=bump_r, $fn=30);
    }
}