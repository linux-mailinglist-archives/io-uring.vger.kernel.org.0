Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26A154A04
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 18:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgBFRIf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 12:08:35 -0500
Received: from hr2.samba.org ([144.76.82.148]:46490 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgBFRIf (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 6 Feb 2020 12:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=Q+Aip9I5T+qwh9hFAtvRDrSFGr+kIU2ID7d4IQCpoHo=; b=rkFJbTHUYvxNzXk7DlWRxLuk8q
        3A9K4noVUQkyhhvE0az+wXmxlPnf/iCKnK3u29/+Y/uw+obTZfep3fb+fK6N4K4tVSOc95ZLG3bTM
        uX4QwZ56DIyVHrVrI0i5hyYGLwM8aRGQvXc4peYlS4xj8T2dY/0+yhXd+X5KXjCNEzreWftj/dMPm
        HL2dnnaXhQgc2Tu7cMvcTg5Upfpg67I+HRiN3KdrzR1kTxusQRBqbwl/C2WhRJxbSKow2h5a1VI/v
        bz6xy7ybq7ontbYuCyjTcFgxxJvwe42g8ZF6h5KsMqo68Wf/Yhnm0cMYPSzWmBpkLppuFnJ1wjslu
        0kkMJvOmZ7aH52o6sdu4t0TYHxvz4krNT/nc7tEPAR+HBmLSAjGxsWFZ8lb4YymommTal5E/+cPd0
        0I852z3w5NBEVsJWUlwvVNi1n2V5kgNLT7uAbdNSj7nMJXmZbUrvlsSfVVvs5ro/IoJlehJqwsamz
        Qkj296UdhOuBK5nE/yEZBy+s;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1izkdk-00075K-C6; Thu, 06 Feb 2020 17:08:32 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 2/3] debian: package liburing-0.4 and use a layout as the libaio package
Date:   Thu,  6 Feb 2020 18:07:57 +0100
Message-Id: <20200206170758.29285-2-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200206170758.29285-1-metze@samba.org>
References: <20200206170758.29285-1-metze@samba.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hopefully this makes is easier to be picked up by the debian and
ubuntu distributions.

Cc: Liu Changcheng <changcheng.liu@aliyun.com>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 debian/changelog              |  6 +++
 debian/control                | 33 ++++++++++++-
 debian/liburing-dev.install   |  4 ++
 debian/liburing-dev.manpages  |  3 ++
 debian/liburing1-udeb.install |  1 +
 debian/liburing1.install      |  1 +
 debian/liburing1.symbols      | 28 +++++++++++
 debian/rules                  | 88 ++++++++++++++++++++++++++++++-----
 debian/watch                  |  5 +-
 9 files changed, 153 insertions(+), 16 deletions(-)
 create mode 100644 debian/liburing-dev.install
 create mode 100644 debian/liburing-dev.manpages
 create mode 100644 debian/liburing1-udeb.install
 create mode 100644 debian/liburing1.install
 create mode 100644 debian/liburing1.symbols

diff --git a/debian/changelog b/debian/changelog
index dfca8d2..b9ee85c 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+liburing (0.4-1) stable; urgency=low
+
+  * Package liburing-0.4 using a packaging layout similar to libaio1
+
+ -- Stefan Metzmacher <metze@samba.org>  Thu, 06 Feb 2020 11:30:00 +0100
+
 liburing (0.2-1ubuntu1) stable; urgency=low
 
   * Initial release.
diff --git a/debian/control b/debian/control
index 391cd68..831a314 100644
--- a/debian/control
+++ b/debian/control
@@ -4,12 +4,13 @@ Priority: optional
 Maintainer: Liu Changcheng <changcheng.liu@intel.com>
 Build-Depends: debhelper (>=9)
 Standards-Version: 4.1.4
-Homepage: https://git.kernel.dk/liburing
+Homepage: https://git.kernel.dk/cgit/liburing/tree/README
 Vcs-Git: https://git.kernel.dk/liburing
-Vcs-Browser: https://git.kernel.dk/liburing
+Vcs-Browser: https://git.kernel.dk/cgit/liburing/
 
 Package: liburing1
 Architecture: linux-any
+Multi-Arch: same
 Pre-Depends: ${misc:Pre-Depends}
 Depends: ${misc:Depends}, ${shlibs:Depends}
 Description: userspace library for using io_uring
@@ -17,3 +18,31 @@ Description: userspace library for using io_uring
  The newese Linux IO interface, io_uring could improve
  system performance a lot. liburing is the userpace
  library to use io_uring feature.
+ .
+ This package contains the shared library.
+
+Package: liburing1-udeb
+Package-Type: udeb
+Section: debian-installer
+Architecture: linux-any
+Depends: ${misc:Depends}, ${shlibs:Depends},
+Description: userspace library for using io_uring
+ io_uring is kernel feature to improve development
+ The newese Linux IO interface, io_uring could improve
+ system performance a lot. liburing is the userpace
+ library to use io_uring feature.
+ .
+ This package contains the udeb shared library.
+
+Package: liburing-dev
+Section: libdevel
+Architecture: linux-any
+Multi-Arch: same
+Depends: ${misc:Depends}, liburing1 (= ${binary:Version}),
+Description: userspace library for using io_uring
+ io_uring is kernel feature to improve development
+ The newese Linux IO interface, io_uring could improve
+ system performance a lot. liburing is the userpace
+ library to use io_uring feature.
+ .
+ This package contains the static library and the header files.
diff --git a/debian/liburing-dev.install b/debian/liburing-dev.install
new file mode 100644
index 0000000..a00d956
--- /dev/null
+++ b/debian/liburing-dev.install
@@ -0,0 +1,4 @@
+usr/include
+usr/lib/*/lib*.so
+usr/lib/*/lib*.a
+usr/lib/*/pkgconfig
diff --git a/debian/liburing-dev.manpages b/debian/liburing-dev.manpages
new file mode 100644
index 0000000..5683902
--- /dev/null
+++ b/debian/liburing-dev.manpages
@@ -0,0 +1,3 @@
+man/io_uring_setup.2
+man/io_uring_enter.2
+man/io_uring_register.2
diff --git a/debian/liburing1-udeb.install b/debian/liburing1-udeb.install
new file mode 100644
index 0000000..622f9ef
--- /dev/null
+++ b/debian/liburing1-udeb.install
@@ -0,0 +1 @@
+lib/*/lib*.so.*
diff --git a/debian/liburing1.install b/debian/liburing1.install
new file mode 100644
index 0000000..622f9ef
--- /dev/null
+++ b/debian/liburing1.install
@@ -0,0 +1 @@
+lib/*/lib*.so.*
diff --git a/debian/liburing1.symbols b/debian/liburing1.symbols
new file mode 100644
index 0000000..cc4d504
--- /dev/null
+++ b/debian/liburing1.symbols
@@ -0,0 +1,28 @@
+liburing.so.1 liburing1 #MINVER#
+ (symver)LIBURING_0.1 0.1-1
+ io_uring_get_sqe@LIBURING_0.1 0.1-1
+ io_uring_queue_exit@LIBURING_0.1 0.1-1
+ io_uring_queue_init@LIBURING_0.1 0.1-1
+ io_uring_queue_mmap@LIBURING_0.1 0.1-1
+ io_uring_register_buffers@LIBURING_0.1 0.1-1
+ io_uring_register_eventfd@LIBURING_0.1 0.1-1
+ io_uring_register_files@LIBURING_0.1 0.1-1
+ io_uring_submit@LIBURING_0.1 0.1-1
+ io_uring_submit_and_wait@LIBURING_0.1 0.1-1
+ io_uring_unregister_buffers@LIBURING_0.1 0.1-1
+ io_uring_unregister_files@LIBURING_0.1 0.1-1
+ (symver)LIBURING_0.2 0.2-1
+ __io_uring_get_cqe@LIBURING_0.2 0.2-1
+ io_uring_queue_init_params@LIBURING_0.2 0.2-1
+ io_uring_register_files_update@LIBURING_0.2 0.2-1
+ io_uring_peek_batch_cqe@LIBURING_0.2 0.2-1
+ io_uring_wait_cqe_timeout@LIBURING_0.2 0.2-1
+ io_uring_wait_cqes@LIBURING_0.2 0.2-1
+ (symver)LIBURING_0.3 0.3-1
+ (symver)LIBURING_0.4 0.4-1
+ io_uring_get_probe@LIBURING_0.4 0.4-1
+ io_uring_get_probe_ring@LIBURING_0.4 0.4-1
+ io_uring_register_personality@LIBURING_0.4 0.4-1
+ io_uring_register_probe@LIBURING_0.4 0.4-1
+ io_uring_ring_dontfork@LIBURING_0.4 0.4-1
+ io_uring_unregister_personality@LIBURING_0.4 0.4-1
diff --git a/debian/rules b/debian/rules
index fbc3942..283d464 100755
--- a/debian/rules
+++ b/debian/rules
@@ -1,16 +1,80 @@
 #!/usr/bin/make -f
-# You must remove unused comment lines for the released package.
-export DH_VERBOSE = 1
-export DEB_BUILD_MAINT_OPTIONS = hardening=+all
-#export DEB_CFLAGS_MAINT_APPEND  = -Wall -pedantic
-#export DEB_LDFLAGS_MAINT_APPEND = -Wl,--as-needed
 
-%:
-	dh $@
+# Uncomment this to turn on verbose mode.
+#export DH_VERBOSE=1
 
-override_dh_auto_configure:
-	./configure --mandir=/usr/share/man
-	rm -rf config.log
+DEB_BUILD_MAINT_OPTIONS = hardening=+bindnow
+DEB_CFLAGS_MAINT_PREPEND = -Wall
 
-override_dh_strip:
-	dh_strip --dbgsym-migration=liburing-dev
+include /usr/share/dpkg/default.mk
+include /usr/share/dpkg/buildtools.mk
+
+export CC
+
+lib := liburing1
+libdbg := $(lib)-dbg
+libudeb := $(lib)-udeb
+libdev := liburing-dev
+
+build-indep:
+
+build-arch:
+	dh_testdir
+
+	$(MAKE) CPPFLAGS="$(CPPFLAGS)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"
+
+build: build-indep build-arch
+
+clean:
+	dh_testdir
+	dh_testroot
+
+	$(MAKE) clean
+
+	dh_clean
+
+check-arch: build-arch
+	dh_testdir
+
+ifeq (,$(filter nocheck,$(DEB_BUILD_OPTIONS)))
+	$(MAKE) CPPFLAGS="$(CPPFLAGS)" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)" \
+	        partcheck
+endif
+
+install-arch: check-arch
+	dh_testdir
+	dh_testroot
+	dh_clean
+	dh_installdirs
+
+	$(MAKE) install \
+	  DESTDIR=$(CURDIR)/debian/tmp \
+	  libdir=/lib/$(DEB_HOST_MULTIARCH) \
+	  libdevdir=/usr/lib/$(DEB_HOST_MULTIARCH)
+
+binary: binary-indep binary-arch
+
+binary-indep:
+	# Nothing to do.
+
+binary-arch: install-arch
+	dh_testdir
+	dh_testroot
+	dh_install -a
+	dh_installdocs -a
+	dh_installexamples -a
+	dh_installman -a
+	dh_lintian -a
+	dh_link -a
+	dh_strip -a --ddeb-migration='$(libdbg) (<< 0.3)'
+	dh_compress -a
+	dh_fixperms -a
+	dh_makeshlibs -a --add-udeb '$(libudeb)'
+	dh_shlibdeps -a
+	dh_installdeb -a
+	dh_gencontrol -a
+	dh_md5sums -a
+	dh_builddeb -a
+
+.PHONY: clean build-indep build-arch build
+.PHONY: install-arch binary-indep binary-arch binary
diff --git a/debian/watch b/debian/watch
index 76575dc..f0e30c4 100644
--- a/debian/watch
+++ b/debian/watch
@@ -1,2 +1,3 @@
-# You must remove unused comment lines for the released package.
-version=3
+# Site          Directory               Pattern                 Version Script
+version=4
+https://git.kernel.dk/cgit/liburing/ snapshot\/liburing-([\d\.]+)\.tar\.(?:gz|xz) debian uupdate
-- 
2.17.1

