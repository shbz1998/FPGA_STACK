# FPGA_STACK

VIDEO DEMO: https://www.youtube.com/watch?v=-G99Bz0NTF0

This is a STACK implementation on FPGA. 
The main idea is to visualize the process and implementaition of STACK through LEDs.
The user will first press push button 0 to capture the value. A deboeuncer is used to only accept one input per button push. The user will then 
press the push button 1 to pop the most recent value on top of the stack and display it on the 4 LEDs.

When the stack is empty RGB LED is be off. When the stack is 25% full the RGB is Green. When the stack is 75% full the RGB is Blue. 
When the stack is full the RGB LED is RED.
