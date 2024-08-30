#include "VerilogSim.h"
#include "vpi_user.h"
#include <bitset>
#include <cassert>
#include <memory>

int main(int const argc, char const *argv[]) {
    std::unique_ptr<VerilatedContext> ctx{new VerilatedContext};
    ctx->commandArgs(argc, argv);
    std::unique_ptr<VerilogSim> top{new VerilogSim{ctx.get()}};
    while(!ctx->gotFinish()) {
        top->eval();
    }

    return 0;
}
