use <ESP8266Models.scad>;
use <threads-library-by-cuiso-v1.scad>

$fn = 100;

inner_base_radius = 25;
shade_radius = inner_base_radius + 23;
base_radius = shade_radius + 2;
base_height = 14;

shade_thickness = 0.4;   // Your nozzle diameter
default_hull_gap = 0.35; // Gap for easier parts stacking.
shade_slices = 45;
height = 200;

twist = 0;
shade_corners = 8;

cap_height = 6;
cap_radius = shade_radius + 2 * default_hull_gap + shade_thickness + 1;
cap_corners = shade_corners;
cap_vent_holes = 0;  // Number of vent holes. 0 — disable.
cap_vent_hole_radius = 2;

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

module cap() {
  difference() {
    cylinder(h = cap_height, r = cap_radius, $fn = cap_corners);
    translate([0, 0, height - cap_height])
      rotate([0, 180, 0])
        inner_base(default_hull_gap);
    translate([0, 0, 1])
      shade(default_hull_gap + shade_thickness);

    translate([0,0,1])
      cylinder(r = inner_base_radius - 2.5, h = cap_height, $fn = 100);
    if (cap_vent_holes) {
      vent_hole_position = inner_base_radius + (shade_radius - inner_base_radius ) / 2;
      for (a = [0:cap_vent_holes]) {
      angle = a * 360 / cap_vent_holes;
      translate (vent_hole_position * [sin(angle), -cos(angle), 0])
        cylinder (r = cap_vent_hole_radius, h = cap_height, $fn = cap_corners);
      }
    }
  }
}

module inner_base(hull = 0) {
  inner_base_height = height - cap_height - 3;
  difference() {
    union() {
      cylinder(r = inner_base_radius + hull, h = inner_base_height, $fn = 30);
      translate([0, 0, inner_base_height - 5])
        if (hull) {
          thread_for_nut(diameter = 55, length = 5);
        } else {
          thread_for_screw(diameter = 55, length = 5);
        }
    }
    cylinder(r = inner_base_radius - 2.5 - hull, h = inner_base_height, $fn = 30);
    if (!hull) {
      translate([0, 0, -3.5])
        bolt_cut();
      nodmcu_base_cut();

      translate([-27, 0, 150])
        matrix_wire_cut();
      translate([0, -27, 140])
        rotate([0, 0, 90])
          matrix_wire_cut();
      translate([20, 0, 130])
        matrix_wire_cut();
      translate([0, 20, 120])
        rotate([0, 0, 90])
          matrix_wire_cut();

      translate([-27, 0, 55])
        matrix_wire_cut();
      translate([0, -27, 45])
        rotate([0, 0, 90])
          matrix_wire_cut();
      translate([20, 0, 35])
        matrix_wire_cut();
      translate([0, 20, 25])
        rotate([0, 0, 90])
          matrix_wire_cut();
    }
  }
}

module shade(hull = 0) {
  color("white", 0.35)
    difference() {
      cylinder(r = shade_radius + hull, h = height - base_height , $fn = shade_corners);
      if (hull != 0) {
        cylinder(r = shade_radius - hull, h = height - base_height, $fn = shade_corners);
      }
    }
}

module base() {
  difference(){
    union() {
      difference() {
        cylinder(h = base_height, r = base_radius, $fn = 360);
        translate([0, 0, base_height - 2])
          shade(2 * default_hull_gap);
      }
      cylinder(r = shade_radius - 2 * shade_thickness, h = base_height + 5, $fn = shade_corners);
    }
    translate([0, 0, 3])
      difference() {
        cylinder(r = shade_radius - 5, h = base_height + 5, $fn = shade_corners);
        difference() {
          cylinder(r = inner_base_radius + 5, h = base_height - 5);
          hull()
            inner_base(default_hull_gap);
          translate([5 - inner_base_radius, -inner_base_radius - 5, 0])
            cube([inner_base_radius + 15, inner_base_radius * 2 + 10, base_height + 5]);
        }
      }
    translate([-3.6, -49, 5])
      usb_cut();

    bolt_cut();

    translate([0,-18.5, 3.8])
      union() {
        hull()
          NodeMCU_LV3();
        nodemcu_pins_cuts();
      }

    translate([10, 15.75, 1])
      rotate([0,0,90])
        barrel_jack_placeholder();
  }
  translate([0,-18, 5])
    nodemcu_landing_pads();
}

// intersection(){
  base();
  translate([0, 0, 3]) inner_base();
  translate([0, 0, height - 3]) rotate([0,180,0]) cap();
  translate([5 - inner_base_radius, 0, 7]) rotate([-90,0,90]) bolt();
  translate([0, 0, base_height - 3]) shade();
// }


