/***************************************************************************
* 
* Filename: debounce_top.sv
*
* Author: Seth Campbell
* Description: This sv file is the top level interface to my debouncer
*     and multi-segment display
*
****************************************************************************/

module debounce_top #(
    parameter CLK_FREQUENCY = 100_000_000,
    parameter WAIT_TIME_US = 5000,
    parameter REFRESH_RATE = 200
) (
    input logic clk, btnd, btnc,
    output logic [3:0] anode,
    output logic [7:0] segment
);

logic [1:0] dsync;
logic [1:0] csync;
always_ff @( posedge clk ) begin
    dsync[0] <= btnd;
    dsync[1] <= dsync[0];
end

always_ff @( posedge clk ) begin
    csync[0] <= btnc;
    csync[1] <= csync[0];
end

logic reset;
assign reset = dsync[1];

logic press;
assign press = csync[1];

logic debouncedPress;
debounce #(
    .WAIT_TIME_US(WAIT_TIME_US),
    .CLK_FREQUENCY(CLK_FREQUENCY)
) debouncer (.clk(clk),
    .rst(reset),
    .noisy(press),
    .debounced(debouncedPress));

logic prev;
logic [7:0] debouncedCounter;

always_ff @( posedge clk ) begin
    prev <= debouncedPress;
end

always_ff @( posedge clk ) begin
    if (reset)
        debouncedCounter <= 0;
    else if (debouncedPress && !prev)
        debouncedCounter <= debouncedCounter + 1;
end

logic udPrev;
logic [7:0] undebouncedCounter;

always_ff @( posedge clk ) begin
    udPrev <= press;
end

always_ff @( posedge clk ) begin
    if (reset)
        undebouncedCounter <= 0;
    else if (press && !udPrev)
        undebouncedCounter = undebouncedCounter + 1;
end

logic [3:0] blank;
assign blank = 4'b0000;
logic [3:0] dp;
assign dp = 4'b0100;

seven_segment4 #(
    .CLK_FREQUENCY(CLK_FREQUENCY),
    .REFRESH_RATE(REFRESH_RATE)
) ss (
    .clk(clk),
    .rst(reset),
    .data_in({undebouncedCounter, debouncedCounter}),
    .blank(blank),
    .dp_in(dp),
    .segment(segment),
    .anode(anode)
);

endmodule