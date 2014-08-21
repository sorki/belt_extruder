include <../MCAD/motors.scad>;
include <../MCAD/bearing.scad>;
include <../MCAD/nuts_and_bolts.scad>;

$fn = 40;

thickness = 8;
shaft_offset = 20;
bearing_r = 8;  // bearingDimensions(625); from bearing.scad
bearing_tolerance = 0.1; // mm on each side
filament_z_offset = 18;
filament_d = 1.75;
filament_tolerance = 1; // mm on each side
filament_y_offset = -2;
drive_pulley_r = 5.8;

m3_hole_size = 3.4;
m5_hole_size = 5.5;

tolerance = 0.5;
m3_cap_dia = METRIC_NUT_AC_WIDTHS[3] + tolerance;

filament_r = filament_d/2 + filament_tolerance;
echo(filament_r);
bearing_scale = (bearing_r + bearing_tolerance)/bearing_r;

support = true;

module filament_guide(base=false) {
  difference() {
      union() {
        intersection() {
        translate([-15, -2, 0]) cube([10, 10, 10], center=true);
        difference() {
          translate([-11, -2, 0]) rotate([0, 90, 0]) cylinder(r=5, h=20, center=true);
          if(base)
          translate([-11, -2, -2.5]) cube([22, 10, 5], center=true);
        }
        }
        // base
        if(base)
          translate([-15, -2, -2.5]) cube([10, 10, 6], center=true);
		// tip
        translate([-7.5, -2, 0]) rotate([0, 90, 0]) cylinder(r1=5, r2=2, h=5, center=true);
      }
      // filament
      translate([0, filament_y_offset, 0]) {
      % translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=filament_r, h=100, center=true);
      translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r1=filament_r, r2=1, h=100, center=true);


      // intake
      # translate([-19, 0, 0]) rotate([0, 90, 0]) cylinder(r1=3, r2=1, h=3, center=true);
      }
  }
}


module body() {
guide_len=8;
// % translate([0, -20, 0]) cylinder(r=17, h=50);
difference() {
    intersection() {
      union() {
        translate([0, -12, 0]) cylinder(r=30, h=30);
        translate([0, 20, thickness/2]) cube([40, 90, thickness], center=true);
      }
      union() {
        // main plate
        translate([0, 2.5, thickness/2]) cube([40, 100, thickness], center=true);
        // bearing plate
        translate([0, -25, thickness+3]) cube([40, 35, 6], center=true);
      }
    }
    translate([0, 20, -0.01]) linear_extrude(100) rotate([180, 0, 0]) stepper_motor_mount(17, 10, mochup=false);
    translate([0, 20, -0.01]) linear_extrude(2.5) rotate([180, 0, 0]) stepper_motor_mount_bolt_caps(17, 10, mochup=false);

    translate([5.1, -29, thickness]) cube([30, 3, 20], center=true);

    translate([0, -shaft_offset, 0])  {

      // m5 hole
      cylinder(r=m5_hole_size/2 + 2, h=100, center=true);
      // bottom bearing
      translate([0, 0, -0.01]) scale([bearing_scale, bearing_scale, 1]) bearing(model=625, outline=true);
      // top bearing
      translate([0, 0, 8.01]) scale([bearing_scale, bearing_scale, 1.3]) bearing(model=625, outline=true);
      // hobbed bolt
      % translate([0, 0, 15]) cylinder(r=drive_pulley_r, h=10);
      // idler bearing & mounting holes
      translate([0, -16, 0]) {
        * % translate([0, 0, 15]) scale([bearing_scale, bearing_scale, 1.2]) bearing(model=625, outline=!true);
        translate([0, 0, -1]) cylinder(r=m5_hole_size/2, h=20);
        nutHole(5);
      }
      // more space for idler side
      rotate([0, 0, 12]) translate([15, -10, 5]) cube([10, 5, 20], center=true);
      rotate([0, 0, 12]) translate([7, -9, 5]) cube([15, 3, 20], center=true);

      // idler side
      translate([15, -17, 7]) {
        rotate([-90, 0, 0])  {
          boltHole(3, length=15);
          translate([0, 0, 1]) boltHole(3, length=15);
          cylinder(r=2, h=25);
          translate([0.5, 0, 0]) cylinder(r=2, h=25);
        }
        translate([0.1, 20, 0]) cube([10, 4, 6.2], center=true);
        % translate([0.1, 21, 0])  rotate([90, 0, 0]) nutHole(3);
      }
    }

    for(i=[0:5])
    translate([-15.5 + i * 10.3, 48, 0]) cylinder(r=1.6, h=40,, center=true);

    // space to allow idler movement
    translate([-7, -31, 0]) cylinder(r=3, h=100, center=true);
    translate([-5, -33, 0]) rotate([0, 0, 45]) cube([5, 3, 20]);
  }

  // support cylinder
  if(support) {
    translate([0, -shaft_offset, 0])
      difference() {
        cylinder(r=m5_hole_size/2+2.3, h=5);
        cylinder(r=m5_hole_size/2+2, h=50, center=true);
      }
  }
}
difference() {
difference() {
    body();

    for(i=[10, -15]) {

      # translate([i, -11, 0]) nutHole(3);
    }
}
for(i=[10, -15])
      # translate([i, -11, 0]) cylinder(r=1.5, h=40, center=true);
}

/*
ptfe pushfit attempt
difference() {
  cube([7, 10, 3.5], center=true);
  # translate([0, 0, 0.8]) rotate([90, 0, 0]) cylinder(r=1.6, h=11, center=true, $fn=50);
  # translate([0, 0, 1.4]) cube([3, 10, 1], center=true);
}
*/
