// Copyright (c) 2022 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author:  Philippe Sauter <phsauter@student.ethz.ch>
//
// Tests parameter propagation

module test2 #(
	parameter int unsigned PortParam = 0,
    parameter int unsigned NoDefaultParam,
	parameter type PortTypeParam = logic
) ( );
	localparam int unsigned Module2Param = PortParam;
	PortTypeParam used_type;
endmodule


module test #(
    parameter int unsigned PortParam1 = 32'd5,
	parameter int unsigned PortParam2 = 32'd8
) ( );
	localparam int unsigned TopParam = PortParam1;
    localparam int unsigned DerivParam = 2**TopParam;
    
    localparam int unsigned TopParam2 = unsigned'($clog2(PortParam2));

	localparam type TypeParam = logic[1:0][31:0];

	test2 #(
		.PortParam(TopParam),
        .NoDefaultParam(TopParam2),
		.PortTypeParam(TypeParam)
	) i_test2 ( );
endmodule
