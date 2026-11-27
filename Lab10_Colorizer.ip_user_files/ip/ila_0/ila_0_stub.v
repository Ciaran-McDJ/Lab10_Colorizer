// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1.2 (win64) Build 5164865 Thu Sep  5 14:37:11 MDT 2024
// Date        : Fri Nov 27 16:06:36 2026
// Host        : me4275-01 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/lab_10/Lab10_Colorizer/Lab10_Colorizer.gen/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2024.1.2" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6)
/* synthesis syn_black_box black_box_pad_pin="probe0[4:0],probe1[5:0],probe2[1:0],probe3[2:0],probe4[1:0],probe5[1:0],probe6[1:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  input clk /* synthesis syn_isclock = 1 */;
  input [4:0]probe0;
  input [5:0]probe1;
  input [1:0]probe2;
  input [2:0]probe3;
  input [1:0]probe4;
  input [1:0]probe5;
  input [1:0]probe6;
endmodule
