[Back](../#README)

---
# Current customization options
These can be used on Thingiverse or in OpenSCAD.

### Render
```
// Number of fragments
$fn = 50; // [1:1:500]
// Render housing
show_housing = true;
// Render probe
show_probe = true;
```
### Housing
```
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
```

### Mount
```
// The diameter of the mounting screw
mount_screw_diameter = 3;
````

### Probe
```
// Height of probe
probe_height = 90;
// Radius of the probe
probe_radius = 5;
// Radius of the prongs on the top of the probe
probe_prong_radius = 2;
// The height of the tip at the bottom of the probe
probe_tip_height = 20;
```

---
[Back](../#README)