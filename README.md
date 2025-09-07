# Project Overview

Welcome to the Digital Design Team of SiliconJackets!

For your onboarding project, you'll design a SystemVerilog calculator that performs 64-bit unsigned integer addition by combining two 32-bit sums. This project introduces you to logic design, RTL coding, FSM-based control, and functional verification. You'll also familiarize yourself with our tools and team workflows. If you get stuck or need clarification, don’t hesitate to ask questions!

---

## Requirements

You will build a 64-bit calculator system using three key modules:
- **adder32.sv** – adds two 32-bit values
- **result_buffer.sv** – stores results in a 64-bit register (upper/lower controlled by a select signal)
- **controller.sv** – manages reads, writes, adder operation, and sequencing via an FSM
- **top_lvl.sv** - serves as the top level chip file
- There are also other files which you **do not** need to edit, but a description can be found at the top to help you understand their function. 

Your task is to implement each module with correct input/output handling, FSM-based control, and memory-mapped behavior. The adder ignores overflow. There are specific //TODO: comments in the code with hints on what to do. Although you are welcome to make changes if the behavior of the system remains the same.  

<img width="961" alt="image" src="https://github.gatech.edu/SiliconJackets/New_DD_Onboarding/assets/79717/b87ddf76-0116-456c-a882-fa342e39dc18">


---

## Deliverables

### 0. Reference Materials (Optional – read as needed)

