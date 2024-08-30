`default_nettype none

module port(
    input wire rx_d_p,
    input wire rx_d_n,
    input wire rx_s_p,
    input wire rx_s_n,
    output wire tx_d_p,
    output wire tx_d_n,
    output wire tx_s_p,
    output wire tx_s_n,

    input wire tx_clk
);
    wire rx_d;
    wire rx_s;

    IBUFDS rx_data(
        .I(rx_d_p),
        .IB(rx_d_n),
        .O(rx_d)
    );

    IBUFDS rx_strobe(
        .I(rx_s_p),
        .IB(rx_s_n),
        .O(rx_s)
    );

    port_rx decode(
        .data(rx_d),
        .strobe(rx_s),
        .character(),
        .control()
    );

    wire tx_d;
    wire tx_s;

    OBUFDS tx_data(
        .I(tx_d),
        .O(tx_d_p),
        .OB(tx_d_n)
    );

    OBUFDS tx_strobe(
        .I(tx_s),
        .O(tx_s_p),
        .OB(tx_s_n)
    );

    port_tx encode(
        .data(tx_d),
        .strobe(tx_s),
        .tx_clk(tx_clk),
        .tx_nchar_clk()
    );

endmodule
