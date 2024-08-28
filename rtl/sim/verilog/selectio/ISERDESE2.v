module ISERDESE2
#(
    parameter INTERFACE_TYPE="NETWORKING",
    parameter DATA_WIDTH=8
)
(
    input wire RST,
    input wire CLK,
    input wire D,
    output wire Q1,
    output wire Q2,
    output wire Q3,
    output wire Q4,
    output wire Q5,
    output wire Q6,
    output wire Q7,
    output wire Q8
);
    reg q[7:0];
    assign Q1 = q[0];
    assign Q2 = q[1];
    assign Q3 = q[2];
    assign Q4 = q[3];
    assign Q5 = q[4];
    assign Q6 = q[5];
    assign Q7 = q[6];
    assign Q8 = q[7];

    
    always @(posedge CLK) begin
        q[7:1] = q[6:0];
        q[0] = D;
    end

endmodule
