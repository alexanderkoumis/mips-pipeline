module clk_gen(
        input clk50MHz,
        input reset,
        output reg clksec
);

    reg clk_5KHz;
    integer count;
    integer count1;
  
    always@(posedge clk50MHz) begin
        if (reset) begin
            count = 0;
            count1 = 0;
            clksec = 0;
            clk_5KHz =0;
        end else begin
            if (count == 50000000) begin
                // Just toggle after certain number of seconds
                clksec = ~clksec;
                count = 0;
            end
        end
        if (count1 == 20000) begin
            clk_5KHz = ~clk_5KHz;
            count1 = 0;
        end
        count = count + 1;
        count1 = count1 + 1;
    end

endmodule