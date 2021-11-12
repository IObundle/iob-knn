include $(KNN_DIR)/core.mk

#define
ifeq ($(DEBUG),1)
DEFINE+=-DDEBUG
endif

#include
INCLUDE+=-I$(KNN_SW_DIR)

#headers
HDR+=$(KNN_SW_DIR)/*.h KNNsw_reg.h

#sources
SRC+=$(KNN_SW_DIR)/*.c

KNNsw_reg.h: $(KNN_INC_DIR)/KNNsw_reg.v
	$(LIB_DIR)/software/mkregs.py $< SW
