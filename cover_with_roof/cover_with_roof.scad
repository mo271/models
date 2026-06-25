// --- User Inputs ---
width = 72; // Total width of the base rectangle
height = 48; // Total height of the base rectangle
depth = 20; // How far the shape extends downwards (z<0)

//width = 65; // Total width of the base rectangle
//height = 45; // Total height of the base rectangle
//depth = 20; // How far the shape extends downwards (z<0)


// The two points for the roof, based on a bottom-left origin
p1_orig = [30, 16, 12];
p2_orig = [30, 39, 12];

//p1_orig = [20, 24, 12];
//p2_orig = [20, 42, 12];

// --- Model Generation (No need to edit below) ---

// 1. NORMALIZE COORDINATES
// Calculate the offset to move the center of the base to the origin [0,0,0]
offset = [width / 2, height / 2, 0];

// Define the 4 corners of the base at z=0, now centered
b1 = [-width / 2, -height / 2, 0]; // Bottom-left
b2 = [ width / 2, -height / 2, 0]; // Bottom-right
b3 = [ width / 2,  height / 2, 0]; // Top-right
b4 = [-width / 2,  height / 2, 0]; // Top-left

// Define the 4 corners of the bottom at z=-depth
d1 = [b1.x, b1.y, -depth];
d2 = [b2.x, b2.y, -depth];
d3 = [b3.x, b3.y, -depth];
d4 = [b4.x, b4.y, -depth];

// Normalize the user-provided roof points
p1 = p1_orig - offset;
p2 = p2_orig - offset;

// 2. CREATE THE HULLS
// The final object is the difference between the two hulls
difference() {
    // A. Outer Hull
    hull() {
        // Use tiny spheres to mark the vertices for the hull
        for (pt = [b1, b2, b3, b4, d1, d2, d3, d4, p1, p2]) {
            translate(pt) sphere(r = 0.01);
        }
    }

    // B. Inner Hull
    hull() {
        // Scale down the top and roof points by 5%
        scale_factor = 0.95;
        for (pt = [b1, b2, b3, b4, p1, p2]) {
            translate(pt * scale_factor) sphere(r = 0.01);
        }

        // Extend the bottom points downwards to ensure the cut creates an opening
        for (pt = [d1, d2, d3, d4]) {
            translate(pt * scale_factor - [0, 0, 100]) sphere(r = 0.01);
        }
    }
}