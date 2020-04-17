# Notes: Basys 3 (Digilent board)

Leandro D. Medus  
University of Valencia  
leandro.d.medus@uv.es  
[ April 2020 ]

---

The current document is a compilation of my personal anotations about the board
Bassy 3 of Digilent.

## Table of Content
TBD

### Resources
Digilent reference docs:  
https://reference.digilentinc.com/reference/programmable-logic/basys-3/start  
Basys 3 Reference Manual:  
https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual  
Board constraints:  
https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Basys-3-Master.xdc

**FPGA part Number:**  xc7a35tcpg236-1

## Pre-configuration
First of all, it's mandatory to install the board files or, at least, to download the board constraints. The main difference between these two methods is that with the first one, you will have available during the creation phase of the Vivado project all the board characteristics as default, in the same way as Xilinx boards. If the board files are not included into the Vivado directory, you will have to include the chip part number into the project. Nevertheless, it's mandatory to include the constraints board file to link the top layer component to de actual pins on the board.

For additional information and try a first programming step, follow the tutorial:
https://reference.digilentinc.com/learn/programmable-logic/tutorials/basys-3-programming-guide/start

A more detailed process on how to include the design boards is:  
https://reference.digilentinc.com/vivado/installing-vivado/start#installing_digilent_board_files

## Some additional notes
Each Vivado directory will contain as a standard structure the following directories:
  * src:  to include VHDL, Verilog and C source files
  * scripts: TCL and python files
  * ip: IP cores


## Projects descriptions

### 0_basics_sw_leds
Sample project to test the basic functions of Vivado 2019.1. This project only consists of using switches present on the board to command LEDs.

### 1_basic_tcl_copy

The goal of this stage is to recreate a previously built Vivado project. To achieve this you have to use TCL commands, so after synthesizing the 0_basic_sw_leds project, the following command has to be run:
```tcl
write_project_tcl
```
for more information about the command, execute:
```tcl
write_project_tcl -help
```
it's important to note that if the output directory is not specified, it'll create a file in the current directory where Vivado has been executed. This could be <Path to vivado>/bin/vivado.bat or <Path to vivado>/bin/vivado (depending on the OS).

After this step, Vivado will create a Tcl file as specified, e.g., project.tcl. To create a new project, some things have to be taken into account.
The TCL script has to be modified to meet the new user requirements as project name, location, and files (due to Vivado will use the absolute path to previous files locations).
So:
1. create a new folder for the new project
2. copy src and script folders inside.
3. from TCL console, navigate to the project directory as:  
cd cd <path to project>/basics/1_basic_tcl_copy/
4. Find the line:
```Tcl
# Set the project name  
set _xil_proj_name_ "0_basics_sw_leds_reset"
```
and change project name as required.

5. Replace:
```Tcl
#mod# create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a35tcpg236-1
create_project ${_xil_proj_name_} . -part xc7a35tcpg236-1
```
So Vivado will not create a directory with the porject name

6. Replace
```Tcl
#mod# set files [list \
#mod#  [file normalize "${origin_dir}/../../../../../Repos/FPGA/basys_projects/basics/0_basics_sw_leds/src/top.vhd" ]\
#mod# ]
set files [list \
 [file normalize "${origin_dir}/src/top.vhd" ]\
]
```
7. Replace
```Tcl
# Add/Import constrs file and set constrs file properties
#mod# set file "[file normalize "$origin_dir/../../../../../Repos/FPGA/basys_projects/basics/0_basics_sw_leds/src/Basys-3-Master.xdc"]"
set file "[file normalize "$origin_dir/src/Basys-3-Master.xdc"]"
```

8. Now we are ready to run the script from inside the project directory
```tcl
cd <path>/basics/0_basic_tcl_copy/
vivado -mode batch -source ./scripts/basic_tcl.tcl
```

Another important document to read is:
**Vivado Design Suite Tcl - Command Reference Guide**  
Be careful to use your current Vivado version since small differences could appear.

[TODO]: <> (improve usage of: write_project_tcl and write_bd_tcl)

[TODO]: <> (avoid copy of files from src directory to <project>.srcs/sources_1)


### 2_abacus_demo

This project is based on the Abacus Demo from Digilent Inc for the Basys 3 board. Resources:   
https://reference.digilentinc.com/learn/programmable-logic/tutorials/basys-3-abacus/start

This design includes pushbuttons, LEDs, switches, and seven segments. The main modifications made to this example are the use of a general reset signal, and as a consequence, the word length of each number is 7 bits.

**Description:**
1. Setting Inputs
The abacus can preform 4 arithmetic functions on two 7-bit numbers.  
    * Switches 14-8 represent input A or Number #1.   
    * Switches 6-0 represent input B or Number #2.  
The abacus works by setting the slide switches to your desired operands and then selecting an operation with the buttons.  
The result will be displayed on the 7 segment display.  
On startup, the display will read 0.  

2. Addition - Button Left  
Addition is activated while btn_left_i is pressed. This function uses the formula A + B. The 7-segment display will show the difference and sign until the user releases BTNU. The result will then start to scroll across the display.

2. Subtraction - Button Right  
Subtraction is activated while btn_right_i is pressed. This function uses the formula A - B. The 7-segment display will show the difference and sign until the user releases BTNU. The result will then start to scroll across the display.

3. Multiplication - Button Up
Multiplication is activated while btn_up_i is pressed. This function uses the formula A * B. The 7-segment display will show the product until the user releases BTND. The display will then return to whatever >was last scrolling.

4. Division - Button Down  
Division is activated while btn_down_i is pressed. This function uses the formula A / B. The 7-segment display will show the quotient until the user releases BTNR. The display will then return to whatever was last scrolling.

5. Modulo/Remainder - Button Center  
Modulo is activated while btn_center_i is pressed. This function uses the formula A % B. The 7-segment display will show the remainder until the user releases BTNL. The display will then return to whatever was last scrolling.

**Additional notes:**  
Each button function is associated with specific module development. Also, each module has a testbench.
