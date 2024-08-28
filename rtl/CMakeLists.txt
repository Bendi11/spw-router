cmake_minimum_required(VERSION 3.20)

project(spw-router)
option(VERILATE "Enable verilator simulator" ON)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/env.cmake")

file(
    GLOB_RECURSE
    VERILOG_SRC
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.v"
)

set(
    XDC "${CMAKE_CURRENT_SOURCE_DIR}/src/xc7.xdc"
)

set(DEVICE "xc7a35tftg256-2")
set(CHIPDB "${CMAKE_CURRENT_SOURCE_DIR}/${DEVICE}.bin")

add_custom_command(
    OUTPUT top.json
    DEPENDS ${VERILOG_SRC}
    COMMAND yosys -p
        "synth_xilinx -flatten -nowidelut -abc9 -arch xc7 -top top; write_json top.json"
        ${VERILOG_SRC}
    VERBATIM
)

add_custom_command(
    OUTPUT top.fasm
    DEPENDS top.json ${XDC}
    COMMAND ${NEXTPNR_XILINX}
        --chipdb ${CHIPDB}
        --xdc ${XDC}
        --json top.json
        --write top-routed.json
        --fasm top.fasm
    BYPRODUCTS top-routed.json
    VERBATIM
)

add_custom_command(
    OUTPUT top.frames
    DEPENDS top.fasm
    COMMAND ${XRAY_FASM2FRAMES}
        --db-root "${XRAY_DB_DIR}/artix7"
        --part ${DEVICE}
        top.fasm > top.frames
    VERBATIM
)

add_custom_command(
    OUTPUT top.bit
    DEPENDS top.frames
    COMMAND ${XC7FRAMES2BIT}
        --part-file "${XRAY_DB_DIR}/artix7/${DEVICE}/part.yaml"
        --part_name ${DEVICE}
        --frm_file top.frames
        --output_file top.bit
    VERBATIM
)


add_custom_target(
    bitstream ALL
    DEPENDS top.bit
)

if(${VERILATE})
    set(SIM_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/sim")

    file(
        GLOB_RECURSE
        SIMULATOR_SRC
        "${SIM_SRC_DIR}/*.cpp"
        "${SIM_SRC_DIR}/verilog/*.cpp"
    )

    file(
        GLOB_RECURSE
        SIMULATOR_VERILOG_SRC
        "${SIM_SRC_DIR}/verilog/*.v"
    )
    
    find_package(verilator REQUIRED HINTS $ENV{VERILATOR_ROOT})
    
    add_executable(spw-sim ${SIMULATOR_SRC})
    verilate(
        spw-sim
        SOURCES ${VERILOG_SRC} ${SIMULATOR_VERILOG_SRC}
        TOP_MODULE top
    )
endif()
