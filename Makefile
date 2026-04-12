ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SatThuFF
SatThuFF_FILES = Tweak.mm
SatThuFF_CFLAGS = -fobjc-arc
SatThuFF_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk
