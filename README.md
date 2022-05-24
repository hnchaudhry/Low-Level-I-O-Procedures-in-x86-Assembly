# Low-Level-IO-Procedures-in-x86-Assembly
This is a project that was completed as part of a course in computer architecture and assembly language for my undergraduate CS degree. The purpose of the project was to design, implement, and call low-level I/O procedures as well as implement and use macros in x86 assembly using Microsoft Macro Assembler and the Irvine library.

## Description of the Program
When the program runs, it does the following:

1. Gets 10 valid integers from the user.
2. Stores the user entered integers in an array.
3. Displays the integers entered, the sum of the integers, and their truncated average.

## Requirements
The following program requirements dictated the design decisions made with implementing procedures and macros for the program:

1. User input validation shall be done by reading the input as a string and converting it to numeric form. If the input was too large to fit in a 32-bit register or it contained non-digits other than that which tells the sign ('+'/'-'), then an error shall be displayed and the user reprompted for input. If the user does not enter anything, an error message will be displayed and the user will be prompted for input again.
2. All conversion routines must use LODSB or STOSB string processing operators.
3. All procedure parameters must be passed to the runtime stack using STDCALL convention. In addition, all strings must be passed by reference.
4. Used registers must be saved and restored by calling procedures and macros.
5. The stack must be cleaned up by the called procedure.
6. No procedure, except the main procedure, may reference global variables in the data segment by name. Only properly defined constants may be referenced by name.
7. The program must use register indirect addressing for integer array elements and base+offset addressing for accessing parameters on the stack.

## Example Ouput
![Example Output](https://user-images.githubusercontent.com/13329400/170118599-4b279479-c107-4ac0-8a4d-9c8e0b874320.jpg)