- **[Verilog basics](https://nandland.com/introduction-to-verilog-for-beginners-with-code-examples/)**
- **[SystemVerilog basics](https://www.chipverify.com/tutorials/systemverilog)**
- **[Practice problems](https://hdlbits.01xz.net/wiki/Problem_sets)**  
  > Note: HDLBits uses Verilog (`wire`, `reg`). In SystemVerilog, use `logic` instead.
- **SystemVerilog vs. Verilog:** SystemVerilog uses `logic` (a unified type) instead of Verilog’s `wire` and `reg`.
- **Writing a state machine with SystemVerilog** [refmaterials/1_fsm_in_systemVerilog.pdf](refmaterials/1_fsm_in_systemVerilog.pdf)
- **[SystemVerilog Generate](https://www.chipverify.com/verilog/verilog-generate-block)** You will want to use a "generate for loop" to create your adder. 
- **[SystemVerilog Spec (Advanced/Optional)](https://rfsoc.mit.edu/6S965/_static/F24/documentation/1800-2017.pdf)**

---

### 1. Adder Module (adder32.sv)  
Build a 32-bit addition module. Requirements:
- Compute sum of two 32-bit unsigned integers
- Output the 32-bit result
- Use the generate function to create 32 1-bit adders
- Reference: https://www.chipverify.com/verilog/verilog-generate-block 

---

### 2. Result Buffer (result_buffer.sv)
Create a buffer module that:
- Stores a 64-bit result
- Accepts a 32-bit result input
- Uses a 1-bit control signal to place the 32-bit input in either the upper or lower half of the 64-bit buffer
- Resets synchronously

---

### 3. FSM Diagram
Create a finite state machine (FSM) diagram for your **controller** module.  

---

### 4. Controller Module (controller.sv)
Implement a finite state machine (FSM) that:
- Begins computation on reset release
- Reads the memory for 2, 32-bit operands
- Sends the operands to the adder to be written to the result buffer
- Writes to the memory from the result buffer once a full, 64-bit value is created from the data from 2 sequential memory addresses
- Computes this addition sequence through the entire range of read and write addresses. Start at the start read/write address and increment.
  > Write address range will equal 1/2 of the read address range
- Your controller should read/write data on the SRAM module as shown on the functional block diagram 

This module manages all coordination among memory, the adder, and the result buffer.  

---

### 5. Chip Top (top_lvl.sv)
- The purpose of this file is to connect everything together. Your task is to use your understanding of surrounding declarations to "fill in the blank" 
- Your task is to connect the SRAM to the file itself. The wireframe already exists, but you should connect it to your logic in the top_lvl.sv file.
- EDIT 8/29: minor updates to comments in this file. 
- Optional: To understand how the SRAM macro timing works, use this link
- https://github.com/ShonTaware/SRAM_SKY130?tab=readme-ov-file#sram-memory-architecture
- https://github.com/VLSIDA/OpenRAM/blob/stable/docs/source/control_logic.md

---  

### 6. Coding Guidelines
- Use `always_comb` and `always_ff` appropriately
- Use **blocking (`=`)** for combinational logic and **non-blocking (`<=`)** for sequential logic
- Avoid `%` or other expensive arithmetic unless explicitly allowed

---

### 7. Testing Your Design
Your design is tested using a module commonly called a testbench. This is found in `src/verilog/tb_calculator.sv`. In this file, your top-level module is instantiated and its ports are provided stimulus by the testbench. `initial` blocks tell the simulation tool where to begin the simulation and the code inside controls the simulation. A `task` is a callable function-like construct which you can use to define test cases. You are not required to modify this testbench, the provided test is sufficient for this project. Importantly, this testbench writes the initial memory contents from two .txt files which are generated by `scripts/init_mem.py`. We reccomend using `make verify_onboarding` to test your project, which runs the script to generate the intial memory contents for you.

---

### 8. Results Report (PDF)
Create a PDF containing:
- Waveform screenshot(s) showing module behavior and outputs
- 1–2 paragraph explanation of the waveform behavior and why it's correct

---

### 9. Final Check-in
Meet briefly with team leads before the onboarding deadline to conduct a quick review of your RTL for synthesizability.

---

## Getting Started

1. Sign the EULA agreement for Cadence tools (https://eulas.ece.gatech.edu/cadence/)
    - Under Primary GT Affiliation -> Select "Researcher or Staff"
    - Your Title: "Student"
    - ECE Faculty Advisor / Professor Name : "Visvesh S Sathe"
    - ECE Faculty Advisor / Professor Email: "sathe@gatech.edu"
    - Software needed for -> "Research"
    - Research Project Name : "SiliconJackets"
    - Agree to Cadence agreement
2. Download Georgia Tech VPN (https://vpn.gatech.edu/global-protect/getsoftwarepage.esp)
3. Log into the GlobalProtect VPN once downloaded(portal: vpn.gatech.edu)  
    - use your school username and password
    - 'push1' sends a push to DUO, 'phone1' gives you an automated phone call
4. Download FastX or MobaXterm (or your preferred remote Terminal Emulator)
    - FastX ([https://software.oit.gatech.edu/request.php?package=FastX3_Client](https://starnet.com/download/fastx-client))
    - MobaXterm (https://mobaxterm.mobatek.net/download-home-edition.html)
5. Log in remotely to linlab server
    - The setup will be similar but different depending on the terminal emulator you choose
    - The following instructions work for FastX, but ask if you need help setting up with MobaXterm
    - Ensure you are connected to GT VPN
    - Open FastX Client
    - File->Connections. Click the plus sign to add a connection.
    - Host:  ece-rschsrv.ece.gatech.edu
        - if that doesn't work try ece-linlabsrv01.ece.gatech.edu
    - Username: <your_GT_username>
    - Port: 22
    - Name: Whatever you want to call the connection
    - Here is an example of what your screen should look like:
    - ![image](./screenshots/fastxSetup1.png)
    - Connect to the session and type in your GT password at the prompt
    - Click the plus sign and then "xterm"
    - ![image](./screenshots/fastxSetup2.png)
    - You should now be remotely connected to the linlab terminal 
    - ![image](./screenshots/fastxSetup3.png)
  
6. run the tcsh command to switch to t-shell. This command needs to be run every time you log into the server. You will know you are in t-shell if your shell prompt does not have a $ at the end.
7. Add the following line to your ~/.my-cshrc file: source /tools/software/cadence/setup.csh. This will allow you to run the commands for cadence tools if you have gotten your EULA approved. (your ~/.my-cshrc file might be empty up until now, so just make this the first line). This is how you can do this: return to your home directory by running "cd ~". Then, do `nano ~/.my-cshrc` to enter the config file. Copy the line provided into it, then hit ctrl + the letter "o", then hit enter to save. Then hit ctrl + x to quit. To apply the changes, type "source ~/.my-cshrc". Now, typing xrun should not show an error. 
9. Clone this repo into the linux server. This is done using git clone url <--replace url with github-provided url. You might be prompted to input your username and password for git. 
10. At this point, you can write your code in the files within the src folder. 
11. To see your waveforms, change directory into sim/behav and first run the command __make link__ . This creates a symbolic link for all your design files in the simulation directory. If you are unfamiliar with the linux terminal, read this [article](https://www.hostinger.com/tutorials/linux-commands?utm_campaign=Generic-Tutorials-DSA|NT:SE|LO:USA&utm_medium=ppc&gad_source=1&gad_campaignid=20027522868&gbraid=0AAAAADMy-hYjLhKiHPvplnMB_BIAldozR&gclid=Cj0KCQjwzaXFBhDlARIsAFPv-u-bnckMRN43R_4lbPDlpdZdL66msX8hXGlCMpWa6KpdSEYULiDg-bcaAh0mEALw_wcB).
12. Run the command `make xrun`. This runs the simulation tool. It "compiles" your verilog, checks for errors, and runs the simulation. This might take a second. 
13. Run the command `make simvision`. This opens the waveform viewer. 
14. Once the GUI has popped up, you should be able to drag the module into variable section, whereby the signals will appear on the right.

---

## DELIVERABLES, More Succinctly

**a.** A working adder, top_lvl, buffer, and controller module (all pass simulation and testbench)

**b.** A brief writeup (.pdf) to help you explain to us why your implmentation is correct. It should contain:
- Simulation passing screenshots from `make verify_onboarding`
- Waveforms displaying your project's behavior
- An explanation of correctness

---

## Directory Overview

Here's what's going on in this onboarding project's directory:

### `refmaterials/`
Helpful reading about FSMs and SystemVerilog syntax

### `scripts/`
Contains a Python scripts for verifying your project

### `src/`
Your Verilog source files

#### `src/Makefiles/`
Automation for building your simulation

#### `src/verilog/`
Write your modules here (adder, controller, result buffer)

##### `src/verilog/calculator.include`
Used to tell VCS which files to compile

##### `src/verilog/tb_*.sv`
Testbenches for your modules

### `sim/`
Run your simulations here

### `sim/behav/`
Behavioral simulation (run `make` or `make xrun` here to simulate your design)


---
## State Machine Description 
> Note: You do not have to strictly follow this. We will check the final memory contents for correctness. You must complete a design that fulfills the functional requirements.

Idle:   
<img width="600" alt="image" src="https://github.gatech.edu/user-attachments/assets/c8073db9-916e-4d88-83a9-77680c971a02" />  

Read:   
<img width="600" alt="image" src="https://github.gatech.edu/user-attachments/assets/91edc29c-49cf-4524-aeff-f8598cf49dbc" />  

Add:   
<img width="600" alt="image" src="https://github.gatech.edu/user-attachments/assets/8fc7a433-3707-4a22-bd7c-672796c8d978" />  

Write:  
<img width="600" alt="image" src="https://github.gatech.edu/user-attachments/assets/b79e532a-c3bc-4df1-b043-860918c946ba" /> 

End:   
<img width="600" alt="image" src="https://github.gatech.edu/user-attachments/assets/24e5a289-0eb7-4b42-abdb-e61db6eaad9d" />  








---

## Tips for Waveform viewers

1. Add signals to the waveform window
2. Click-drag timeline to zoom in/out
3. Right-click a signal to "Set Radix" (e.g., binary, hex, decimal)

## Code Linting Guide
[Verilator Linting Guide](https://gtvault.sharepoint.com/:w:/s/SiliconJackets/EW0qm5W59tdKj9TpwMpdu2YBIAYuL4C1B1nUTCNmcCsSIw?e=c1aNhq)

## An RTL/Verilog Textbook
[RTL Modeling with SystemVerilog for Simulation and Synthesis using SystemVerilog for ASIC and FPGA design](https://gtvault.sharepoint.com/:b:/s/SiliconJackets/EbxCET5NlPtMu3aUb6LRpQ8BvPQVkJjA3sXMsZEofq5taQ?e=7JvuNE)
