# Copyright (c) 2017 Stan Grishin (stangri@melmac.net)
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

PKG_NAME:=slider-support
PKG_VERSION:=0.0.2
PKG_RELEASE:=2
PKG_LICENSE:=GPL-3.0+
PKG_MAINTAINER:=Stan Grishin <stangri@melmac.net>

include $(INCLUDE_DIR)/package.mk

define Package/slider-support/default
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+relayd
	PKGARCH:=all
	TITLE:=Slider support
endef

define Package/slider-support-ar300m
$(call Package/slider-support/default)
  VARIANT:=ar300m
	USEBUTTON:=BTN_1
	TITLE+= for GL-Inet AR300M
endef

define Package/slider-support-mt300n
$(call Package/slider-support/default)
  VARIANT:=mt300n
	USEBUTTON:=BTN_0
	TITLE+= for GL-Inet MT300N/v2
endef

define Package/slider-support/description
This service enables switching between Router, Access Point and Wireless Repeater
modes of operation for supported routers equipped with slider switch.
Please see the README for further information.
endef

define Package/slider-support/conffiles
/etc/config/slider-support
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/files/
	$(CP) ./files/slider-support.init $(PKG_BUILD_DIR)/files/slider-support.init
	sed -i "s|^\(PKG_VERSION\).*|\1='$(PKG_VERSION)-$(PKG_RELEASE)'|" $(PKG_BUILD_DIR)/files/slider-support.init
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/slider-support/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/slider-support.init $(1)/etc/init.d/slider-support
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/slider-support.conf $(1)/etc/config/slider-support
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DATA) ./files/stabridge.hotplug $(1)/etc/hotplug.d/iface/99-stabridge
	$(INSTALL_DIR) $(1)/lib/functions
	$(INSTALL_DATA) ./files/checkslider.$(VARIANT) $(1)/lib/functions/checkslider.sh
	$(INSTALL_DIR) $(1)/etc/rc.button
	$(INSTALL_DATA) ./files/slider-support.button $(1)/etc/rc.button/$(USEBUTTON)
	chmod 0755 $(1)/etc/rc.button/$(USEBUTTON)
endef

Package/slider-support-ar300m/install = $(Package/slider-support/install)
Package/slider-support-mt300n/install = $(Package/slider-support/install)

$(eval $(call BuildPackage,slider-support-ar300m))
$(eval $(call BuildPackage,slider-support-mt300n))
