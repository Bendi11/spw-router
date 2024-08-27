ifneq (,$(wildcard ./.env))
    include .env
    export
endif

DEVICE := xc7a35tftg256-2
CHIPDB := ./${DEVICE}.bin

XDC := ./src/xc7.xdc
SOURCES := ./src/top.v
BUILD := ./build

.PHONY: build


ACTIVATE_ENV := 
${BUILD}/top.json: ${SOURCES}
	mkdir ${BUILD} && yosys -p "synth_xilinx -flatten -nowidelut -abc9 -arch xc7 -top top; write_json ${BUILD}/top.json" ${SOURCES}

${BUILD}/top.fasm: ${BUILD}/top.json
	"${NEXTPNR_XILINX}/nextpnr-xilinx" --chipdb ${CHIPDB} --xdc ${XDC} --json ${BUILD}/top.json --write ${BUILD}/top-routed.json --fasm ${BUILD}/top.fasm

${BUILD}/top.frames: ${BUILD}/top.fasm
	source "${XRAY_ENV_DIR}/bin/activate" && "${XRAY_UTILS_DIR}/fasm2frames.py" --db-root "${XRAY_DB_DIR}/artix7" --part ${DEVICE} ${BUILD}/top.fasm > ${BUILD}/top.frames 

${BUILD}/top.bit: ${BUILD}/top.frames
	"${XRAY_TOOLS_DIR}/xc7frames2bit" --part-file "${XRAY_DB_DIR}/artix7/${DEVICE}/part.yaml" --part_name ${DEVICE} --frm_file ${BUILD}/top.frames --output_file ${BUILD}/top.bit

build: ${BUILD}/top.bit

clean:
	rm -r ./build
