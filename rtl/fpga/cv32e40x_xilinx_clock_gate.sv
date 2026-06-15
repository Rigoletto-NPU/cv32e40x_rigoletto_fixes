// Copyright 2025 Maximilian Kirschner
// Licensed under the Solderpad Hardware License v2.1. See LICENSE file in the project root for details.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// FPGA clock gate for CV32E40X using a BUFHCE (local horizontal clock buffer).
// Each worker core instantiates its own gate, so BUFHCE is preferred over the
// scarce global BUFGCE resources.

module cv32e40x_clock_gate #(
    parameter LIB = 0
) (
    input  logic clk_i,
    input  logic en_i,
    input  logic scan_cg_en_i,
    output logic clk_o
);

  logic clk_en;

  // Latch enable while clk_i is low for glitch-free gating (same semantics as the
  // simulation model and a typical integrated clock-gating cell).
  always_latch begin
    if (clk_i == 1'b0) begin
      clk_en = en_i | scan_cg_en_i;
    end
  end

  BUFHCE u_bufhce (
      .I (clk_i),
      .CE(clk_en),
      .O (clk_o)
  );

endmodule
