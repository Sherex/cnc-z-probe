// Render bug remover in preview
rbr = $preview ? 0.01 : 0;

/* [Render] */
// Number of fragments
$fn = 250; // [1:1:500]
// Render housing
show_housing = true;
// Render probe
show_probe = true;

/* [Housing] */
// Height of the housing
housing_height = 90;
// Radius of the housing
housing_radius = 20;
// Thickness of the housing's walls
housing_wall_width = 5;
// The height the probe slot starts from the bottom
housing_slot_start_height = 10;
// How far from the top of the housing the probe slot stops
housing_slot_top_spacing = 0;
housing_slot_height = (housing_height - housing_slot_start_height) - housing_slot_top_spacing;
// Contact balls' radius
housing_contact_ball_radius = 1;
// Size of gap between the contact balls
housing_contact_ball_gap = 1;
// Size of the slot where the will be placed
housing_contact_wire_gap = 2;
// Position where the wires exit from the housing in releation to the mounting block
housing_contact_wire_exit = 1; // [0:Behind, 1:Left, 2:Right]

/* [Mount] */
// The diameter of the mounting screw
mount_screw_diameter = 3;

/* [Probe] */
// Height of probe
probe_height = 90;
// Radius of the probe
probe_radius = 5;
// Radius of the prongs on the top of the probe
probe_prong_radius = 2;
// The height of the tip at the bottom of the probe
probe_tip_height = 20;

if (show_housing) {
    color("green") {
        housing(
            housing_radius,
            housing_height,
            housing_wall_width,
            probe_prong_radius * 2 * 1.1,
            housing_slot_height,
            housing_slot_start_height,
            housing_contact_ball_radius,
            housing_contact_ball_gap,
            housing_contact_wire_gap,
            housing_contact_wire_exit,
            probe_radius,
            mount_screw_diameter
        );
    }
}

if (show_probe && show_housing) {
    color("silver") {
        animate_probe(
            housing_slot_height - probe_prong_radius * 2,
            probe_prong_radius * 2 * 6,
            probe_prong_radius * 3
        ) {
            translate([
                0,
                0,
                -(probe_height + probe_tip_height) + housing_slot_start_height + probe_prong_radius * 2
            ]) {
                probe(
                    probe_height,
                    probe_radius,
                    probe_prong_radius,
                    housing_radius,
                    probe_tip_height
                );
            }
        }
    }
} else if (show_probe && !show_housing) {
    color("silver") {
        translate ([0, 0, probe_height + probe_tip_height]) {
            rotate([180, 0, 0]) {
                probe(
                    probe_height,
                    probe_radius,
                    probe_prong_radius,
                    housing_radius,
                    probe_tip_height
                );
            }
        }
    }
}

