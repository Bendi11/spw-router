module OBUFDS(input wire I, output wire O, output wire OB);
    assign O = I;
    assign OB = ~I;
endmodule
