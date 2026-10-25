/*
  Swarm Robot — fast, support-free visual prop
  Units: millimetres.  Export as STL (F6, then File > Export > Export as STL).
  Designed to print flat-side down without supports on a Bambu A1.
*/

$fn = 32;                 // Smooth enough, keeps STL compact

// Overall chassis: 30 x 24 x 11 mm (sensor reaches 13.5 mm).
// The taller straight-sided body reads as a boxy rover while remaining support-free.
body_length = 30;
body_width  = 24;
corner_r    = 4;
base_h      = 7;
top_h       = 4;

module rounded_rect_2d(length, width, radius) {
    hull()
        for (x = [-length/2 + radius, length/2 - radius])
            for (y = [-width/2 + radius, width/2 - radius])
                translate([x, y]) circle(r = radius);
}

// Wheel-shaped plan-view pads: no horizontal overhangs, so no support needed.
module wheel_pad(side, x_pos) {
    translate([x_pos, side * (body_width/2 - 1.2), 0])
        hull() {
            translate([-2.8, 0]) cylinder(h = base_h, r = 3.2);
            translate([ 2.8, 0]) cylinder(h = base_h, r = 3.2);
        }
}

module chassis() {
    union() {
        // Low, wider silhouette includes the two side wheel bumps.
        linear_extrude(height = base_h)
            rounded_rect_2d(body_length, body_width, corner_r);
        wheel_pad( 1, -6.5);
        wheel_pad(-1, -6.5);
        wheel_pad( 1,  6.5);
        wheel_pad(-1,  6.5);

        // Slight step gives the wheel pads a clearly visible separate look.
        translate([0, 0, base_h])
            linear_extrude(height = top_h)
                rounded_rect_2d(body_length - 1.6, body_width - 1.6, corner_r - 0.5);
    }
}

module direction_arrow() {
    // Embossed arrow points toward the front (+X).  Contrasting filament works well.
    translate([2.0, 0, base_h + top_h])
        linear_extrude(height = 0.45)
            polygon(points = [
                [-7.0, -1.35], [ 1.0, -1.35], [ 1.0, -2.45],
                [ 5.2,  0.00], [ 1.0,  2.45], [ 1.0,  1.35],
                [-7.0,  1.35]
            ]);
}

module sensor() {
    // Tapered 2.5 mm beacon at the front; 45°-safe profile for FDM printing.
    translate([10.2, 0, base_h + top_h])
        cylinder(h = 2.5, r1 = 2.1, r2 = 0.7);
}

module swarm_robot() {
    union() {
        chassis();
        direction_arrow();
        sensor();
    }
}

swarm_robot();
