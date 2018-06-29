################################################################################
#
# aria2-webui
#
################################################################################

ARIA2_WEBUI_VERSION = d1ce5b992680f4d03eeee899ed8280cbcab8961a
# Use buildroot mirror since upstream switched the zipfile and directory
# structure without bumping/renaming.
ARIA2_WEBUI_SITE = https://github.com/ziahamza/webui-aria2/archive
ARIA2_WEBUI_SOURCE = $(ARIA2_WEBUI_VERSION).tar.gz
ARIA2_WEBUI_LICENSE = MIT
ARIA2_WEBUI_LICENSE_FILES = LICENSE

define ARIA2_WEBUI_INSTALL_TARGET_CMDS
    $(INSTALL) -d \
        $(TARGET_DIR)/var/www/webui-aria2 \
        $(TARGET_DIR)/var/www/webui-aria2/flags/4x3

    cp -a \
        $(@D)/{css,fonts,js} \
        $(@D)/{LICENSE,configuration.js,favicon.ico,index.html} \
        $(TARGET_DIR)/var/www/webui-aria2

    cp \
        $(@D)/flags/4x3/{cn,cz,de,es,fr,it,nl,pl,ru,th,tr,tw,us}.svg \
        $(TARGET_DIR)/var/www/webui-aria2/flags/4x3
endef

$(eval $(generic-package))
