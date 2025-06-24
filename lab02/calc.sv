`include "riscv_alu_constants.sv"

module calc #(
    parameter CLK_FREQUENCY = 100_000_000,
    parameter WAIT_TIME_US = 5000
) (
    input logic clk, btnc, btnl, btnu, btnr, btnd,
    input logic [15:0] sw,
    output logic [15:0] led
);

// flip flop synchronization
logic [1:0] usync;
logic [1:0] dsync;
logic reset;
logic press;
always_ff @( posedge clk ) begin
    usync[0] <= btnu;
    usync[1] <= usync[0];
    dsync[0] <= btnd;
    dsync[1] <= dsync[0];
end
assign reset = usync[1];
assign press = dsync[1];

// button debouncing
// logic debouncedPress;
// debounce #(
//     .WAIT_TIME_US(WAIT_TIME_US),
//     .CLK_FREQUENCY(CLK_FREQUENCY)
// ) debouncer (.clk(clk),
//     .rst(reset),
//     .noisy(press),
//     .debounced(debouncedPress));

// one shot debouncing
logic prev;
logic oneshotDebouncedPress;
always_ff @( posedge clk ) begin
    prev <= press;
end
assign oneshotDebouncedPress = press && !prev;

logic [15:0] accumulator;
logic [31:0] op1, op2, result;
logic [3:0] alu_op; // define
logic [2:0] lcr_btns;

assign op1 = {{16{accumulator[15]}}, accumulator};
assign op2 = {{16{sw[15]}}, sw};
assign led = accumulator;
assign lcr_btns[2] = btnl;
assign lcr_btns[1] = btnc;
assign lcr_btns[0] = btnr;

always_ff @( posedge clk ) begin
    if (reset)
        accumulator <= 16'd0;
    else if (oneshotDebouncedPress)
        accumulator <= result[15:0];
end

always_comb begin
    case (lcr_btns)
        0: alu_op = ALUOP_ADD;
        1: alu_op = ALUOP_SUB;
        2: alu_op = ALUOP_AND;
        3: alu_op = ALUOP_OR;
        4: alu_op = ALUOP_XOR;
        5: alu_op = ALUOP_LT;
        6: alu_op = ALUOP_SLL;
        7: alu_op = ALUOP_SRA;
        default: alu_op = ALUOP_ADD;
    endcase
end

alu prc_unit(.op1(op1), .op2(op2), .alu_op(alu_op), .zero(), .result(result));

endmodule