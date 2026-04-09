ARCHS = arm64
TARGET = iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FakeLagPro
FakeLagPro_FILES = Tweak.mm
FakeLagPro_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
