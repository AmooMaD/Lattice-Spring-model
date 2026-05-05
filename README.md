README
======

Code title:
2D lattice relaxation of an initially compressed elastic body


Description:
------------
This MATLAB code simulates the relaxation of an elastic lattice that is initially subjected to an external force.

The object is represented as a 2D network of nodes connected by springs. Each node interacts with its eight neighboring nodes. The spring forces deform the structure, while the damping term allows the system to relax toward a steady-state configuration.

Although the original description mentions a cube, the current code is a 2D rectangular lattice, not a 3D cube.


Main idea:
----------
The model uses a mass-spring system.

Each lattice node has:
- position
- velocity
- acceleration
- internal elastic force
- external force

The distance between neighboring nodes changes during deformation. The spring force is calculated from the difference between the current distance and the initial rest distance.

The simulation then updates the position, velocity, and acceleration of all nodes over many cycles.


Lattice size:
-------------
Ni = 5
Nj = 75

This means the lattice has 5 nodes in the X direction and 75 nodes in the Y direction.


Main parameters:
----------------
Ni      Number of nodes in X direction
Nj      Number of nodes in Y direction
M       Mass of each lattice node
E       Spring stiffness
F0      External force magnitude
Nc      Number of simulation cycles
theta   Damping coefficient
cs      Estimated sound speed


Neighbor structure:
-------------------
Each node is connected to 8 neighboring nodes.

The neighbor directions are arranged as:

        6   2   5
         \  |  /
    3 ---- node ---- 1
         /  |  \
        7   4   8

The four horizontal and vertical neighbors have rest distance 1.

The four diagonal neighbors have rest distance sqrt(2).


Boundary conditions:
--------------------
An external force is applied on the last column of the lattice:

Fx_ext(:,end) = F0

The first column is fixed by applying a force opposite to the internal elastic force:

Fx_ext(:,1) = -Fx(:,1)
Fy_ext(:,1) = -Fy(:,1)

Boundary interactions outside the physical domain are removed manually. This is necessary because circshift would otherwise create artificial periodic connections.


Time integration:
-----------------
The code uses a velocity-Verlet-like time integration scheme.

First, an intermediate velocity is calculated.

Then the position of each node is updated.

After that, spring forces are computed from the new positions.

The acceleration is updated using the total force and damping.

Finally, the velocity is updated.


Outputs:
--------
The code produces two main visualizations.

Figure 1:
Shows the initial lattice and the applied external force.

Figure 2:
Updated every 5000 cycles. It shows:

1. Total force in the X direction
2. Total force in the Y direction
3. Force distribution along the middle row
4. Current deformed shape of the lattice


How to run:
-----------
Open the file in MATLAB and run it directly.

Example:

run your_file_name.m

The code does not require external libraries.


Important note:
---------------
The number of cycles is very large:

Nc = 5e6

This may make the simulation slow.

For testing, it is better to start with a smaller value, for example:

Nc = 5e4

or

Nc = 1e5

After checking that the simulation behaves correctly, Nc can be increased again.


Expected behavior:
------------------
At the beginning, the lattice is undeformed.

After the external force is applied, the lattice starts moving and deforming.

Because damping is included, the oscillations gradually decrease.

The system should eventually approach a relaxed equilibrium configuration.


Possible improvements:
----------------------
- Add a convergence criterion instead of using a fixed number of cycles
- Save displacement and force data during the simulation
- Plot total elastic energy over time
- Convert the model from 2D to 3D
- Add clearer boundary-condition names
- Export the final deformed shape
- Replace clear all with clear for better MATLAB performance


Author note:
------------
This code is a simple elastic relaxation model based on a 2D spring lattice. It can be used to study deformation, internal force redistribution, damping, and relaxation toward mechanical equilibrium.
