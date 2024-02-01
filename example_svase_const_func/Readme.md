# SVase Example: Constant Function

This example shows how the newest pass implemented in SVase can replace functions with a constant return value.

Slang is already capable of evaluating the function return value, SVase uses this capability and replaces all calls to the function, with the return value as evaluated by Slang.

**assign.sv:**

```systemverilog
module test #( ) ( );
	logic [31:0] bit5_hot;
	logic [31:0] bit12_hot;
	logic [31:0] bits;
	
	assign bits = 32'h0000aaee;
	assign bit5_hot = nth_bit(5);
	assign bit12_hot = nth_bit(12);

	function automatic logic[31:0] nth_bit(input int unsigned bit_pos);
		logic[31:0] shifted;
		shifted = (32'd01 << bit_pos);

		return shifted;
	endfunction
endmodule
```

Notice how the function `nth_bit` return a constant value iff its only argument `bit_pos` is constant.

Running this through SVase with:
```
svase test output.sv assign.sv 
```



Gives us the following:

```systemverilog
module test__<HASH> #( ) ( );
	logic [31:0] bit5_hot;
	logic [31:0] bit12_hot;
	logic [31:0] bits;
	
	assign bits = 32'd43758;
	assign bit5_hot = 32'd32;
	assign bit12_hot = 32'd4096;
	function automatic logic[31:0] nth_bit(input int unsigned bit_pos);
		logic[31:0] shifted;
		shifted = (32'd01 << bit_pos);
		return shifted;
	endfunction
endmodule
```

The two calls to `nth_bit()` have disappeared.



## Requirements

You only need an [SVase](https://github.com/pulp-platform/svase) Binary, you can get a portable version for Linux from the [Releases page](https://github.com/pulp-platform/svase/releases).