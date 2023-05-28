$fn = 100;

psu_length = 111;
psu_width  = 78;
psu_height = 37;
psu_base_thickness = 1;
psu_rear_brow = 9;
psu_front_brow = 15;

module mx_cut(d) {
  cylinder(h = psu_base_thickness, d = d);
}

module psu_board() {
  offset = psu_base_thickness + 7;
  difference() {
    cube([psu_length - psu_base_thickness, psu_width - psu_base_thickness, psu_base_thickness]);
    translate([psu_length - offset, psu_width - offset, 0])
      cube([7, 7, psu_base_thickness]);
  }
  translate([psu_length - psu_front_brow - psu_base_thickness, 10])
    contact_plate();
  translate([psu_length - 6, psu_width - 13, psu_base_thickness])
    voltage_adjuster();
}

module voltage_adjuster() {
	difference() {
		cylinder(d = 8, h = 8);
		translate([-0.5, -3, 7]) cube([1, 6, 1]);
		translate([-3, -0.5, 7]) cube([6, 1, 1]);
	}
}

module contact_plate(sections = 5) {
	section_width = 7.65;
	section_height = 12.2;
	section_z = 15.1;

	cube([section_height / 2, section_width * sections, section_z]);
	for (i = [0:sections]) {
		translate([0, section_width * i, 0])
			cube([section_height, 1.45, section_z]);
	}
	for (i = [0:sections - 1]) {
		translate([3, 4.5 + section_width * i, section_z / 2])
			rotate([0, 90, 0])
				cylinder(d = 6.2, h = 5);
	}
}


module psu_s50_5() {
	// bottom_wall();
	difference() {
		  cube([psu_length, psu_width, psu_base_thickness]);
		  translate([psu_length - 4.5, psu_width - 4.5, 0])
			mx_cut(4);
		  translate([psu_length - 4.5,  4.5, 0])
			mx_cut(3);
		  translate([10,  6.5, 0])
			mx_cut(3);
		  translate([77,  25, 0])
			mx_cut(3);
		  translate([41,  25, 0])
			mx_cut(3);
		  translate([41,  53, 0])
			mx_cut(3);
	}
	// front_wall
	translate([psu_length - psu_front_brow - psu_base_thickness, 0, psu_height - 9])
		cube([psu_base_thickness, psu_width, 9]);

	translate([psu_length - psu_front_brow - psu_base_thickness, 0, psu_height - 27])
	    cube([psu_base_thickness, 10, 27]);

	// left_wall
	translate([psu_rear_brow, 0, 0])
		cube([psu_length - psu_front_brow - psu_rear_brow, psu_base_thickness, psu_height]);

	// right_wall
	difference() {
		translate([0, psu_width, 0])
		  cube([psu_length, psu_base_thickness, psu_height]);
		translate([psu_length - 10, psu_width, 18])
		  rotate([-90, 0, 0])
			mx_cut(3);
		translate([12, psu_width, 13])
		  rotate([-90, 0, 0])
			mx_cut(3);
		translate([psu_length - 4.5, psu_width, 27])
		  rotate([-90, 0, 0])
			mx_cut(4);
		translate([0, psu_width, 27])
		  cube([4, psu_base_thickness, 3.5]);
	}

	// rear_wall
	translate([psu_rear_brow, 0, psu_height - 25])
		cube([psu_base_thickness, psu_width, 25]);

	// top_wall
	translate([0, 10, 0])
		cube([psu_base_thickness, psu_width - 10, 8]);

	translate([psu_rear_brow, 0, psu_height - psu_base_thickness])
		cube([psu_length - psu_rear_brow - psu_front_brow, psu_width, psu_base_thickness]);

	translate([psu_base_thickness, psu_base_thickness, 7])
	  psu_board();
}

module psu_rs25_5() {
	x = 78;
	y = 51.5;
	z = 28;
	difference() {
		cube([x, y, z]);
		translate([11.5, 25.5, 0]) {
			cylinder(d = 3, h = 5);
			translate([53.5, 0, 0]) cylinder(d = 3, h = 5);
		}
		translate([2.5, y, 15]) {
			rotate([90, 0, 0]) cylinder(d = 3, h = 5);
			translate([61.5, 0, 0]) rotate([90, 0, 0]) cylinder(d = 3, h = 5);
		}
	}
	translate([x, 1, 6]) contact_plate();
}

module psu_rs15_5() {
	x = 62.8;
	y = 51.5;
	z = 27.85;
	difference() {
		cube([x, y, z]);
		translate([14.2, 25.5, 0]) {
			cylinder(d = 3, h = 5);
			translate([38.3, 0, 0]) cylinder(d = 3, h = 5);
		}
		translate([11.5, y, 15]) {
			translate([0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 3, h = 5);
			translate([38, 0, 0]) rotate([90, 0, 0]) cylinder(d = 3, h = 5);
		}
	}
	translate([x, 1, 6]) contact_plate();
}
