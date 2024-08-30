`default_nettype none

/** Handles parallel to serial conversion of N chars and generates strobe from data and clock */
module port_tx(
    input wire tx_nchar_clk,
    input wire tx_clk,

    output wire data,
    output wire strobe
);
    wire[1:0] tx_pair;

    OSERDESE2
    #(
        .DATA_RATE_OQ("SDR"),
        .DATA_WIDTH(2)
    ) data_gearbox(
        .OQ(data),
        .CLK(tx_clk),
        .CLKDIV(tx_nchar_clk),
        .D1(tx_pair[0]),
        .D2(tx_pair[1]),
        .D3(),
        .D4(),
        .D5(),
        .D6(),
        .D7(),
        .D8()
    );

    wire[1:0] tx_strobe_pair;
    assign tx_strobe_pair[0] = ~tx_pair[0];
    assign tx_strobe_pair[1] = tx_pair[1];

    OSERDESE2
    #(.DATA_RATE_OQ("SDR"), .DATA_WIDTH(2))
    strobe_gearbox(
        .CLK(tx_clk),
        .CLKDIV(tx_nchar_clk),
        .OQ(strobe),
        .D1(tx_strobe_pair[0]),
        .D2(tx_strobe_pair[1]),
        .D3(),
        .D4(),
        .D5(),
        .D6(),
        .D7(),
        .D8()
    );

endmodule
