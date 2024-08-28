#include "svdpi.h"
#include "verilated_dpi.h"

extern "C" svLogic do_ibufds(svLogic i, svLogic ib) {
    return i > ib ? sv_1 : sv_0;
}
