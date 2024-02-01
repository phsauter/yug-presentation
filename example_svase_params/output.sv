// Copyright (c) 2022 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author:  Philippe Sauter <phsauter@student.ethz.ch>
//
// Tests parameter propagation
module test2__17453784029803096892 #(
	parameter int unsigned PortParam=32'd5,
    parameter int unsigned NoDefaultParam=32'd3,
	parameter type PortTypeParam =logic[1:0][31:0]
) ( );
	localparam int unsigned Module2Param=32'd5;
	PortTypeParam used_type;
endmodule

module test__3661336181122063975 #(
    parameter int unsigned PortParam1=32'd5,
	parameter int unsigned PortParam2=32'd8
) ( );
	localparam int unsigned TopParam=32'd5;
    localparam int unsigned DerivParam=32'd32;
    
    localparam int unsigned TopParam2=32'd3;
	localparam type TypeParam =logic[1:0][31:0];
	test2__17453784029803096892  i_test2 ( );
endmodule
