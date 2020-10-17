// Egg Plotter by Jeff Rogers

include <threads.scad>

show_top_arm = false;
show_bottom_arm = false;
show_shoulder = false;
show_frame = true;
show_bearing_block = false;
show_chuck = false;
show_tail_chuck = false;
show_pen_holder=false;

show_assembly = true;

egg_center = 70;

arm_width=14;
arm_length = 45;
    
frame_thickness = 6;

frame_height=60;
motor_width=44;

arm_pivot_margin=0.35;
pivot_diameter = 4.0;

shoulder_width = 20;
shoulder_thickness = 10;

chuck_diameter = 20;
chuck_cutout_diameter = 24;


pen_diameter = 10+.4;
pen_slot_length = 2;
clamp_thickness=3;

m3_nut_width=5.5+.2;
m3_nut_height=2.4+.2;

shoulder_gap=2;
shoulder_height = 40;  // Distance of arm pivot
servo_below = 18;

arc_radius = 45;


arm_angle=0;
shoulder_angle=0;

pen_holder_height=15;

pen_holder_front = 10;
pen_clearance = 2;


//arm_angle=2;
//shoulder_angle=0;

//arm_angle=0;
//shoulder_angle=30;

arm_angle=2;
shoulder_angle=-60;


module stepper()
{
    translate([0, 0, -16.8])
    import("Motor_NEMA17.stl");
}


module egg()
{
    scale([43,43,55])
    sphere(d=1, $fn=30);
    scale([45,45,60])
    sphere(d=1, $fn=30);

}

module motor_shaft_clamp()
{
    
    cylinder(d=5.25, h=100, $fn=50, center=true);
    rotate([90, 0, 0])
    cylinder(d=3.25, h=20, $fn=20);

    translate([0, -5, 0])
    cube([m3_nut_width, m3_nut_height, 100], center=true);
}

module motor_mount()
{
    cylinder(d=24, h=50, $fn=50, center=true);

    bolt_distance = 15.5;

    for (i = [-bolt_distance, bolt_distance])
    {
    for (j = [-bolt_distance, bolt_distance])
    {
        
    translate([i, j, 0])
    {
        cylinder(d=3.25, h=20, $fn=20, center=true);
        translate([0, 0, 3])
        cylinder(d=6.25, h=20, $fn=20);
    }
    }
    }
}

module shoulder()
{    
    difference()
    {
        union()
        {
        linear_extrude(shoulder_thickness)
        {
            circle(d=shoulder_width);
            translate([-shoulder_width/2, 0])
            square([shoulder_width, shoulder_height + pen_holder_height]);
        }
        translate([0, shoulder_height + pen_holder_height, shoulder_thickness/2])
        rotate([0, 90, 0])
        cylinder(d=shoulder_thickness, h=shoulder_width, $fn=40, center=true);
        }

        translate([0, shoulder_height, shoulder_thickness/2])
        rotate([0, 90, 0])
        cylinder(d=pivot_diameter, h=100, $fn=20, center=true); 

        translate([0, shoulder_height + pen_holder_height, shoulder_thickness/2])
        rotate([0, 90, 0])
        cylinder(d=pivot_diameter, h=100, $fn=20, center=true); 


        translate([0, shoulder_height, 0])
        cube([arm_width+arm_pivot_margin, 1.3 * shoulder_thickness, 100], center=true);


        translate([0, shoulder_height + pen_holder_height, 0])
        cube([arm_width+arm_pivot_margin, 1.3 * shoulder_thickness, 100], center=true);
        
        translate([0, 0, shoulder_thickness/2])
        rotate([0, 0, 90])
        motor_shaft_clamp();

        translate([0, 10, shoulder_thickness/2])
        rotate([0, 90, 0])
        cylinder(d=3, h=100, $fn=20);
    }

    translate([-26, shoulder_height + 6 - servo_below, 12 + shoulder_thickness])
    {
        rotate([180, 0, 0])
        rotate([90, 0, 90])
        %import("microServo-sg90.stl");
        
        translate([16, 0, 0])
        rotate([0, 180, 0])
        {
            difference()
            {
            cube([5, 5, 12 + shoulder_thickness]);
            rotate([0, 90, 0])
            translate([-5.8, 2.3, 0])
            cylinder(d=1.8, h=40, center=true, $fn=15);
            }
            translate([0, -27.5, 0])
            {
            difference()
            {
            cube([5, 5, 12 + shoulder_thickness]);
            rotate([0, 90, 0])
            translate([-5.8, 2.6, 0])
            cylinder(d=1.8, h=40, center=true, $fn=15);
            }
        }
        }

    }
}

