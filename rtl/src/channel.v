`default_nettype none

module channel(
    input wire rx_d_p,
    input wire rx_d_n,
    input wire rx_s_p,
    input wire rx_s_n,
    output wire tx_d_p,
    output wire tx_d_n,
    output wire tx_s_p,
    output wire tx_s_n,

    output wire[7:0] recv,
    input wire[7:0] txmt,
    input wire tx_clk,
    input wire tx_clk_div
);
    wire rx_strobe;
    wire rx_data;
    wire rx_clk;

    assign rx_clk = rx_data ^ rx_strobe;

    IBUFDS rx_d_ds(
        .I(rx_d_p),
        .IB(rx_d_n),
        .O(rx_data)
    );

    IBUFDS rx_s_ds(
        .I(rx_s_p),
        .IB(rx_s_n),
        .O(rx_strobe)
    );


    ISERDESE2 
    #(.INTERFACE_TYPE("NETWORKING"), .DATA_WIDTH(8))
    rx_gearbox (
        .RST(1'b0),
        .CLK(rx_clk),
        .D(rx_data),

        .Q1(recv[0]),
        .Q2(recv[1]),
        .Q3(recv[2]),
        .Q4(recv[3]),
        .Q5(recv[4]),
        .Q6(recv[5]),
        .Q7(recv[6]),
        .Q8(recv[7])
    );

    
    wire tx_data;
    
    OSERDESE2
    #(.DATA_RATE_OQ("SDR"), .DATA_WIDTH(8))
    tx_data_master(
        .CLK(tx_clk),
        .OQ(tx_data),
        .D1(txmt[0]),
        .D2(txmt[1]),
        .D3(txmt[2]),
        .D4(txmt[3]),
        .D5(txmt[4]),
        .D6(txmt[5]),
        .D7(txmt[6]),
        .D8(txmt[7])
    );

    OBUFDS tx_data_ds (
        .I(tx_data),
        .O(tx_d_p),
        .OB(tx_d_n)
    );

    wire tx_strobe;
    wire[7:0] tx_strobe_parallel;

    genvar i;
    generate
        for(i = 0; i < 8; ++i)
            if(i % 2 == 0)
                assign tx_strobe_parallel[i] = ~txmt[i];
            else
                assign tx_strobe_parallel[i] = txmt[i];
    endgenerate
    

    OSERDESE2
    #(.DATA_RATE_OQ("SDR"), .DATA_WIDTH(8))
    tx_strobe_oserdes(
        .CLK(tx_clk),
        .OQ(tx_strobe),
        .D1(tx_strobe_parallel[0]),
        .D2(tx_strobe_parallel[1]),
        .D3(tx_strobe_parallel[2]),
        .D4(tx_strobe_parallel[3]),
        .D5(tx_strobe_parallel[4]),
        .D6(tx_strobe_parallel[5]),
        .D7(tx_strobe_parallel[6]),
        .D8(tx_strobe_parallel[7])
    );

    OBUFDS tx_strobe_ds (
        .I(tx_strobe),
        .O(tx_s_p),
        .OB(tx_s_n)
    );

endmodule
