LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := main

# Add your application source files here...
LOCAL_SRC_FILES := \
    $(LOCAL_PATH)/../../libs/arm64-v8a/libmain.so
#    YourSourceHere.cpp

#SDL_PATH := ../SDL  # SDL

#LOCAL_C_INCLUDES := $(LOCAL_PATH)/$(SDL_PATH)/include  # SDL

#LOCAL_SHARED_LIBRARIES := SDL3

LOCAL_LDLIBS := -lGLESv1_CM -lGLESv2 -lOpenSLES -llog -landroid  # SDL

#include $(BUILD_SHARED_LIBRARY)
include $(PREBUILT_SHARED_LIBRARY)
