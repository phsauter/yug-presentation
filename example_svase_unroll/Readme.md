# SVase Example: Generate Unrolling

This example shows how the unroll pass implemented in SVase can make all generate statements 'real' and unrolls them.
The limits for the generate statements are also derived from parameters and are resolved as well.

**generate.sv:**

```systemverilog
module test #( ) ( );
	localparam int unsigned IfElseParam = 2;
	localparam int unsigned ModuleParam = 32'd3;

	if (IfElseParam == unsigned'(1)) begin
		localparam int unsigned GenParam = unsigned'($clog2(ModuleParam));
	end else begin
		localparam int unsigned GenParam = unsigned'(ModuleParam);

		for (genvar k = 0; k < GenParam; k++) begin : gen_for_outer
			localparam int unsigned OuterForParam = 2**k;

			for (genvar l = 0; l < 2**k; l++) begin : gen_for_inner
				localparam int unsigned InnerForParam = 2**k+l;
			end
		end
	end
endmodule
```



Running this through SVase with:

```
svase test output.sv generate.sv 
```



Gives us the following:

```systemverilog
module test__<HASH> #( ) ( );
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

```



## Requirements

You only need an [SVase](https://github.com/pulp-platform/svase) Binary, you can get a portable version for Linux from the [Releases page](https://github.com/pulp-platform/svase/releases).