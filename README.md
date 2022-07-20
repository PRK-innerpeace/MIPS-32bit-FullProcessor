# Project language 
Verilog

# IDE
Quartus-lite-16.0.0.211

# Introduction
In this project , I have  designed a single cycle 32-bit processor using Verilog.
Skeleton module includes the top-level entity (“skeleton”), processor (“processor”), data memory (“dmem”), instruction memory (“imem”), and regfile (‘regfile”).

 My design:

-   Integrates register file and ALU units
-   Properly generates the dmem and imem files by generating Quartus syncram components

Specifically, implement **_R-type and I-type_** instructions: **_add, addi, sub, and, or, sll, sra, sw, lw_**.
and implement **_J-type_** instructions based on my [first RI type simple processor](https://github.com/PRK-innerpeace/MIPS-32bit-processor-R-and-I-type).

# Module Interface
 **The skeleton is the top-level module** and it allows for integrating all of your required components together. Please double-check your code compiles with the skeleton set as the top level entity before submission.

# Other Specifications


This processor design operate correctly with a **50 MHz** **clock**. You may use **clock dividers (see [here for background](http://referencedesigner.com/tutorials/verilogexamples/verilog_ex_02.php)**) as needed for your processor to function correctly. When setting up your project in Quartus, be sure to pick the correct device (check the recitation if you are unsure).

## Memory rules:

	 Memory is word-addressed (32-bits per read/write)
	 Instruction (imem) and data memory (dmem) are separate
	 Static data begins at data memory address 0
	 Stack data begins at data memory address 2^16-1 and grows downward

After a reset, all register values should be 0 and program execution begins from instruction memory address 0. Instruction and data memory is not reset. 

## Register Naming

We use two conventions for naming registers:

-   $i or $ri, e.g. $r23 or $23; this refers to the same register, i.e. register 23

## Special Registers

-   $r0 should always be zero

-   Protip: make sure your bypass logic handles this

-   $r30 is the status register, also called $rstatus

-   It may be set and overwritten like a normal register; however, as indicated in the ISA, it can also be set when certain exceptions occur
-   **Exceptions take precedent** when writing to $r30

-   $r31 or $ra; is the return address register, used during a jal instruction

-   It may also be set and overwritten like normal register

# ISA
<img width="708" alt="image" src="https://user-images.githubusercontent.com/67783915/180016499-ab31c280-54c6-4e9f-a14b-2acc53084eed.png">
# Instruction Machine Code Format
<img width="470" alt="image" src="https://user-images.githubusercontent.com/67783915/180016659-f582d5c2-0081-41f9-98b3-6c459d5bb424.png">

