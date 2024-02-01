// Copyright (c) 2022 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author:  Philippe Sauter <phsauter@student.ethz.ch>
//
// Test the following parameter propagation scenarios:
// - into generate-if scope
// - into iterations of generate-loop
module test__6142509188972423790 #( ) ( );
	localparam int unsigned IfElseParam=32'd2;
	localparam int unsigned ModuleParam=32'd3;
	if (1) begin
		localparam int unsigned GenParam=32'd3;
		if (1) begin :  gen_for_outer
			if (1) begin : __0
				localparam  k=0;
				localparam int unsigned OuterForParam=32'd1;
				if (1) begin :  gen_for_inner
					if (1) begin : __0
						localparam  l=0;
						localparam int unsigned InnerForParam=32'd1;
					end
				end
			end
			if (1) begin : __1
				localparam  k=1;
				localparam int unsigned OuterForParam=32'd2;
				if (1) begin :  gen_for_inner
					if (1) begin : __0
						localparam  l=0;
						localparam int unsigned InnerForParam=32'd2;
					end
					if (1) begin : __1
						localparam  l=1;
						localparam int unsigned InnerForParam=32'd3;
					end
				end
			end
			if (1) begin : __2
				localparam  k=2;
				localparam int unsigned OuterForParam=32'd4;
				if (1) begin :  gen_for_inner
					if (1) begin : __0
						localparam  l=0;
						localparam int unsigned InnerForParam=32'd4;
					end
					if (1) begin : __1
						localparam  l=1;
						localparam int unsigned InnerForParam=32'd5;
					end
					if (1) begin : __2
						localparam  l=2;
						localparam int unsigned InnerForParam=32'd6;
					end
					if (1) begin : __3
						localparam  l=3;
						localparam int unsigned InnerForParam=32'd7;
					end
				end
			end
		end
	end
endmodule