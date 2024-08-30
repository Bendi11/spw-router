module IBUFDS(input wire I, input wire IB, output wire O);
    assign O = I > IB;
endmodule
