Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE602154A03
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 18:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgBFRIb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 12:08:31 -0500
Received: from hr2.samba.org ([144.76.82.148]:46484 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbgBFRIb (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 6 Feb 2020 12:08:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=vaxbqhXeonxcZK9RaOgJUWdnu9L+dEEn7S4EzI0RgeE=; b=OSsHO0UeGpptADZd/3wRhqLZNH
        djIybj3Oej5Pn9N5O+/9Y3mM4pCPbCxD1mOQkorxGkYIpDHKkl3gGryJ4M6C/KxV18AW6H5S82eua
        OrbWIB9HLOSqWsB4UL4Fw8dFFsrI5DcGoE+cKY+FP6q9LazYX4BcDlipbE2pB4TVC1bfVowwLv1aw
        X+gCbhLyqSeUMf4eZY/gm5pNWjxu+UbHoM1TM5dUf8WL5tYqZwuM7um4P84AXdTp4Da3rDAjgWExE
        JPfFvdPyK/VMUW3AumDhB/WjaiTetGj8O80T08ut+ofQHgnDJl6tLajoZftiaaflRCQBXj8aADQf6
        T7WK+a0vek4atEPCNCKagJoHmPWCclFdKrXfGv+N62bqexggeoQLq5zrUdXI1bigik146K2f77T2S
        G5ZQ5pNSAJyEQOF88ASFmBkrfYOlGuYPBZRmr1xyRfA8ufzTqNmmkafBwxxcboYWfqxLyo+2JcyKL
        Y8i8YQQWfpNC3vCBD1+/mysS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1izkdh-00075K-F8; Thu, 06 Feb 2020 17:08:29 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 1/3] configure/Makefile: introduce libdevdir defaults to $(libdir)
Date:   Thu,  6 Feb 2020 18:07:56 +0100
Message-Id: <20200206170758.29285-1-metze@samba.org>
X-Mailer: git-send-email 2.17.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This makes it possible to install runtime libraries to
/lib/* and developement libraries to /usr/lib/*

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 Makefile     | 7 +++++--
 configure    | 9 ++++++++-
 src/Makefile | 5 +++--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 89b3f1d..3b582f1 100644
--- a/Makefile
+++ b/Makefile
@@ -13,6 +13,9 @@ all:
 	@$(MAKE) -C test
 	@$(MAKE) -C examples
 
+partcheck: all
+	@echo "make partcheck => TODO add tests with out kernel support"
+
 runtests: all
 	@$(MAKE) -C test runtests
 runtests-loop:
@@ -40,8 +43,8 @@ endif
 	    $< >$@
 
 install: $(NAME).pc
-	@$(MAKE) -C src install prefix=$(DESTDIR)$(prefix) includedir=$(DESTDIR)$(includedir) libdir=$(DESTDIR)$(libdir)
-	$(INSTALL) -D -m 644 $(NAME).pc $(DESTDIR)$(libdir)/pkgconfig/$(NAME).pc
+	@$(MAKE) -C src install prefix=$(DESTDIR)$(prefix) includedir=$(DESTDIR)$(includedir) libdir=$(DESTDIR)$(libdir)  libdevdir=$(DESTDIR)$(libdevdir)
+	$(INSTALL) -D -m 644 $(NAME).pc $(DESTDIR)$(libdevdir)/pkgconfig/$(NAME).pc
 	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man2
 	$(INSTALL) -m 644 man/*.2 $(DESTDIR)$(mandir)/man2
 
diff --git a/configure b/configure
index 54cf5f6..9fb43b3 100755
--- a/configure
+++ b/configure
@@ -22,6 +22,8 @@ for opt do
   ;;
   --libdir=*) libdir="$optarg"
   ;;
+  --libdevdir=*) libdevdir="$optarg"
+  ;;
   --mandir=*) mandir="$optarg"
   ;;
   --datadir=*) datadir="$optarg"
@@ -45,6 +47,9 @@ fi
 if test -z "$libdir"; then
   libdir="$prefix/lib"
 fi
+if test -z "$libdevdir"; then
+  libdevdir="$libdir"
+fi
 if test -z "$mandir"; then
   mandir="$prefix/man"
 fi
@@ -61,7 +66,8 @@ Options: [defaults in brackets after descriptions]
   --help                   print this message
   --prefix=PATH            install in PATH [$prefix]
   --includedir=PATH        install headers in PATH [$includedir]
-  --libdir=PATH            install libraries in PATH [$libdir]
+  --libdir=PATH            install runtime libraries in PATH [$libdir]
+  --libdevdir=PATH         install developement libraries in PATH [$libdevdir]
   --mandir=PATH            install man pages in PATH [$mandir]
   --datadir=PATH           install shared data in PATH [$datadir]
 EOF
@@ -171,6 +177,7 @@ print_and_output_mak() {
 print_and_output_mak "prefix" "$prefix"
 print_and_output_mak "includedir" "$includedir"
 print_and_output_mak "libdir" "$libdir"
+print_and_output_mak "libdevdir" "$libdevdir"
 print_and_output_mak "mandir" "$mandir"
 print_and_output_mak "datadir" "$datadir"
 
diff --git a/src/Makefile b/src/Makefile
index 47e0ba5..1466dd4 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -1,6 +1,7 @@
 prefix ?= /usr
 includedir ?= $(prefix)/include
 libdir ?= $(prefix)/lib
+libdevdir ?= $(prefix)/lib
 
 CFLAGS ?= -g -fomit-frame-pointer -O2
 override CFLAGS += -Wall -Iinclude/
@@ -56,11 +57,11 @@ install: $(all_targets)
 	install -D -m 644 include/liburing.h $(includedir)/liburing.h
 	install -D -m 644 include/liburing/compat.h $(includedir)/liburing/compat.h
 	install -D -m 644 include/liburing/barrier.h $(includedir)/liburing/barrier.h
-	install -D -m 644 liburing.a $(libdir)/liburing.a
+	install -D -m 644 liburing.a $(libdevdir)/liburing.a
 ifeq ($(ENABLE_SHARED),1)
 	install -D -m 755 $(libname) $(libdir)/$(libname)
 	ln -sf $(libname) $(libdir)/$(soname)
-	ln -sf $(libname) $(libdir)/liburing.so
+	ln -sf $(libname) $(libdevdir)/liburing.so
 endif
 
 $(liburing_objs): include/liburing.h
-- 
2.17.1

