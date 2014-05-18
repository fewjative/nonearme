ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = NoNearMe
NoNearMe_FRAMEWORKS = UIKit
NoNearMe_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += nnm
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 AppStore"
