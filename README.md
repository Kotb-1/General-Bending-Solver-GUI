# General Bending Solver

The code receives loads and supports of both planes as input, solves the system, and generates plots for shear force, bending moment, and beam deflection.

## Main Script

`Main_Script.m` is the primary script you will be editing.

### Required Changes

You only need to change the following:
- Defined supports
- Defined loads

### Defining Loads

Use the following functions to define loads:
- `rec(INPUTs)` for rectangular loads
- `n_tri(INPUTs)` for normal triangle loads
- `rev_tri(INPUTs)` for reversed triangle loads
- `trap(INPUTs)` for trapezoid loads
- `con_f(INPUTs)` for concentrated forces
- `con_m(INPUTs)` for concentrated moments

### Defining Supports

Call the following functions to define supports:
- `fixed(INPUTs)` for fixed supports
- `simple(INPUTs)` for simple supports
- `roller(INPUTs)` for roller supports

Note: `#` indicates a variable explained in the help section of its relevant function.

## Instructions

1. Define the number of planes of loadings in the variable `n_planes`.
2. You can either define `Is#` or omit it as an input for the `Structure_Project` function.
3. If the number of planes is 2, you should define `Is` for correct deflection plots.
4. Define the beam length symbolically, e.g., `"3*L"`.
5. Use the `initial_plot` function to get all required axes as output.
6. Define the supports and loads in both planes.
7. Ensure the supports index increases by 1 after each support declaration.
8. The `org` parameter must be an input to the distributed loads and must be set to true.
9. Define a cell array `Constraints` that holds all the defined supports.
10. Define another cell array `loads` that holds all defined loads.
11. Use the attached method in `Main_Script` to get the variable `fixed_index`.
12. Call the `Structure_Project` function to solve for `Mx`, `My`, `Sx`, `Sy`, `v`, `u`, and unknown reactions.
13. Call `final_plots` to generate the required plots.
