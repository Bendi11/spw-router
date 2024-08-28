# 8 Port SpaceWire Router
A hobby-grade [SpaceWire](https://www.esa.int/Enabling_Support/Space_Engineering_Technology/Onboard_Computers_and_Data_Handling/SpaceWire) router
aiming for full **ECSS-E-ST-50-12C** compliance utilizing a Xilinx Artix 7 FPGA.


## Hardware Development
KiCad schematics and board design files for the board are stored in the `hw/board` directory.
Custom footprints and 3D models are placed into the `hw/models` directory.

## FPGA
Verilog sources are located in the `rtl/src` directory, and both the synthesis and simulation
processes are managed by CMake.

Currently, the FPGA bitstream is generated with a fully open-source
[yosys](https://github.com/YosysHQ/yosys) + [nextpnr-xilinx](https://github.com/gatecat/nextpnr-xilinx) flow,
and does not require the Xilinx Vivado software.
Paths to the required tools must currently be provided in an `env.cmake` file located in the
`rtl/cmake` directory, which must set the following:

| Variable Name | Description |
| :-----------: | ----------- |
| **YOSYS** | Path to the `yosys` binary |
| **NEXTPNR_XILINX** | Path to the `nextpnr-xilinx` binary, usually found at the root of the `nextpnr-xilinx` repository after building |
| **XRAY_DB_DIR** | Path to the Project X-Ray database |
| **XRAY_FASM2FRAMES** | Command to use the `fasm2frames` tool provided in Project X-Ray. This python script may have to run in Project X-Ray's virtual environment, so this variable is typically `"${PRJXRAY_DIR}/env/bin/python3" "${XRAY_DIR}/utils/fasm2frames.py"` |
| **XRAY_XC7FRAMES2BIT** | Path to the Project X-Ray's `xc7frames2bit` binary, usually in `${PRJXRAY_DIR}/build/tools/` |

### Example env.cmake
```cmake
set(NEXTPNR_XILINX_DIR "$ENV{HOME}/nextpnr-xilinx")
set(XRAY_DIR "$ENV{HOME}/prjxray")
set(XRAY_DB_DIR "${NEXTPNR_XILINX_DIR}/xilinx/external/prjxray-db")

set(YOSYS "yosys")
set(NEXTPNR_XILINX "${NEXTPNR_XILINX_DIR}/nextpnr-xilinx")
set(XRAY_FASM2FRAMES "${XRAY_DIR}/env/bin/python3" "${XRAY_DIR}/utils/fasm2frames.py")
set(XC7FRAMES2BIT "${XRAY_DIR}/build/tools/xc7frames2bit")
```


Design verification is performed with [Verilator](https://www.veripool.org/verilator/), with simulation
shims for Xilinx hard IP located in the `rtl/sim/verilog` directory.

## STM32 Software
`TODO`
