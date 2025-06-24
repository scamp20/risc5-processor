/***************************************************************************
* 
* Filename: debounce.sv
*
* Author: Seth Campbell
* Description: This sv module uses delay time to debounce inputs
*
****************************************************************************/

module debounce #(
    parameter WAIT_TIME_US = 5000,
    parameter CLK_FREQUENCY = 100_000_000
) (
    input logic clk, rst, noisy,
    output logic debounced
);

localparam TIMER_CLOCK_COUNT = (CLK_FREQUENCY / 1_000_000) * WAIT_TIME_US;
localparam COUNTER_WIDTH = $clog2(TIMER_CLOCK_COUNT);
logic [COUNTER_WIDTH-1:0] delayCounter;

logic clrTimer;
logic timerDone;
typedef enum logic [1:0] {
    s0, 
    s1, 
    s2, 
    s3
} EnumName;
EnumName state;

always_ff @( posedge clk ) begin
    if (clrTimer)
        delayCounter <= 0;
    else if (delayCounter == TIMER_CLOCK_COUNT-1)
        delayCounter <= 0;
    else
        delayCounter <= delayCounter + 1;
end

always_ff @( posedge clk ) begin
    if (rst)
        state <= s0;
    else if (state == s0 && noisy)
        state <= s1;
    else if (state == s0 && !noisy)
        state <= s0;
    else if (state == s1 && !noisy)
        state <= s0;
    else if (state == s1 && noisy && !timerDone)
        state <= s1;
    else if (state == s1 && noisy && timerDone)
        state <= s2;
    else if (state == s2 && noisy)
        state <= s2;
    else if (state == s2 && !noisy)
        state <= s3;
    else if (state == s3 && noisy)
        state <= s2;
    else if (state == s3 && !noisy && !timerDone)
        state <= s3;
    else if (state == s3 && !noisy && timerDone)
        state <= s0;
end

assign clrTimer = state == s0 || state == s2 ? 1 : 0;
assign debounced = state == s2 || state == s3 ? 1 : 0;
assign timerDone = delayCounter == TIMER_CLOCK_COUNT-1 ? 1 : 0;

endmodule