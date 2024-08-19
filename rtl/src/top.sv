module top();
    input clk;
    output out;

    always @(posedge clk)
    begin
        out <= clk;
    end

endmodule
