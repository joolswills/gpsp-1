LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

GIT_VERSION := " $(shell git rev-parse --short HEAD || echo unknown)"
ifneq ($(GIT_VERSION)," unknown")
	LOCAL_CFLAGS += -DGIT_VERSION=\"$(GIT_VERSION)\"
endif

LOCAL_MODULE    := retro
CPU_ARCH        :=

ifeq ($(TARGET_ARCH),arm)
LOCAL_CFLAGS += -DANDROID_ARM -DARM_ARCH -DARM_MEMORY_DYNAREC
LOCAL_ARM_MODE := arm
CPU_ARCH := arm
HAVE_DYNAREC := 1
endif

ifeq ($(TARGET_ARCH),x86)
LOCAL_CFLAGS +=  -DANDROID_X86 -DHAVE_MMAP
CPU_ARCH := x86_32
HAVE_DYNAREC := 1
endif

#ifeq ($(TARGET_ARCH),mips)
#LOCAL_CFLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
#endif

CORE_DIR := ..

SOURCES_C   :=
SOURCES_ASM :=

ifeq ($(HAVE_DYNAREC),1)
LOCAL_CFLAGS += -DHAVE_DYNAREC
endif

ifeq ($(CPU_ARCH),arm)
LOCAL_CFLAGS  += -DARM_ARCH
endif

include $(CORE_DIR)/Makefile.common

LOCAL_SRC_FILES := $(SOURCES_C) $(SOURCES_ASM)
LOCAL_CFLAGS += -O2 -DNDEBUG -DINLINE=inline -D__LIBRETRO__ -DFRONTEND_SUPPORTS_RGB565 $(INCFLAGS)

include $(BUILD_SHARED_LIBRARY)
