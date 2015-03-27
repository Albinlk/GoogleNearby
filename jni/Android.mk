LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := NearbyNativeActivity
LOCAL_SRC_FILES := NearbyNativeActivity.cpp NearbyConnection.cpp\
 NearbyNativeActivity_Engine.cpp GFKSimpleGame.cpp
 
LOCAL_C_INCLUDES := $(LOCAL_PATH)/.. $(LOCAL_PATH)/ndk_helper/ $(LOCAL_PATH)/jui_helper/ $(LOCAL_PATH)/external/jsoncpp/include/
LOCAL_CFLAGS :=
LOCAL_CPPFLAGS := -std=c++11 -DREMOVE_TEAPOT=1

LOCAL_LDLIBS := -llog -landroid -lEGL -lGLESv2 -latomic -lz
LOCAL_STATIC_LIBRARIES := cpufeatures android_native_app_glue  ndk_helper jui_helper gpg-1

#hard-fp setting
ifneq ($(filter %armeabi-v7a,$(TARGET_ARCH_ABI)),)
  #For now, only armeabi-v7a is supported for hard-fp
  #adding compiler/liker flags specifying hard float ABI for user code and math library
  LOCAL_CFLAGS += -mhard-float -D_NDK_MATH_NO_SOFTFP=1
  LOCAL_LDLIBS += -lm_hard
  ifeq (,$(filter -fuse-ld=mcld,$(APP_LDFLAGS) $(LOCAL_LDFLAGS)))
    #Supressing warn-mismatch warnings
    LOCAL_LDFLAGS += -Wl,--no-warn-mismatch
  endif
endif

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path,$(LOCAL_PATH)/../../..)
$(call import-add-path,$(LOCAL_PATH))
$(call import-module,ndk_helper)
$(call import-module,jui_helper)
$(call import-module,gpg-cpp-sdk/android)
$(call import-module,android/native_app_glue)
$(call import-module,android/cpufeatures)
