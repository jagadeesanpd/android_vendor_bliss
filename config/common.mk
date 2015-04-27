PRODUCT_BRAND ?= bliss

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/bliss/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/bliss/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/bliss/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/bliss/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/bliss/prebuilt/common/bin/50-bliss.sh:system/addon.d/50-bliss.sh \
    vendor/bliss/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/bliss/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/bliss/prebuilt/common/etc/backup.conf:system/etc/backup.conf
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/bliss/prebuilt/common/bin/sysinit:system/bin/sysinit

# Proprietary latinime lib needed for Keyboard swyping
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# userinit support
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# fstrim support
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.d/98fstrim:system/etc/init.d/98fstrim

# L Speed
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/L_speed/data/Tweaks/kernelTweaks.log:data/Tweaks/kernelTweaks.log \
    vendor/bliss/prebuilt/common/L_speed/data/Tweaks/ram_manager.log:data/Tweaks/ram_manager.log \
    vendor/bliss/prebuilt/common/L_speed/data/Tweaks/Seeder_v7.log:data/Tweaks/Seeder_v7.log \
    vendor/bliss/prebuilt/common/L_speed/data/Tweaks/zipalign.log:data/Tweaks/zipalign.log \
    vendor/bliss/prebuilt/common/L_speed/system/bin/seeder:system/bin/seeder \
    vendor/bliss/prebuilt/common/L_speed/system/bin/uninstaller:system/bin/uninstaller \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/01kernelTweaks:system/etc/init.d/01kernelTweaks \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/02zipalign:system/etc/init.d/02zipalign \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/03ram_manager:system/etc/init.d/03ram_manager \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/Seeder:system/etc/init.d/Seeder \
    vendor/bliss/prebuilt/common/L_speed/system/etc/seeder_scripts/Seeder:system/etc/seeder_scripts/Seeder \
    vendor/bliss/prebuilt/common/L_speed/system/xbin/entro:system/xbin/entro \
    vendor/bliss/prebuilt/common/L_speed/system/xbin/openvpn:system/xbin/openvpn \
    vendor/bliss/prebuilt/common/L_speed/system/xbin/rngd:system/xbin/rngd \
    vendor/bliss/prebuilt/common/L_speed/system/xbin/zipalign:system/xbin/zipalign

# SuperSU
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/bliss/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# A Better Camera
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/abcamera/ABCamera.apk:system/app/ABCamera/ABCamera.apk \
    vendor/bliss/prebuilt/abcamera/libalmalib.so:system/lib/libalmalib.so \
    vendor/bliss/prebuilt/abcamera/libalmashot-clr.so:system/lib/libalmashot-clr.so \
    vendor/bliss/prebuilt/abcamera/libalmashot-dro.so:system/lib/libalmashot-dro.so \
    vendor/bliss/prebuilt/abcamera/libalmashot-hdr.so:system/lib/libalmashot-hdr.so \
    vendor/bliss/prebuilt/abcamera/libalmashot-night.so:system/lib/libalmashot-night.so \
    vendor/bliss/prebuilt/abcamera/libalmashot-pano.so:system/lib/libalmashot-pano.so \
    vendor/bliss/prebuilt/abcamera/libalmashot-seamless.so:system/lib/libalmashot-seamless.so \
    vendor/bliss/prebuilt/abcamera/libalmashot-sequence.so:system/lib/libalmashot-sequence.so \
    vendor/bliss/prebuilt/abcamera/libbestshot.so:system/lib/libbestshot.so \
    vendor/bliss/prebuilt/abcamera/libhiresportrait.so:system/lib/libhireportrait.so \
    vendor/bliss/prebuilt/abcamera/libhistogram.so:system/lib/libhistogram.so \
    vendor/bliss/prebuilt/abcamera/libpreshot.so:system/lib/libpreshot.so \
    vendor/bliss/prebuilt/abcamera/libswapheap.so:system/lib/libswapheap.so \
    vendor/bliss/prebuilt/abcamera/libutils-image.so:system/lib/libutils-image.so \
    vendor/bliss/prebuilt/abcamera/libutils-jni.so:system/lib/libutils-jni.so \
    vendor/bliss/prebuilt/abcamera/libyuvimage.so:system/lib/libyuvimage.so

