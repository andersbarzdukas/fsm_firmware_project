# fsm_firmware_project

The goal of this project is to make a finite state machine that writes and reads data from the BRAM

To get started, please clone the repository using the commands:

```
git clone git@github.com:andersbarzdukas/fsm_firmware_project.git
cd fsm_firmware_project
git branch -b <YOUR NAME>_development
git push -u origin <YOUR NAME>_development
git checkout <YOUR NAME>_development
```
if the checkout option above does not work, please try the following below.

```
git clone https://github.com/andersbarzdukas/fsm_firmware_project.git
```


Now open vivado and please follow the instructions below. These instructions, along with the starter code, should help you create firmware that reads to and writes from a simple single port BRAM.

The rough steps for completing this goal are:
1. Create and buffer all clocks (done for you)
2. Declare and instantiate the BRAM module in this firmware
3. Create a counter that counts from 0 to the depth of the BRAM
4. Create a process controlling a FSM and use the counter and the signals below to control reading and writing to the BRAM
   NOTE: See below for a predefined FSM type you can use
4.b. (optional but recommended) Create a separate counter that controls state transitions in the FSM
5. Run the simulation and examine the behavior noticed by the firmware
5.b. Debug any issues and iteratively improve the firmware
6. (optional but recommended) Try and generate the bistream
7. (extra) Create an ILA to look at the various signals

We will talk about the first part of this project maybe Friday (7/19), but definitely on Tuesday (7/23)
Please try to finish with at least step 5 by that point. Reaching step 6 would be preferred.
For help please see the following resources,
BRAM: https://docs.amd.com/v/u/en-US/ug573-ultrascale-memory-resources
FSM:  https://vhdlwhiz.com/n-process-state-machine/
KCU105: https://www.xilinx.com/content/dam/xilinx/support/documents/boards_and_kits/kcu105/ug917-kcu105-eval-bd.pdf

