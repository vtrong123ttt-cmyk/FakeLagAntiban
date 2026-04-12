export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FakeLagAntiban
FakeLagAntiban_FILES = Tweak.mm
FakeLagAntiban_CFLAGS = -fobjc-arc
# Dòng này cực kỳ quan trọng để dùng được MSHook
FakeLagAntiban_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk
