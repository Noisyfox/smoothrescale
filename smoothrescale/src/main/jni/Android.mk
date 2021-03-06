LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := avutil
LOCAL_SRC_FILES := $(LOCAL_PATH)/ffmpeg/$(TARGET_ARCH_ABI)/lib/libavutil.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/ffmpeg/$(TARGET_ARCH_ABI)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := swscale
LOCAL_SRC_FILES := $(LOCAL_PATH)/ffmpeg/$(TARGET_ARCH_ABI)/lib/libswscale.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/ffmpeg/$(TARGET_ARCH_ABI)/include
include $(PREBUILT_SHARED_LIBRARY)


include $(CLEAR_VARS)
LOCAL_MODULE := smoothrescale
LOCAL_LDLIBS := \
	-llog \
	-ljnigraphics \

LOCAL_SRC_FILES := \
    on_load.c \

LOCAL_SHARED_LIBRARIES := \
    avutil \
	swscale \

include $(BUILD_SHARED_LIBRARY)