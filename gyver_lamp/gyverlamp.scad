use <ESP8266Models.scad>;
use <threads-library-by-cuiso-v1.scad>

$fn = 100;

inner_base_radius = 25;
shade_radius = inner_base_radius + 23;
base_radius = shade_radius + 2;

shade_thickness = 0.8; // Must be ≥ nozzle diameter.
default_hull_gap = 0.35; // Gap for easier parts stacking.
shade_slices = 45;
height = 200;

twist = 0;
shade_corners = 8;

cap_radius = shade_radius + 1;
cap_corners = shade_corners;
cap_vent_holes = 0;  // Number of vent holes. 0 — disable.
cap_vent_hole_radius = 2;

module cap() {
  difference() {
    cylinder(h = 6, r = cap_radius, $fn = cap_corners);
    translate([0, 0, height + 1])
      rotate([0, 180, 0])
        shade(default_hull_gap);
    translate([0, 0, height + 1])
      rotate([0, 180, 0])
        inner_base(default_hull_gap);
    translate([0,0,1])
      cylinder(r = inner_base_radius - 2.5, h = 6, $fn = 100);
    if (cap_vent_holes) {
      vent_hole_position = inner_base_radius + (shade_radius - inner_base_radius ) / 2;
      for (a = [0:cap_vent_holes]) {
      angle = a * 360 / cap_vent_holes;
      translate (vent_hole_position * [sin(angle), -cos(angle), 0])
        cylinder (r = cap_vent_hole_radius, h = 6, $fn = cap_corners);
      }
    }
  }
}

module barrel_jack_placeholder() {
  translate([4.4, 2, 0])
    cube([22.1, 16, 12.75]);
  translate([26.5, 10, 6.33])
    rotate([0, 90, 0])
      cylinder(h = 8, r = 5.5, $fn = 360);
  translate([-15, 4.9, 4.4])
    cube([24.4, 10.2, 10]);
}

module usb_cut() {
  minkowski(){
    cube([7, 2, 2]);
    rotate([90, 0, 0])
      cylinder(h = 2, r = 1);
  }
}

module bolt_cut() {
  translate([5 - inner_base_radius, 0, 7]) rotate([-90,0,90])
    bolt(default_hull_gap);
}

module nodemcu_pins_cuts() {
  translate([12.5,-19.3,-2.5])
    cube([3,38.5,2]);
  translate([-15.5,-19.3,-2.5])
    cube([3,38.5,2]);
}

module nodemcu_landing_pads() {
  // Chip side pads
  translate([12.65,25.6,-3])
    cylinder(h = 4, r = 1.2);
  translate([-12.65,25.6,-3])
    cylinder(h = 4, r = 1.2);

  // Connector side pads
  // translate([-12.65,-25.6,-2])
  //   cylinder(h = 4, r = 1.2);
  // translate([12.65,-25.6,-2])
  //   cylinder(h = 4, r = 1.2);
}

module matrix_wire_cut() {
  minkowski(){
    cube([5, 1, 25]);
    rotate([0, 90, 0])
    cylinder(h = 1, r = 5);
  }
}

module nodmcu_base_cut() {
  translate([-18,-50,0])
    cube([36,50,11]);
  translate([-8,-0,0])
    cube([16,50,11]);
}

module inner_base(hull = 0) {
  difference() {
    union() {
      cylinder(r = inner_base_radius + hull, h = height, $fn = 100);
      translate([0,0,height - 5])
        if (hull) {
          thread_for_nut(diameter = 55, length = 5);
        } else {
          thread_for_screw(diameter = 55, length = 5);
        }
    }
    cylinder(r = inner_base_radius - 2.5 - hull, h = height, $fn = 100);
    if (!hull) {
      translate([0, 0, -3.5])
        bolt_cut();
      nodmcu_base_cut();
      translate([20, 0, 145])
        matrix_wire_cut();
      translate([20, 0, 55])
        matrix_wire_cut();
      translate([-27, 0, 55])
        matrix_wire_cut();
      translate([-27, 0, 145])
        matrix_wire_cut();
    }
  }
}

module shade(hull = 0) {
  color("white", 0.35) difference() {
    linear_extrude(height = height - 1,
                   center = false,
                   convexity = 0,
                   twist = twist,
                   slices = shade_slices)
      circle(r = shade_radius + hull, $fn = shade_corners);
    linear_extrude(height = height - 1,
                   center = false,
                   convexity = 0,
                   twist = twist,
                   slices = shade_slices)
      circle(r = shade_radius - hull - shade_thickness, $fn = shade_corners);
    if (hull == 0) {
      translate([0,0,-1])
        nodmcu_base_cut();
      translate([0,0,-3])
        bolt_cut();
    }
  }
}

module base() {
  difference() {
    cylinder(h = 14, r = base_radius, $fn = 360);

    translate([-3.6, -49, 5])
      usb_cut();

    bolt_cut();

    translate([0,-18.5, 3.8])
      union() {
        hull()
          NodeMCU_LV3();
        nodemcu_pins_cuts();
      }

    translate([0,0,3])
      hull()
        inner_base(default_hull_gap);

    translate([10, 15.75, 1])
      rotate([0,0,90])
        barrel_jack_placeholder();

    translate([0, 0, 3]) {
      shade(default_hull_gap);
      intersection(){
        hull()
          shade(default_hull_gap);
        nodmcu_base_cut();
      }
    }
  }
  translate([0,-18, 5])
    nodemcu_landing_pads();
}

module bolt(hull = 0) {
  length = base_radius - inner_base_radius + 5;
  cylinder(h = length - 3, r = 2, $fn = 100);
  if (hull) {
    translate([0, 0, 5])
      cylinder(h = length - 5, r = 2.5 + hull, $fn = 100);
  }
  translate([0, 0, -0.8])
    if (hull) {
      thread_for_nut_fullparm(diameter = 6, length = 10, pitch = 2.5, divs = 100);
    } else {
      thread_for_screw_fullparm(diameter = 6, length = 10, pitch = 2.5, divs = 100);
    }

  translate([0,0,-2 - hull])
    cylinder(h = 2 + hull, r1 = 0, r2 = 2 + hull / 2, $fn = 100);
  translate([0, 0, length - 5])
    difference() {
      cylinder(h = 5, r1 = 1 + hull / 2, r2 = 5 + hull / 2, $fn = 100);
      if (hull == 0) {
        union() {
          difference() {
            cylinder(h = 5, r1 = hull / 2, r2 = 4 + hull / 2, $fn = 100);
            translate([0.5, 0.5, 0])
              cube([5, 5, 5]);
            translate([-5.5, -5.5, 0])
              cube([5, 5, 5]);
          }
        }
      }
    }
}

// base();
// translate([0, 0, 3]) inner_base();
// translate([0, 0, height + 4]) rotate([0,180,0]) cap();
// translate([0, 0, 3]) shade();
translate([5 - inner_base_radius, 0, 7]) rotate([-90,0,90]) bolt();