module housing (
    radius,
    height,
    wall_width,
    slot_width,
    slot_height,
    slot_start_height,
    contact_ball_radius,
    contact_ball_gap,
    contact_wire_gap,
    contact_wire_exit,
    probe_radius,
    mount_screw_diameter
) {
    // Bottom plate
    difference() {
        cylinder(wall_width, radius, radius);
        translate([0, 0, -rbr])
            cylinder(wall_width + rbr * 2, probe_radius + 2, probe_radius + 2);
    }

    difference() {
        difference() {
            union() {
                cylinder(height, radius, radius);
                // TODO: Scale properly
                // TODO: Add press-fit mount in module
                translate([-radius - 7, radius / 2, 10]) {
                    rotate([0, 0, 270]) mounting_block([20, 10, 20], mount_screw_diameter);
                }
            }
            translate([0, 0, -rbr])
                cylinder(height + rbr * 2, radius - wall_width, radius - wall_width);
        }
        
        // Slot cutout
        translate([0, 0, slot_start_height]) {
            // Wire cutout
            contact_wire_cutout_width = radius - wall_width + contact_wire_gap;
            cylinder(contact_wire_gap, contact_wire_cutout_width, contact_wire_cutout_width);
            
            for (i = [0:2]) {
                // Long travel slot
                rotate([0, 0, i * 120]) {
                    translate([radius - wall_width / 2, 0, slot_height / 2]) {
                        cube([wall_width * 2, slot_width, slot_height + rbr], true);

                        // Contact balls
                        translate([0, contact_ball_radius + contact_ball_gap / 2, -slot_height / 2]) {
                            sphere(contact_ball_radius);
                        }
                        translate([0, -(contact_ball_radius + contact_ball_gap / 2), -slot_height / 2]) {
                            sphere(contact_ball_radius);
                        }
                        if (i == contact_wire_exit % 3) {
                            translate([-wall_width / 2, -slot_width / 2 - contact_wire_gap, -slot_height / 2]) {
                                cube([wall_width, slot_width + contact_wire_gap * 2, contact_wire_gap]);
                            }
                        }
                    }
                }
                // Probe lock slot
                rotate([0, 0, i * 120 + slot_width * 4]) {
                    translate([radius - wall_width / 2, 0, slot_height - slot_width / 2]) {
                        cube([wall_width * 2, slot_width * 2, slot_width + rbr], true);
                        translate([0, slot_width / 2, -slot_width]) {
                            cube([wall_width * 2, slot_width, slot_width + rbr], true);
                        }
                    }
                }
            }
        }
    }
}

module mounting_block (size, screw_dia = 3) {
    screw_radius = (screw_dia / 2) * 0.9;
    screw_depth = size[1];
    difference() {
        cube(size);
        rotate([90, 0, 0]) {
            translate([size[0] / 2, size[2] / 2, -screw_depth + rbr]) {
                translate([size[0]  / 4, size[2]  / 4, 0]) cylinder(screw_depth, screw_radius, screw_radius);
                translate([-size[0] / 4, size[2]  / 4, 0]) cylinder(screw_depth, screw_radius, screw_radius);
                translate([size[0]  / 4, -size[2] / 4, 0]) cylinder(screw_depth, screw_radius, screw_radius);
                translate([-size[0] / 4, -size[2] / 4, 0]) cylinder(screw_depth, screw_radius, screw_radius);
            }
        }
    }
}

module probe (
    height,
    radius,
    prong_radius,
    prong_length,
    tip_height
) {
    translate([0, 0, height / 2 + tip_height]) {
        cylinder(height, radius, radius, true);
    }
    translate([0, 0, tip_height / 2]) {
        cylinder(tip_height, 0, radius, true);
    }
    translate([0, 0, height - prong_radius + tip_height]) {
        for (i = [0:2]) {
            rotate([0, 90, i * 120]) {
                translate([0, 0, prong_length / 2]) {
                    cylinder(prong_length, prong_radius, prong_radius, true);
                }
            }
        }
    }
}

module animate_probe (z_max, z_rot_max, z2_max) {
    i = $t < 0.5 ? $t * 2 : 1 - (($t - 0.5) * 2);

    z_i = 0.7;
    z_rot_i = 0.2;
    z2_i = 0.1;

    cur_z = z_max * i * (1 / z_i);
    cur_z_rot = z_rot_max * (i - z_i) * (1 / z_rot_i);
    cur_z2 = z_max + z2_max - (z2_max * (i - z_i - z2_i) * (1 / z2_i));

    if (cur_z < z_max) move_rot(cur_z) children();
    else move_rot(z_max);

    if (cur_z >= z_max && cur_z_rot < z_rot_max) move_rot(z_max, cur_z_rot) children();

    if (cur_z >= z_max && cur_z_rot >= z_rot_max) move_rot(cur_z2, z_rot_max) children();
    
    module move_rot (z=0, z_rot=0) {
        translate([0, 0, z]) {
            rotate([0, 0, z_rot]) {
                children();
            }
        }
    }
}








