include $(KNN_DIR)/software/software.mk

#embeded sources
#SRC+=$(KNN_SW_DIR)/embedded/

# submodules
$(foreach p, $(SUBMODULES), $(eval include $(SUBMODULES_DIR)/$p/software/embedded/embedded.mk))
