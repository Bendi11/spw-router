`default_nettype none

/* Serial to parallel conversion and clock recovering from data and strobe */
module port_rx(
    input wire data,
    input wire strobe,

    output wire[1:0] control,
    output wire[7:0] character
);
    wire clk;
    assign clk = data ^ strobe;

    reg recv_control;
    reg recv_data;
    reg[7:0] recv_data_word;

    wire[1:0] rx_block;

    ISERDESE2
    #(
        .INTERFACE_TYPE("NETWORKING"),
        .DATA_WIDTH(8)
    )
    gearbox (
        .RST(1'b0),
        .CLK(clk),
        .D(data),

        .Q1(rx_block[0]),
        .Q2(rx_block[1]),
        .Q3(),
        .Q4(),
        .Q5(),
        .Q6(),
        .Q7(),
        .Q8()
    );

    always @(posedge clk) begin
        case({recv_control, recv_data})
            2'b01:
                recv_data_word[{rx_block, 1'b0}] = 0;
            default:
                if(rx_block[0] == 1'b1)
                    recv_control = 1;
                else
                    recv_control = 1;
        endcase
    end

endmodule
