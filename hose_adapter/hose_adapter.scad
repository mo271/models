// Adapter for Table Saw to Vacuum Cleaner 

// From DSP600 Makita plunge cut circular saw to Makita vaccum DVC750LZX3 

// --- Customizable Parameters ---

adapter_inner_diameter_saw = 37.16;    // Adapter's inner diameter to fit OVER the 43mm saw port
saw_side_adapter_length = 22;   // Length of the adapter section for the saw port

adapter_inner_diameter_vacuum = 45.1; // Adapter's inner diameter to fit OVER the 44.4mm vacuum port
vacuum_side_adapter_length = 35;  // Length of the adapter section for the vacuum port

// Adapter Construction
// This is the wall thickness for the section with the LARGEST inner diameter (the vacuum side).
// The overall outer diameter of the adapter will be determined by this value and the vacuum side's inner diameter.
min_wall_thickness = 2; // mm 

smoothness = 200; 

// --- Calculations (do not change these) ---
// The overall outer diameter is determined by the vacuum side (larger ID) and the minimum wall thickness.
// This outer diameter will be constant for the entire adapter.
adapter_outer_diameter = adapter_inner_diameter_vacuum + (2 * min_wall_thickness);

// Total length of the adapter
adapter_total_length = saw_side_adapter_length + vacuum_side_adapter_length;

// A small value to ensure boolean subtractions work correctly (prevents z-fighting)
epsilon = 0.025; 

// --- Module to create the stepped adapter ---
module stepped_adapter_no_overhang() {
    difference() {
        // 1. The Main Outer Body of the Adapter
        // This is a single cylinder with a constant outer diameter.
        cylinder(h = adapter_total_length, d = adapter_outer_diameter, center = false, $fn = smoothness);

        // 2. Inner Hollow for the Table Saw Side (Narrower ID - at the bottom for printing)
        // This cylinder defines the inner void for the table saw end.
        // It starts at the base (z=0) and extends for the saw_side_adapter_length.
        cylinder(h = saw_side_adapter_length + epsilon, d = adapter_inner_diameter_saw, center = false, $fn = smoothness);

        // 3. Inner Hollow for the Vacuum Cleaner Side (Wider ID - on top)
        // This cylinder defines the inner void for the vacuum cleaner end.
        // It is translated to sit on top of the saw side's hollow.
        // Since adapter_inner_diameter_vacuum > adapter_inner_diameter_saw, this creates an outward step (no overhang).
        translate([0, 0, saw_side_adapter_length]) {
            cylinder(h = vacuum_side_adapter_length + epsilon, d = adapter_inner_diameter_vacuum, center = false, $fn = smoothness);
        }
    }
}

// --- Render the adapter ---
stepped_adapter_no_overhang();