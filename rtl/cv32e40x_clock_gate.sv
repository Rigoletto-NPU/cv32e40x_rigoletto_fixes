// Copyright (c) 2026
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// CV32E40X clock gate stub.
//
// Clock gating is disabled in this fork: the core always runs on clk_i so the
// scalar pipeline shares the same global clock tree as tightly-coupled logic
// (e.g. Vicuna v_core). WFI / core_sleep_o semantics are unchanged; only dynamic
// clock gating is removed.

module cv32e40x_clock_gate #(
  parameter int unsigned LIB = 0
) (
  input  logic clk_i,
  input  logic en_i,
  input  logic scan_cg_en_i,
  output logic clk_o
);

  assign clk_o = clk_i;

endmodule
