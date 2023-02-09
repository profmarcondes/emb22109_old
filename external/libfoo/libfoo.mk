LIBFOO_VERSION = 0.1
LIBFOO_SITE = $(call github,tpetazzoni,libfoo,v$(LIBFOO_VERSION))
LIBFOO_AUTORECONF = YES

$(eval $(autotools-package))
