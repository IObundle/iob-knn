include $(KNN_DIR)/hardware/hardware.mk

# define
DEFINE+=$(defmacro) DATA_W=$(DATA_W)

DEFINE+=$(defmacro)VCD

VSRC+=$(KNN_TB_DIR)/knn_tb.v
