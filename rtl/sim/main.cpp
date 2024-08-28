#include "Vchannel.h"
#include <memory>

int main(int const argc, char const *argv[]) {
    std::unique_ptr<VerilatedContext> ctx{new VerilatedContext};
    ctx->commandArgs(argc, argv);
    std::unique_ptr<Vchannel> top{new Vchannel{ctx.get()}};

    while(!ctx->gotFinish()) {
        top->eval();
    }

    return 0;
}
