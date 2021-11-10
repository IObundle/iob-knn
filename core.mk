#
# CORE DEFINITIONS FILE
#

CORE_NAME:=KNN
TOP_MODULE=iob_knn

DATA_W ?=32

#PATHS
KNN_HW_DIR:=$(KNN_DIR)/hardware
KNN_INC_DIR:=$(KNN_HW_DIR)/include
KNN_SRC_DIR:=$(KNN_HW_DIR)/src
KNN_TB_DIR:=$(KNN_HW_DIR)/testbench
KNN_SW_DIR:=$(KNN_DIR)/software
KNN_SUBMODULES_DIR:=$(KNN_DIR)/submodules

#submodules
KNN_SUBMODULES:=INTERCON LIB TEX
$(foreach p, $(KNN_SUBMODULES), $(eval $p_DIR ?=$(KNN_SUBMODULES_DIR)/$p))

REMOTE_ROOT_DIR ?=sandbox/iob-soc-knn/submodules/KNN

#
# SIMULATION
#
SIM_DIR ?=$(KNN_HW_DIR)/simulation/icarus

#
# FPGA
#
FPGA_DIR ?=$(shell find $(KNN_HW_DIR) -name $(FPGA_FAMILY))

FPGA_FAMILY ?=CYCLONEV-GT
#FPGA_FAMILY ?=XCKU

FPGA_FAMILY_LIST = CYCLONEV-GT XCKU

#
# DOCUMENTS
#

DOC:=pb
#DOC:=ug

DOC_LIST:=pb ug

DOC_DIR:=document/$(DOC)

INTEL ?=1
INT_FAMILY ?=CYCLONEV-GT
XILINX ?=1
XIL_FAMILY ?=XCKU

#
# VERSION
#
VERSION= 0.1
VLINE:="V$(VERSION)"
$(CORE_NAME)_version.txt:
ifeq ($(VERSION),)
	$(error "variable VERSION is not set")
endif
	echo $(VLINE) > version.txt

#RULES
$(CORE_NAME)_printname:
	@echo $(CORE_NAME)

.PHONY: $(CORE_NAME)_printname
