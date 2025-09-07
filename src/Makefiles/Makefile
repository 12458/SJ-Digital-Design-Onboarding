#--------------------------------------------------------------------
# Cadence‑only Makefile (Xcelium / SimVision / IMC)
#--------------------------------------------------------------------

#--------------------------------------------------------------------
# Add the following to the testbench
# initial begin
#     $shm_open("waves.shm");
#     $shm_probe("AC");
# end
#--------------------------------------------------------------------

# ===== User‑configurable variables =================================
INCLUDE_FILE_NAME ?= calculator.include

# ===== Paths =======================================================
CURRENT_DIR := $(shell pwd)
WORKSPACE   := $(CURRENT_DIR)/WORKSPACE
SCRIPT_DIR  := ../../scripts
PYTHON      := python3.12

# ===== Dynamic macro definitions ===================================
VERILOG_DEFINES := SIM=1 INST_FILE=\"$(INST_FILE)\"
ifeq ($(INIT_DATA),1)
  VERILOG_DEFINES += INIT_DATA=1
  VERILOG_DEFINES += DATA_FILE=\"$(DATA_FILE)\"
endif
DEFINE_FLAGS := $(foreach def,$(VERILOG_DEFINES),+define+$(def))

.DEFAULT_GOAL := xrun

# ===== Help Message ================================================
.PHONY: help
help:
	@echo "----------------------------------------------------------------"
	@echo "Administrative targets:"
	@echo "  help               - this message"
	@echo "  clean              - remove WORKSPACE directory"
	@echo
	@echo "Compilation targets:"
	@echo "  link               - generate WORKSPACE/sym_links/"
	@echo "  xrun               - compile & simulate using Cadence Xcelium"
	@echo "  simvision          - view waveform database"
	@echo "  run_and_view       - xrun + simvision"
	@echo "  coverage           - open coverage in IMC"
	@echo
	@echo "  verify_onboarding  - (DIGITAL DESIGN ONBOARDING ONLY) check your project for correctness"
	@echo "----------------------------------------------------------------"

# ===== Administrative Targets ======================================
.PHONY: clean link
clean:
	@rm -rf $(WORKSPACE)

link:
	@mkdir -p $(WORKSPACE)/sym_links
	@rm -rf $(WORKSPACE)/sym_links/*
	@python3.12 link_files.py $(INCLUDE_FILE_NAME)
#   @ln -s $(CURRENT_DIR)/../../src/python_model/*.txt WORKSPACE/sym_links/.

# ===== Simulation Targets ==========================================
.PHONY: xrun simvision run_and_view coverage

XRUN_FLAGS = -64bit -sv -linedebug -access +rwc \
             -timescale 1ns/10ps \
             $(DEFINE_FLAGS) \
             +testname=$(TESTNAME) \
             +incdir+sym_links \
             -coverage all \
             -licqueue \
             -covoverwrite

xrun: link
	cd $(WORKSPACE) && \
	xrun $(XRUN_FLAGS) -f sym_links/sim_no_path.include \
	     -logfile simulation.log

simvision:
	cd $(WORKSPACE) && simvision waves.shm &

run_and_view: xrun simvision

# Need to change IMC path...
coverage:
	cd $(WORKSPACE) && /tools/software/cadence/vmanager/latest/tools.lnx86/vmgr/bin/imc -load cov_work/scope/test &

verify_onboarding:
	$(MAKE) clean
	$(PYTHON) $(SCRIPT_DIR)/init_mem.py $(WORKSPACE)
	$(MAKE) xrun
	$(PYTHON) $(SCRIPT_DIR)/check_onboarding.py $(WORKSPACE)/memory_post_state_lower.txt $(WORKSPACE)/sim_memory_post_state_lower.txt
	$(PYTHON) $(SCRIPT_DIR)/check_onboarding.py $(WORKSPACE)/memory_post_state_upper.txt $(WORKSPACE)/sim_memory_post_state_upper.txt

# ===== Default Target ==============================================
.DEFAULT_GOAL := run_and_view
