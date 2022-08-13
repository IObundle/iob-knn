include $(KNN_DIR)/config.mk

#include
INCLUDE+=-I$(KNN_SW_DIR)

#headers
HDR+=iob_knn_swreg.h


iob_knn_swreg.h: 
	$(MKREGS) iob_knn $(KNN_DIR) SW 

