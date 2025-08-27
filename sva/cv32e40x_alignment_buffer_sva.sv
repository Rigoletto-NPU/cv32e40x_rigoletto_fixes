// Copyright 2018 ETH Zurich and University of Bologna.
// Licensed under the Solderpad Hardware License, Version 0.51.
// SPDX-License-Identifier: SHL-0.51

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Authors:        Pasquale Davide Schiavone - pschiavo@iis.ee.ethz.ch        //
//                 Igor Loi - igor.loi@greenwaves-technologies.com            //
//                 Øystein Knauserud - oystein.knauserud@silabs.com           //
//                 Halfdan Bechmann - halfdan.bechmann@silabs.com             //
//                                                                            //
// Description:    RTL assertions for the alignment_buffer module             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

module cv32e40x_alignment_buffer_sva
  import cv32e40x_pkg::*;
  (
   input logic                     clk,
   input logic                     rst_n,
   input logic [0:2]               valid_q,
   input ctrl_fsm_t                ctrl_fsm_i,
   input logic [31:0]              branch_addr_i,
   input logic                     fetch_branch_o,
   input logic [31:0]              fetch_branch_addr_o,
   input logic                     fetch_valid_o,
   input logic                     fetch_ready_i,
   input logic [2:0]               instr_cnt_n,
   input logic [2:0]               instr_cnt_q,
   input logic                     instr_valid_o,
   input logic [31:0]              instr_addr_o,
   input logic                     resp_valid_i,
   input logic                     resp_valid_gated,
   input logic [1:0]               outstanding_cnt_q,
   input logic [1:0]               n_flush_q,
   input inst_resp_t               resp_i,
   input logic [1:0]               wptr,
   input logic [1:0]               rptr,
   input logic [1:0]               rptr2,
   input logic                     pop_q
  );

  logic branch_check;
  logic expect_response;
  assign expect_response = (instr_cnt_q == 'd0 && outstanding_cnt_q == 'd1) ||
                           (instr_cnt_q == 'd0 && outstanding_cnt_q == 'd2) ||
                           (instr_cnt_q == 'd1 && outstanding_cnt_q == 'd1) ||
                           (instr_cnt_q == 'd2 && outstanding_cnt_q == 'd1);

  // Capture branch address
  logic [31:0] next_branch_addr;
  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      next_branch_addr <= 32'd0;
    end else if (ctrl_fsm_i.pc_set) begin
      next_branch_addr <= branch_addr_i;
    end
  end
endmodule // cv32e40x_alignment_buffer_sva

