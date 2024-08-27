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
    input wire[7:0] txmt
);
    wire strobe;
    wire data;
    wire clk;

    assign clk = data ^ strobe;

    wire strobe_shift1;
    wire strobe_shift2;
    ISERDESE2
    #(.INTERFACE_TYPE("NETWORKING"), .SERDES_MODE("MASTER"), .DATA_WIDTH(1))
    strobe_master (
        .D(rx_s_p),
        .O(strobe),

        .SHIFTOUT1(strobe_shift1),
        .SHIFTOUT2(strobe_shift2)
    );

    ISERDES2
    #(.INTERFACE_TYPE("NETWORKING"), .SERDES_MODE("SLAVE"), .DATA_WIDTH(1))
    strobe_slave(
        .D(rx_s_n),
        .SHIFTIN1(strobe_shift1),
        .SHIFTIN2(strobe_shift2)
    );

    wire data_shift1;
    wire data_shift2;

    ISERDESE2 
    #(.INTERFACE_TYPE("NETWORKING"), .SERDES_MODE("MASTER"), .DATA_WIDTH(8))
    data_master (
        .O(data),
        .RST(1'b0),
        .CLK(clk),
        .CLKB(clk),
        .D(rx_d_p),

        .Q1(recv[0]),
        .Q2(recv[1]),
        .Q3(recv[2]),
        .Q4(recv[3]),
        .Q5(recv[4]),
        .Q6(recv[5]),
        .Q7(recv[6]),
        .Q8(recv[7]),

        .SHIFTOUT1(data_shift1),
        .SHIFTOUT2(data_shift2)
    );

    ISERDESE2
    #(.INTERFACE_TYPE("NETWORKING"), .SERDES_MODE("SLAVE"), .DATA_WIDTH(8))
    data_slave (
        .RST(1'b0),
        .D(rx_d_n),
        .SHIFTIN1(data_shift1),
        .SHIFTIN2(data_shift2),
    );
endmodule