module arm(chuck_clearance = false)
{    
    difference()
    {

        union()
        {
            translate([-arm_width/2, -shoulder_thickness/2, shoulder_thickness/2])
            union()
            {
                cube([arm_width, shoulder_thickness, arm_length]);
                translate([0, shoulder_thickness/2, 0])
                rotate([0, 90, 0])
                cylinder(d=shoulder_thickness, h=arm_width, $fn=40);
            }

            hull()
            {
            translate([0, 0, arm_length + shoulder_thickness/2 - pen_clearance])
            rotate([90, 0, 0])
            cylinder(d=shoulder_width, h=shoulder_thickness, center=true, $fn=40);

            translate([-shoulder_width/2, -shoulder_thickness/2, arm_length + shoulder_thickness/2 - pen_clearance])
            cube([shoulder_width, shoulder_thickness, pen_holder_front + pen_clearance - shoulder_thickness/2]);

            translate([0, 0, arm_length + shoulder_thickness/2 + pen_holder_front])

            rotate([0, 90, 0])
            cylinder(d=shoulder_thickness, h=shoulder_width, $fn=40, center=true);
            }
        }

        // Pen clearance
        hull()
        {
        translate([0, 0, arm_length + shoulder_thickness/2 - pen_clearance])
        rotate([90, 0, 0])
        cylinder(d=arm_width+arm_pivot_margin, h=2*shoulder_thickness, center=true, $fn=40);

        translate([-(arm_width+arm_pivot_margin)/2, -shoulder_thickness, arm_length + shoulder_thickness/2 - pen_clearance])
        cube([arm_width+arm_pivot_margin, 2*shoulder_thickness, pen_holder_front + pen_clearance + shoulder_thickness/2]);

        }

        // Pivot
        translate([0, 0, shoulder_thickness/2])
        rotate([0, 90, 0])
        cylinder(d=pivot_diameter, h=100, $fn=20, center=true);


        // Pivot
        translate([0, 0, arm_length + shoulder_thickness/2 + pen_holder_front])
        rotate([0, 90, 0])
        cylinder(d=pivot_diameter, h=100, $fn=20, center=true);


        // Rubber band bolt
        translate([0, 0, shoulder_thickness/2 + 10])
        rotate([0, 90, 0])
        cylinder(d=3, h=100, $fn=20);
        translate([0, 0, shoulder_thickness/2 + 15])
        rotate([0, 90, 0])
        cylinder(d=3, h=100, $fn=20);

        if (chuck_clearance)
        {
            translate([0, -chuck_cutout_diameter/2, arm_length + shoulder_thickness/2]) 
            rotate([0, 90, 0])
            cylinder(d=chuck_cutout_diameter, h=100, $fn=80, center=true);
        }
    }
}


module pen_holder()
{
    translate([0, 0, 26])
    rotate([180, 0, 0])
    %cylinder(d=3, h=43);

    
    translate([0, 0, -shoulder_thickness/2])
    difference()
    {
        hull()
        {
            cylinder(d=arm_width, h=pen_holder_height + shoulder_thickness, $fn=40);
            translate([-arm_width/2, -pen_holder_front, 0])
            cube([arm_width, pen_holder_front, pen_holder_height + shoulder_thickness]);
            translate([0, -pen_holder_front, shoulder_thickness/2])
            rotate([0, 90, 0])
            cylinder(d=shoulder_thickness, h=arm_width, center=true, $fn=40);
            translate([0, -pen_holder_front, shoulder_thickness/2 + pen_holder_height])
            rotate([0, 90, 0])
            cylinder(d=shoulder_thickness, h=arm_width, center=true, $fn=40);

        }
        hull()
        {
            cylinder(d=pen_diameter, h=100, center=true, $fn=40);
            translate([0, -pen_slot_length, 0])
            cylinder(d=pen_diameter, h=100, center=true, $fn=40);
        }
        
        
        // Pivot
        translate([0, -pen_holder_front, shoulder_thickness/2])
        rotate([0, 90, 0])
        cylinder(d=pivot_diameter, h=100, $fn=20, center=true);


        // Pivot
        translate([0, -pen_holder_front, pen_holder_height + shoulder_thickness/2])
        rotate([0, 90, 0])
        cylinder(d=pivot_diameter, h=100, $fn=20, center=true);

        // Clamp nut
        translate([0, -pen_holder_front, 0])
        cube([m3_nut_width, m3_nut_height, 100], center=true);
        // clamp bolt
        translate([0, 0, (pen_holder_height + shoulder_thickness) / 2])
        rotate([90, 0, 0])
        cylinder(d=3.25, h=100, $fn=20);

        
    }
}




module m8_bolt()
{

    cylinder(d=13.2, h=8, $fn=20);

    rotate([0, 0, 180])
    {
        cylinder(d=8, h=28, $fn=20);
        translate([0, 0, 28])
//        render()
//        metric_thread(8, 1.25, 32);
        cylinder(d=8, h=32, $fn=20);
    } 
    
}

module bearing_block()
{
    block_length=20;
    translate([0, 0, -28])
    %m8_bolt();
    
