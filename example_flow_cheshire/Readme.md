# Example Flow

Everything you need should be in the Makefile.

If you just want to run the entire flow to get something you can load into Yosys, simply use:

```bash
make all
```

**Note**: this requires you to install bender, morty, sv2v and svase.

Additionally you can find three SystemVerilog/Verilog files in various stages of the flow.

1. `morty.sv`: directly after pickling the entire project with Morty (use `make pickle` to regenerate)
2. `simplified.sv`: after adding some fixing and running it through SVase (use `make run-svase-fixed` to regenerate)
3. `final.v`: after SV2V, this file should be readable by Yosys (use `make run-sv2v-final` to regenerate)

Additionally, there are a few (intentionally) broken targets for you to explore potential issues at each state of the flow.

- `make run-sv2v-only` this runs SV2V directly after morty
- `make run-sv2v-error` this runs SV2V without a necessary fix, go check out the source of the error to see why we can't rely on SV2V alone
- `make run-svase` runs SVase without applying some necessary RTL fixes, it shows the beautiful warnings and error messages Slang (the underlying tool used by SVase) generates for us