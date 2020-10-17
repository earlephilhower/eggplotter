Hardware List
-------------
Frame:
 * 12x M3 stepper mounting bolt

Shoulder:
 * M3 bolt 12mm (for motor shaft)
 * M3 Nut
 * M3 bolt 7-10mm (for spring)
 * Extension spring, low force

Arm:
 * 4x M4 bolt 25mm
 * 4x M4 nylock nut
 * M3 bolt 7-10mm (for spring)
 * M3 bolt 20mm (for pen holder)
 * M3 nylock, Optional (for pen holder)
 * M3 Nut

Bearing Block:
 * Two fidget spinner bearings, 8mm inner 22mm outer
 * M8 bolt, at least 60mm
 * Compression spring, roughly 3cm, that fits over the M8 bolt. Moderate force

Chucks:
 * M3 bolt 12mm (for motor shaft)
 * M3 Nut
 * Adhesive rubber pads, 22mm diameter

Assembly Tips
-------------
I sanded and greased all the pivot points of the arm mechanism, and reamed the M4 bolt holes with a 5/32 inch drill bit.

Use the bottom arm stl in order to allow the full +/-60 degree movement in the Y axis.

Firmware
--------
Marlin, see attached config files.

The axes are configured in units of degrees.
X: 0 to 360
Y: -60 to 60

Endstops are configured to always read not-triggered. Don't issue a G28 homing command unless you attach endstops!

Note: the hardware will interfere outside of -54 to 54 degrees in the Y axis unless an egg is mounted.

GCode
-----
Inkscape gcodetools. See attached template and header/footer files. Place the header/footer files in the gcodetools output directory.

The header offsets the y axis to be 0 to 120 degrees.

I've been using this chrome app to send the gcode:
https://chrome.google.com/webstore/detail/gcode-sender/ngncibnakmabjlfpadjagnbdjbhoelom?hl=en

Note: The pen down command uses several servo moves to limit the pen velocity. Otherwise the plotter will smash the tip into the egg pretty hard.

How to Operate
--------------
move the Y axis to center and then activate motors wit M17. Jog the axis to fine tune center. Run the gcode script.

Reference Models
----------------
Special thanks to jarac for the NEMA 17 motor STL
    https://www.thingiverse.com/thing:67561

And to StartRobot for the micro servo STL
    https://www.thingiverse.com/thing:825005