# Bliss-specific init file
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/bliss/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/bliss/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Chromium Prebuilt
ifeq ($(PRODUCT_PREBUILT_WEBVIEWCHROMIUM),yes)
-include prebuilts/chromium/$(TARGET_DEVICE)/chromium_prebuilt.mk
endif

# This is Bliss!
PRODUCT_COPY_FILES += \
    vendor/bliss/config/permissions/com.bliss.android.xml:system/etc/permissions/com.bliss.android.xml

# T-Mobile theme engine
include vendor/bliss/config/themes_common.mk

# RomStats
PRODUCT_PACKAGES += \
    RomStats

# Screen recorder
#PRODUCT_PACKAGES += \
    #ScreenRecorder \
    #libscreenrecorder

# Required CM packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt

# Optional CM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji \
    Terminal

# Custom CM packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    AudioFX \
    CMWallpapers \
    CMFileManager \
    Eleven \
    LockClock \
    CMAccount \
    CMHome \
    OmniSwitch \
    MonthCalendarWidget \
    BlissPapers \
    DeviceControl

# Bliss Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in Bliss
PRODUCT_PACKAGES += \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Extra tools
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su

# HFM Files
PRODUCT_COPY_FILES += \
	vendor/bliss/prebuilt/etc/xtwifi.conf:system/etc/xtwifi.conf \
	vendor/bliss/prebuilt/etc/hosts.alt:system/etc/hosts.alt \
	vendor/bliss/prebuilt/etc/hosts.og:system/etc/hosts.og

endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

PRODUCT_PACKAGE_OVERLAYS += vendor/bliss/overlay/common

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

# BLISS Versioning System
-include vendor/bliss/config/versions.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)

# statistics identity
PRODUCT_PROPERTY_OVERRIDES += \
    ro.romstats.url=http://http://team.blissroms.com/RomStats/website/stats.php \
    ro.romstats.name=BlissPop \
    ro.romstats.version=$(BLISS_VERSION) \
    ro.romstats.askfirst=0 \
    ro.romstats.tframe=1

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.bliss.version=$(BLISS_VERSION)

# Team Bliss OTA Updater
BLISS_OTA_BUILDDIR := Official
ifeq ($(BLISS_BUILDTYPE),NIGHTLY)
  BLISS_OTA_BUILDDIR := Nightlies
endif
BLISS_BASE_URL    := http://jagbuildbox.net/downloads/BlissPop
BLISS_DEVICE_URL  := $(BLISS_BASE_URL)/$(BLISS_OTA_BUILDDIR)/$(TARGET_DEVICE)
BLISS_OTA_VERSION := $(shell date +%Y%m%d)
BLISS_ROM_NAME    := BlissPop

PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/blissota/BlissOTA.apk:system/app/BlissOTA/BlissOTA.apk \
    vendor/bliss/prebuilt/lib/libbypass.so:system/lib/libbypass.so

PRODUCT_PROPERTY_OVERRIDES += \
    ro.ota.systemname=$(BLISS_ROM_NAME) \
    ro.ota.version=$(BLISS_OTA_VERSION) \
    ro.ota.device=$(TARGET_DEVICE) \
    ro.ota.manifest=$(BLISS_DEVICE_URL)/ota.xml

export BLISS_OTA_ROM=$(BLISS_ROM_NAME)
export BLISS_OTA_VERNAME=$(BLISS_VERSION)
export BLISS_OTA_VER=$(BLISS_OTA_VERSION)
export BLISS_OTA_URL=$(BLISS_DEVICE_URL)/$(BLISS_VERSION).zip
