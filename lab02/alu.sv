`include "riscv_alu_constants.sv"

module alu (
    input logic [31:0] op1, op2,
    input logic [3:0] alu_op,
    output logic zero,
    output logic [31:0] result
);

always_comb begin
    case (alu_op)
        ALUOP_AND: result = op1 & op2;
        ALUOP_OR: result = op1 | op2;
        ALUOP_ADD: result = op1 + op2;
        ALUOP_SUB: result = op1 - op2;
        ALUOP_LT: result = ($signed(op1) < $signed(op2)) ? 32'd1 : 32'd0;
        ALUOP_SRL: result = op1 >> op2[4:0];
        ALUOP_SLL: result = op1 << op2[4:0];
        ALUOP_SRA: result = $unsigned($signed(op1) >>> op2[4:0]);
        ALUOP_XOR: result = op1 ^ op2;
        default: result = op1 + op2;
    endcase
end

assign zero = result ? 0 : 1;

endmodule