// for 18650 battery
diameter = 18;
height = 650;

$fn = 360;
radius = diameter / 2;
real_height = height / 10;

module plus_pole_cut() {
  difference() {
    cylinder(h = 1, r = radius - 1);
    cylinder(h = 1, r = radius - 2);
  }
}

module battery() {
  difference() {
    cylinder(h = real_height, r = radius);
    translate([0, 0, real_height - 1])
      plus_pole_cut();
  }
}

battery();
