module top (input clk_i, output led);

    wire clk;
    BUFGCTRL bufg_i (
        .I0(clk_i),
        .CE0(1'b1),
        .S0(1'b1),
        .O(clk)
    );


    assign led = clk_i;

endmodule
