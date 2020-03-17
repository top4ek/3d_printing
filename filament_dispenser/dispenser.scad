$fn = 200;
holder_radius = 15;

body_radius = holder_radius + 5;

module body() {
  difference() {
    hull() {
      cube([15, 7.5, 15]);
      translate([7.5,7.5,7.5])
        sphere(d = 15);
    }
    hull() {
      translate([7.5,7.5,7.5])
        sphere(d = 11);
      translate([2,0,2])
        cube([11, 7.5, 11]);
    }
    translate([7.5,18,7.5])
      rotate([90,0,0])
        cylinder(h = 10, d = 3.5);
  }
}

module ear() {
  difference() {
    union() {
      cube([5,10,2]);
      translate([5, 5, 0])
        cylinder(h = 2, d = 10);
    }
  translate([5, 5, 0])
    cylinder(h = 2, d = 4);
  }
}

module dispenser(){
  translate([15, 2, 2.5])
    rotate([90,0,0])
      ear();
  translate([0, 2, 12.5])
    rotate([90,180,0])
      ear();
  body();
}

module holder() {
  difference() {
    cylinder(h = 20, r = body_radius);
    cylinder(h = 19, r = holder_radius);
    translate([0, -body_radius, 0])
      cube([body_radius,body_radius *2 ,20]);
  }
  translate([-9.7, 3 - body_radius ,18])
    rotate([0, 0, -105])
      ear();
  translate([0, body_radius, 18])
    rotate([0, 0, 105])
      ear();
  translate([1 - body_radius, 5, 18])
    rotate([0,0,180])
      ear();
}

module splitter() {
  rotate_extrude(convexity = 10)
    translate([body_radius, 0, 0])
      circle(r = 2);
  translate([0, 0, -0.5])
  difference() {
    cylinder(r = body_radius, h = 1);
    cylinder(r = holder_radius, h = 1);
  }
}

holder();
translate([body_radius * 2, 0, 0]) dispenser();
translate([0, body_radius * 3, 0])  splitter();

