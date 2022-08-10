#include "iob_knn_swreg.h"

static int base;
void IOB_KNN_INIT_BASEADDR(uint32_t addr) {
        base = addr;
}

// Core Setters
void IOB_KNN_SET_RESET(uint8_t value) {
	return;
}

void IOB_KNN_SET_ENABLE(uint8_t value) {
        return;
}
