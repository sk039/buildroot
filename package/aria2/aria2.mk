################################################################################
#
# aria2
#
################################################################################

ARIA2_VERSION = 1.34.0
ARIA2_SOURCE = aria2-$(ARIA2_VERSION).tar.xz
ARIA2_SITE = https://github.com/aria2/aria2/releases/download/release-$(ARIA2_VERSION)
ARIA2_LICENSE = GPLv2
ARIA2_LICENSE_FILES = LICENSE
ARIA2_INSTALL_STAGING = YES
ARIA2_DEPENDENCIES = host-pkgconf zlib

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ARIA2_CONF_OPTS += --with-openssl
ARIA2_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
ARIA2_CONF_OPTS += --with-gnutls
ARIA2_DEPENDENCIES += gnutls
else
ARIA2_CONF_OPTS += --disable-ssl
endif

ifeq ($(BR2_PACKAGE_NETTLE),y)
ARIA2_CONF_OPTS += --with-libnettle
ARIA2_DEPENDENCIES += nettle
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
ARIA2_CONF_OPTS += --with-libgcrypt
ARIA2_DEPENDENCIES += libgcrypt 
endif

ifeq ($(BR2_PACKAGE_LIBGMP),y)
ARIA2_CONF_OPTS += --with-libgmp
ARIA2_DEPENDENCIES += libgmp
endif

ifeq ($(BR2_PACKAGE_LIBXML2),y)
ARIA2_CONF_OPTS += --with-libxml2
ARIA2_DEPENDENCIES += libxml2
endif

ifeq ($(BR2_PACKAGE_LIBEXPAT),y)
ARIA2_CONF_OPTS += --with-libexpat
ARIA2_DEPENDENCIES += libexpat
endif

ifeq ($(BR2_PACKAGE_ARIA2_SFTP),y)
ARIA2_CONF_OPTS += --with-libssh2
ARIA2_DEPENDENCIES += libssh2
endif

ifeq ($(BR2_PACKAGE_ARIA2_ASYNC_DNS),y)
ARIA2_CONF_OPTS += --with-c-ares
ARIA2_DEPENDENCIES += c-ares
endif

ifeq ($(BR2_PACKAGE_ARIA2_COOKIE),y)
ARIA2_CONF_OPTS += --with-sqlite3
ARIA2_DEPENDENCIES += sqlite
endif

ARIA2_CONF_OPTS += \
    --disable-nls \
    $(if $(BR2_PACKAGE_ARIA2_BITTORRENT),--enable,--disable)-bittorrent \
    $(if $(BR2_PACKAGE_ARIA2_METALINK),--enable,--disable)-metalink \
    $(if $(BR2_PACKAGE_ARIA2_WEBSOCKET),--enable,--disable)-websocket \
    --without-libuv \
    --with-libz \
	CPPFLAGS="$(TARGET_CPPFLAGS) $(ARIA2_CPPFLAGS)"

define ARIA2_USERS
	aria2 -1 aria2 -1 * /var/lib/aria2 - aria2 Aria2 Daemon
endef

define ARIA2_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/aria2/S92aria2 \
		$(TARGET_DIR)/etc/init.d/S92aria2
endef

define ARIA2_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/aria2/aria2-daemon.service \
		$(TARGET_DIR)/usr/lib/systemd/system/aria2-daemon.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/aria2-daemon.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/aria2-daemon.service
endef

# Somehow, ${STRIP} does not percolates through to the shtool script
# used to install the executables; thus, that script tries to run the
# executable it is supposed to install, resulting in an error.
ARIA2_MAKE_ENV = STRIP="$(TARGET_STRIP)"

$(eval $(autotools-package))