    translate([0, 0, -block_length])
    {
        difference()
        {
            cylinder(d=26, h=block_length, $fn=40);
            translate([0, 0, -1])
            cylinder(d=22.1, h=8, $fn=40);
            translate([0, 0, block_length-7])
            cylinder(d=22.1, h=8, $fn=40);
            cylinder(d=14, h=50, $fn=40, center=true);
        }
    }
    translate([0, 0, -2])
    difference()
    {
        cube([motor_width-6, motor_width-6, 5], center=true);
        cylinder(d=22,  h=50, $fn=40, center=true);

        bolt_distance = 15.5;

        for (i = [-bolt_distance, bolt_distance])
        {
        for (j = [-bolt_distance, bolt_distance])
        {
            
        translate([i, j, 0])
        {
            cylinder(d=2.8, h=20, $fn=20, center=true);
        }
        }        
        }
    }
}

module tail_chuck()
{
    chuck_length=20;
    difference()
    {
        cylinder(d=chuck_diameter, h=chuck_length, $fn=40);
        translate([0, 0, -1])
        render()
        {
            metric_thread(8.15, 1.25, chuck_length + 2, internal=true);
        }
    }
    translate([0, 0, chuck_length])
    %cylinder(d=22, h=5, $fn=40);    
}


module chuck()
{
    chuck_length=30;
    difference()
    {
        cylinder(d=chuck_diameter, h=chuck_length, $fn=40);
        translate([0, 0, 5])
        motor_shaft_clamp();
    }
    translate([0, 0, chuck_length])
    %cylinder(d=22, h=5, $fn=40);    
}

module side_frame(show_stepper)
{
    if (show_stepper)
    {
        %stepper();
        translate([0, 0, 10])
        %chuck();
    }
    else
    {
        %bearing_block();
        translate([0, 0, 20])
        %tail_chuck();
    }
    difference()
    {
        translate([-motor_width/2, -frame_height + motor_width/2, 0])
        cube([arm_length + motor_width/2 + shoulder_thickness / 2 + shoulder_gap + frame_thickness, frame_height, frame_thickness]);
        motor_mount();
    }

    front_thickness = frame_thickness/2;
    front_height=15;
    translate([-motor_width/2, -frame_height + motor_width/2, 0])
    cube([front_thickness, front_height, egg_center]);

    translate([-motor_width/2 + front_thickness, -motor_width + frame_thickness, frame_thickness])
    rotate([0, -90, 0])
    linear_extrude(front_thickness)
    polygon([[0, 0], [0, frame_height], [egg_center*.75, 0]]);

}

if (show_assembly)
{
    translate([egg_center, arm_length + shoulder_thickness / 2, 0])
    rotate([90, 0, 0])
    {

        rotate([0, 0, shoulder_angle])
        {
            shoulder();
            translate([0, shoulder_height, 0])
            translate([0, 0, shoulder_thickness/2])
            {
                rotate([arm_angle, 0, 0])
                translate([0, 0, -shoulder_thickness/2])
                arm(true);
                translate([0, pen_holder_height, 0])
                rotate([arm_angle, 0, 0])
                translate([0, 0, -shoulder_thickness/2])
                arm();

                translate([0, -sin(arm_angle) * (arm_length + pen_holder_front), cos(arm_angle) * (arm_length + pen_holder_front) - pen_holder_front])

                rotate([-90, 0, 0])
                pen_holder();
            }
        }
        translate([0, 0, -frame_thickness - shoulder_gap])
        %stepper();
    }
}

if (show_frame)
{
    translate([egg_center, arm_length + shoulder_thickness / 2, 0])
    rotate([90, 0, 0])
    {

        difference()
        {
        translate([-egg_center, -frame_height + motor_width/2, - shoulder_gap - frame_thickness])
        cube([2 * egg_center, frame_height, frame_thickness]);

        translate([0, 0, -frame_thickness - shoulder_gap])
        motor_mount();

        wire_hole_diameter=12;
        translate([0, -motor_width/2 - wire_hole_diameter/2, 0])
        cylinder(d=wire_hole_diameter, h=100, $fn=40, center=true);
        }
    }
    
    rotate([90, 0, 90])
    {
        side_frame(true);
    }

    translate([2 * egg_center, 0, 0])
    rotate([90, 0, -90])
    {
        mirror()
        side_frame(false);
    }

}

if (show_bearing_block)
{
    bearing_block();
}

if (show_tail_chuck)
{
    tail_chuck();
}

if (show_top_arm)
{
    arm();
}

if (show_bottom_arm)
{
    arm(true);
}

if (show_shoulder)
{
    shoulder();
}

if (show_chuck)
{
    chuck();
}

if (show_pen_holder)
{
    pen_holder();
}


if (show_assembly)
{
    translate([egg_center, 0, 0])
    rotate([0, 90, 0])
    %egg();
}