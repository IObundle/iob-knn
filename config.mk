#
# CORE DEFINITIONS FILE
#

TOP_MODULE=iob_knn

DATA_W ?=32

#PATHS
KNN_HW_DIR:=$(KNN_DIR)/hardware
KNN_INC_DIR:=$(KNN_HW_DIR)/include
KNN_SRC_DIR:=$(KNN_HW_DIR)/src
KNN_TB_DIR:=$(KNN_HW_DIR)/testbench
KNN_SW_DIR:=$(KNN_DIR)/software
KNN_SUBMODULES_DIR:=$(KNN_DIR)/submodules
LIB_DIR?=$(KNN_SUBMODULES_DIR)/LIB

REMOTE_ROOT_DIR ?=sandbox/iob-soc-knn/submodules/KNN

#
# SIMULATION
#
SIM_DIR ?=$(KNN_HW_DIR)/simulation/icarus

#
# FPGA
#
FPGA_DIR ?=$(shell find $(KNN_HW_DIR) -name $(FPGA_FAMILY))



#MAKE SW ACCESSIBLE REGISTER
MKREGS:=$(shell find $(LIB_DIR) -name mkregs.py)

#DEFAULT FPGA FAMILY AND FAMILY LIST
FPGA_FAMILY ?=CYCLONEV-GT
FPGA_FAMILY_LIST ?=CYCLONEV-GT XCKU


# default target
default: sim

#cpu accessible registers
iob_knn_swreg_def.vh iob_knn_swreg_gen.vh: $(KNN_DIR)/mkregs.conf
	$(MKREGS) iob_knn $(KNN_DIR) HW

knn-gen-clean:
	@rm -rf *# *~ version.txt

.PHONY: default knn-gen-clean
