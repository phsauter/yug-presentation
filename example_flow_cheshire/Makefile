# Copyright 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors:
# - Philippe Sauter <phsauter@ethz.ch>

#########
# Tools #
#########
BENDER := bender
MORTY  := morty
SV2V   := sv2v
SVASE  := svase


#########################
# Dependency Management #
#########################
# use bender to collect all dependencies (uses Bender.lock if it exists)
checkout:
	bender checkout

# we can ask bender where cheshire is checked-out to
CHS_ROOT := $(shell $(BENDER) path cheshire)


######################
# Configure Hardware #
######################
# include Cheshire targets
# we are interested in 'chs-hw-all', it generated the register-files etc
include $(CHS_ROOT)/cheshire.mk


############
# RTL Flow #
############
sources.json:
	$(BENDER) sources -f -t synthesis -t cv64a6_imafdc_sv39 > $@
	
# a parsing error with morty makes the sed fix necessary
# --top makes it so all modules not used are not included
# but morty currently doesn't realize the REG_BUS interface is needed, so we concatenate it by hand
pickled.sv: sources.json
	sed -i "s| << riscv::XLEN-2| << (riscv::XLEN-2)|g" $(shell $(BENDER) path cva6)/core/include/ariane_pkg.sv
	$(MORTY) -q -f sources.json -o morty.sv --keep_defines --top example_soc
	cat morty.sv $(shell $(BENDER) path register_interface)/src/reg_intf.sv > pickled.sv
	
# the code includes 'pragmas' to turn of code translation during synthesis
# SVase processes them automatically but sv2v doesn't know them
# so to give sv2v a fair shot, we remove them here
pickle: pickled.sv
	python3 ./pragma.py pickled.sv > pickled_fixed_sv2v.sv

# this will likely fail, note the error message
run-sv2v-only:
	$(SV2V) --top example_soc pickled_fixed_sv2v.sv --write sv2v.v
	
# this will also fail (a mix between questionable RTL and SVase being experimental)
# but look at the error messages, they are so nice!
run-svase:
	$(SVASE) example_soc simplified.sv pickled.sv
	
run-svase-fixed:
	sed "s|default: return '{default: '{0, 0}};|default: return cva6_id_map_t'{default: '0};|g" pickled.sv > pickled_fixed.sv
	sed -i "s|req_q <= (store_req_t'.*|req_q <= (store_req_t'{mode: axi_llc_pkg::tag_mode_e'(2'b0), default: '0});|g" pickled_fixed.sv
	sed -i "s|module slib_mv_filter #(parameter WIDTH = 4, THRESHOLD = 10).*|module slib_mv_filter #(parameter WIDTH = 4, parameter THRESHOLD = 10) (|g" pickled_fixed.sv
	$(SVASE) example_soc simplified.sv pickled_fixed.sv
	
	
	
	
	
	
	
	
	
	
