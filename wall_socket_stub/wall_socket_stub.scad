$fn=100;
thickness = 4;
radius = 32;
bolt_hole_position = 29.65;
hole_radius=1.6;
head_radius=2.6;
head_height=2;

module bolt_hole() {
  cylinder(h = thickness, r = hole_radius);
  cylinder(h = head_height, r = head_radius);
}

difference() {
  cylinder(h = thickness, r = radius);
  translate([bolt_hole_position, 0, 0])
    bolt_hole();
  translate([-bolt_hole_position, 0, 0])
    bolt_hole();
  translate([0, bolt_hole_position, 0])
    bolt_hole();
  translate([0, -bolt_hole_position, 0])
    bolt_hole();
}
