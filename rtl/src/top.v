module top 
#(
    parameter COUNT = 8
)
(
    input wire [COUNT-1:0] din_p,
    input wire [COUNT-1:0] din_n,
    input wire [COUNT-1:0] sin_p,
    input wire [COUNT-1:0] sin_n,


    output wire [COUNT-1:0] dout_p,
    output wire [COUNT-1:0] dout_n,
    output wire [COUNT-1:0] sout_p,
    output wire [COUNT-1:0] sout_n
);
    
    wire[COUNT-1:0][7:0] data;

    genvar i;
    
    generate
        for(i=0;i<COUNT;i=i+1)
            begin: port
                channel port(
                    .rx_d_p(din_p[i]),
                    .rx_d_n(din_n[i]),
                    .rx_s_p(sin_p[i]),
                    .rx_s_n(sin_n[i]),
                    .tx_d_p(dout_p[i]),
                    .tx_d_n(dout_n[i]),
                    .tx_s_p(sout_p[i]),
                    .tx_s_n(sout_n[i]),
                    .recv(data[i])
                );
            end
    endgenerate
endmodule
