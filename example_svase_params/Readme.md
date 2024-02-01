# SVase Example: Parameter Propagation

This example shows how the parameter propagation pass implemented in SVase can resolve parameters and push them to the correct scopes that need them.

**params.sv:**

```systemverilog
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
    localparam int unsigned TopParam2 = unsigned'($clog2(PortParam2));
    localparam int unsigned DerivParam = 2**TopParam1;

	localparam type TypeParam = logic[1:0][31:0];

	test2 #(
		.PortParam(TopParam),
        .NoDefaultParam(TopParam2),
		.PortTypeParam(TypeParam)
	) i_test2 ( );
endmodule
```



Running this through SVase with:

```
svase test output.sv params.sv 
```



Gives us the following:

```systemverilog
module test2__<HASH2> #(
	parameter int unsigned PortParam=32'd5,
    parameter int unsigned NoDefaultParam=32'd3,
	parameter type PortTypeParam =logic[1:0][31:0]
) ( );
	localparam int unsigned Module2Param=32'd5;
	PortTypeParam used_type;
endmodule

module test__<HASH1> #(
    parameter int unsigned PortParam1=32'd5,
	parameter int unsigned PortParam2=32'd8
) ( );
	localparam int unsigned TopParam=32'd5;
    localparam int unsigned DerivParam=32'd32;
    
    localparam int unsigned TopParam2=32'd3;
	localparam type TypeParam =logic[1:0][31:0];
	test2__<HASH2>  i_test2 ( );
endmodule

```

All parameters have been propagated as far as possible and then resolved. So any following tool does not have to properly resolve scope anymore, all parameters essentially act as local parameters to its module.



## Requirements

You only need an [SVase](https://github.com/pulp-platform/svase) Binary, you can get a portable version for Linux from the [Releases page](https://github.com/pulp-platform/svase/releases).