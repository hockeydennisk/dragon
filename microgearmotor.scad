// Adapter for cheap miniature eccentric micro gearmotor from ebay.

use <utils.scad>;

microMotorMount();

module microMotorMount(pulleyDiam = 10, pulleyW = 3, pulleyWallH = 4, pulleyWallW = 1, pulleySlopeW = 3, axleDiam = 1.5) {
    adapterW = 2.5;
    slideRingW = 1;
    slideRingD = axleDiam + 4;
    smoothness = 30;
    totalPulleyW = pulleyW + 2*pulleyWallW + 2*pulleySlopeW;
    glap = 0.15;
    
    pegH = 1.5;
    pegDist = 5;
    
    difference() {
        union() {
            pulley(pulleyDiam, pulleyW, pulleyWallH, pulleyWallW, pulleySlopeW, axleDiam, glap = glap);

            //Base
            translate([0, 0, totalPulleyW])
                cylinder(h = pegH, r = pegDist, $fn = smoothness);
        }

        // Axis
        translate([0,0,totalPulleyW -1])
            cylinder(h = pegH+2, r = axleDiam/2 + glap, $fn = smoothness);

        // Grip slot
        translate([0, 0, totalPulleyW + pegH])
            motorGripSlot();
    }
}


module motorAdapter(diam = 10, height = 5, axleDiam = 1.5, glap = 0.1, smoothness = 30) {
    h = max(height, 2.2);
    r = min(max(diam/2, 10/2), 5);
    gripSlotH = 2.4;

    difference() {
        //Base
        cylinder(h = h, r = r, $fn = smoothness);
        
        // Axis
        translate([0,0,-1])
            cylinder(h = h+2, r = axleDiam/2 + glap, $fn = smoothness);
        
        // Grip slot
        translate([0, 0, height])
            motorGripSlot();
    }
}

module motorGripSlot() {
    gripSlotH = 2.4;

    // Grip slot
    translate([0, 0, -gripSlotH])
        intersection() {
            // Torus part was hard to print
            // cylinderTorus(gripSlotH+1, 3.6, 1.8);
            translate([2.4, 0, 0])
                cylinder(h=gripSlotH+1, r = 3.5/2, $fn = 40);
        }
}

module pulley(pulleyDiam = 10, pulleyW = 10, pulleyWallH = 10, pulleyWallW = 2, pulleySlopeW = 3, axleDiam = 1.5, wireHoleDiam = 1.5, glap = 0.1, smoothness = 40) {
    innerR = pulleyDiam/2;
    outerR = innerR + pulleyWallH;
    totalW = 2*pulleyWallH + 2*pulleySlopeW + pulleyW;

    difference() {
        // Pulley body
        union() {
            translate([0,0,0])                                      
                cylinder(h = pulleyWallW, r = outerR, $fn = smoothness);
            translate([0,0,pulleyWallW])
                cylinder(h = pulleySlopeW, r1 = outerR, r2 = innerR, $fn = smoothness);
            translate([0,0,pulleyWallW + pulleySlopeW])
                cylinder(h = pulleyW, r = innerR, $fn = smoothness);
            translate([0,0,pulleyWallW + pulleySlopeW + pulleyW])
                cylinder(h = pulleySlopeW, r1 = innerR, r2 = outerR, $fn = smoothness);
            translate([0,0,pulleyWallW + pulleySlopeW + pulleyW + pulleySlopeW])
                cylinder(h = pulleyWallW, r = outerR, $fn = smoothness);
        }
        
        // Axle hole
        translate([0,0,-1])  
            cylinder(h = totalW + 2, r = axleDiam / 2 + glap, $fn = smoothness);
            
        // Hole for attaching wire
        if (wireHoleDiam > 0) {
            translate([axleDiam/2 + wireHoleDiam/2 + pulleyWallW/4,0,pulleyWallW + pulleySlopeW + wireHoleDiam/2])  
                rotate([90,0,0])
                    cylinder(h = outerR + 2, r = wireHoleDiam / 2 + glap, $fn = smoothness, center=true);
        }
    }
}

