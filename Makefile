TARGET = iphone:11.2:11.0
ARCHS = arm64
THEOS_DEVICE_IP = 0
THEOS_DEVICE_PORT = 2222
export TARGET ARCHS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TweakConfigurator
TweakConfigurator_FILES = Tweak.xm TweakConfiguratorShared/TweakConfigurator.m

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += tweakconfigurator
include $(THEOS_MAKE_PATH)/aggregate.mk
