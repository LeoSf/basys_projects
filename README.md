# Notes: Basys 3 (Digilent board)

Leandro D. Medus  
University of Valencia  
leandro.d.medus@uv.es

---

The current document is a compilation of my personal anotations about the board
Bassy 3 of Digilent.

## Table of Content
TBD

### Resources
[Material de referencia de Digilent]
(https://reference.digilentinc.com/reference/programmable-logic/basys-3/start)  
[Basys 3 Reference Manual]
(https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual)

[Board constraints]
(https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Basys-3-Master.xdc)



## Pre-configuration
First of all, it's mandatory to install the board files or, at least, to download the board constraints. The main difference between these two methods is that with the first one, you will have available during the creation phase of the Vivado project all the board characteristics as default, in the same way as Xilinx boards. If the board files are not included into the Vivado directory, you will have to include the chip part number into the project. Nevertheless, it's mandatory to include the constraints board file to link the top layer component to de actual pins on the board.

## Some additional notes
Each Vivado directory will contain as a standard structure the following directories:
  * src:  to include VHDL, Verilog and C source files
  * scripts: TCL and python files
  * ip: IP cores


## Projects descriptions

### 0_basics_sw_leds
Sample project to test the basic functions of Vivado 2019.1. This project only consists of using switches present on the board to command LEDs.
