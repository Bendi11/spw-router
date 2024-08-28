module IBUFDS(input wire I, input wire IB, output wire O);
    import "DPI-C" context function logic do_ibufds(input logic i, input logic ib);

    assign O = do_ibufds(I, IB);
endmodule
