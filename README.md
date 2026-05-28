# 🔄 Counter RTL-to-GDSII Physical Design Flow

![OpenLANE](https://img.shields.io/badge/OpenLANE-Flow-blue?style=for-the-badge&logo=git)
![SkyWater130](https://img.shields.io/badge/SkyWater-130nm-green?style=for-the-badge)
![Verilog](https://img.shields.io/badge/Verilog-RTL-purple?style=for-the-badge)

A comprehensive RTL-to-GDSII ASIC design implementation of a digital Counter circuit. This project leverages the open-source **OpenLANE** EDA toolchain and the **SkyWater 130nm (sky130)** Process Design Kit (PDK) to transform behavioral Verilog code into a fully routable, fabrication-ready physical layout.

---

## 🛠️ Tools & Technologies
The automated physical design flow utilizes the following open-source tools integrated within OpenLANE:
* **Yosys:** RTL Synthesis
* **abc:** Technology Mapping
* **OpenROAD:** Floorplanning, Global & Detailed Placement, Clock Tree Synthesis (CTS), and Routing
* **Magic:** VLSI Layout tool for Design Rule Checking (DRC) and GDSII generation
* **Netgen:** Layout vs. Schematic (LVS) verification
* **KLayout:** GDSII visualization
* **OpenSTA:** Static Timing Analysis

---

## 📁 Repository & Run Structure

The physical design artifacts are generated in the `runs/RUN_2026.05.27_14.32.29/` directory, following the standard OpenLANE sequence:

* **`src/` & `counter_project/`**: Contains the source RTL (`counter.v`) and testbench (`tb_counter.v`).
* **`results/`**: Contains the final output files for each stage:
    * `synthesis/`: Synthesized gate-level netlist (`counter.v`).
    * `floorplan/`: Core/die area definitions and initial DEF (`counter.def`).
    * `placement/`: Standard cell placement DEF.
    * `cts/`: Clock tree inserted DEF.
    * `routing/`: Fully routed DEF.
    * `signoff/`: Final physical layouts (`counter.gds`, `counter.mag`, `counter.lef`) and netlists (`counter.spice`).
* **`reports/`**: Contains detailed analytical reports for timing (`rcx_sta`, `syn_sta`), area (`core_area`, `die_area`), power (`power.rpt`), and manufacturability DRC/LVS checks.
* **`logs/`**: Console outputs and execution logs for debugging the TCL flow step-by-step.

---

## 🚀 Physical Design Flow Steps

### 1. Synthesis (`logs/synthesis/`)
The Verilog RTL is synthesized using Yosys. The logic is mapped to the SkyWater 130nm standard cell library (`sky130_fd_sc_hd`).
* *Key Output:* Gate-level netlist.

### 2. Floorplanning & PDN (`logs/floorplan/`)
Defines the physical dimensions of the chip (Die Area) and the area where standard cells are placed (Core Area). The Power Distribution Network (PDN) is generated to route `VPWR` and `VGND` stripes across the chip.
* *Key Reports:* `3-initial_fp_core_area.rpt`, `3-initial_fp_die_area.rpt`

### 3. Placement (`logs/placement/`)
* **Global Placement:** standard cells are roughly placed to minimize wirelength (`7-global.log`).
* **Detailed Placement:** Legalizes cell positions ensuring no overlaps and alignment to site rows (`10-detailed.log`).

### 4. Clock Tree Synthesis (`logs/cts/`)
Inserts clock buffers to build a balanced clock tree, minimizing clock skew and latency across the counter's flip-flops (`12-cts.log`).

### 5. Routing (`logs/routing/`)
* **Global Routing:** Allocates routing tracks and defines generic paths (`19-global.log`).
* **Detailed Routing:** TritonRoute completes the exact metal traces and vias avoiding DRC violations (`23-detailed.log`).

### 6. Signoff (`logs/signoff/`)
The final and most critical stage ensuring manufacturability:
* **DRC (Design Rule Check):** Verified using Magic (`40-drc.log`).
* **LVS (Layout vs Schematic):** Ensuring physical layout matches the synthesized netlist using Netgen (`39-lvs.lef.log`).
* **Parasitic Extraction:** Multi-corner resistance and capacitance extraction for final STA (`25-parasitics_extraction`).

---

## ⚙️ How to Reproduce

1.  Set up the [OpenLANE environment](https://github.com/The-OpenROAD-Project/OpenLane) and pull the SkyWater 130nm PDK.
2.  Clone this repository and place it in the `designs/` folder of your OpenLANE workspace.
3.  Run the automated flow:
    ```bash
    make mount
    ./flow.tcl -design counter_rtl_to_gdsii
    ```
4.  To view the final layout, open the generated GDSII in Magic:
    ```bash
    magic -T sky130A.tech results/signoff/counter.gds
    ```

---
**Author:** Daksh Lohchab
