include $(KNN_DIR)/core.mk

# SUBMODULES
# Intercon
ifneq (INTERCON,$(filter INTERCON, $(SUBMODULES)))
SUBMODULES+=INTERCON
include $(INTERCON_DIR)/hardware/hardware.mk
endif

# Lib
ifneq (LIB,$(filter LIB, $(SUBMODULES)))
SUBMODULES+=LIB
INCLUDE+=$(incdir) $(LIB_DIR)/hardware/include
VHDR+=$(wildcard $(LIB_DIR)/hardware/include/*.vh)
endif

# include
INCLUDE+=$(incdir) $(KNN_INC_DIR)

# headers
VHDR+=$(wildcard $(KNN_INC_DIR)/*.vh)
VHDR+=KNNsw_reg_gen.v KNNsw_reg.vh

# sources
VSRC+=$(wildcard $(KNN_SRC_DIR)/*.v)

# cpu accessible registers
KNNsw_reg_gen.v KNNsw_reg.vh: $(KNN_INC_DIR)/KNNsw_reg.v
	$(LIB_DIR)/software/mkregs.py $< HW

knn_clean_hw:
	@rm -rf $(KNN_INC_DIR)/KNNsw_reg_gen.v $(KNN_INC_DIR)/KNNsw_reg.vh tmp

.PHONY: knn_clean_hw
