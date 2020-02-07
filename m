Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520591559DE
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 15:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgBGOm2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 09:42:28 -0500
Received: from hr2.samba.org ([144.76.82.148]:52502 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgBGOm2 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 7 Feb 2020 09:42:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=0ixIAJTc9gjYCvw1oFfeaWPlR72Yo+4oVxP8Emf9Xr8=; b=rmD63y/ezQ8e0BRcCgK4GcLTb/
        c7+48hd5rXhng3BF3MEnnIhUu37MnnbP++t2uch4yvdtQitarpGwqxJwuFGZehBVn6XzMotFR4tSM
        0ctOfLWHIrIdVuJVow+eIGRyM9N5dZfq+fi1BOA3MS3D+NRPSyp2Zgt2gnprIbAOXYE2AABMvN3o3
        UUhkia9Ph23YFProFOaNSVO0nKN1sQTh9P4Q6+J4f7kAssQkza8ppLY9bHK9rMcJ5nWWwsZ+NEueZ
        0JsXgPsJ3VoJ6xTtvxJq1iFKvKs7eWgVswy1YjTYMYg0/uw+1+CABkUCsUcHR+upegFd/gKNUAuZo
        inwLRrwezNF1ufYj3gCVyCyscZoal2OVGlByV/rpzNPc49mVIcG369LUO2kGb0tVEZdVKMVFlBtGs
        Dms6i6kI08pgBvoObHs9IUS7zR0ens3Iom7uJhrQPkZ2hC+44T4yAnwEW9w/ekmIxpulGyHASR1p+
        y/uVhPXONPenE011TF/BXUGS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j04pt-0001QA-MW; Fri, 07 Feb 2020 14:42:25 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2] Fix liburing.so symlink source if libdir != libdevdir
Date:   Fri,  7 Feb 2020 15:42:12 +0100
Message-Id: <20200207144212.4212-1-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <35cb2c1e-5985-13a8-1719-1bfa9aeb65a4@samba.org>
References: <35cb2c1e-5985-13a8-1719-1bfa9aeb65a4@samba.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 Makefile         | 6 +++++-
 configure        | 8 +++++++-
 debian/changelog | 6 ++++++
 src/Makefile     | 2 +-
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 3b582f1..05d5879 100644
--- a/Makefile
+++ b/Makefile
@@ -43,7 +43,11 @@ endif
 	    $< >$@
 
 install: $(NAME).pc
-	@$(MAKE) -C src install prefix=$(DESTDIR)$(prefix) includedir=$(DESTDIR)$(includedir) libdir=$(DESTDIR)$(libdir)  libdevdir=$(DESTDIR)$(libdevdir)
+	@$(MAKE) -C src install prefix=$(DESTDIR)$(prefix) \
+		includedir=$(DESTDIR)$(includedir) \
+		libdir=$(DESTDIR)$(libdir) \
+		libdevdir=$(DESTDIR)$(libdevdir) \
+		relativelibdir=$(relativelibdir)
 	$(INSTALL) -D -m 644 $(NAME).pc $(DESTDIR)$(libdevdir)/pkgconfig/$(NAME).pc
 	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man2
 	$(INSTALL) -m 644 man/*.2 $(DESTDIR)$(mandir)/man2
diff --git a/configure b/configure
index 9fb43b3..2fa393f 100755
--- a/configure
+++ b/configure
@@ -48,7 +48,7 @@ if test -z "$libdir"; then
   libdir="$prefix/lib"
 fi
 if test -z "$libdevdir"; then
-  libdevdir="$libdir"
+  libdevdir="$prefix/lib"
 fi
 if test -z "$mandir"; then
   mandir="$prefix/man"
@@ -57,6 +57,11 @@ if test -z "$datadir"; then
   datadir="$prefix/share"
 fi
 
+if test x"$libdir" = x"$libdevdir"; then
+  relativelibdir=""
+else
+  relativelibdir="$libdir/"
+fi
 
 if test "$show_help" = "yes"; then
 cat <<EOF
@@ -178,6 +183,7 @@ print_and_output_mak "prefix" "$prefix"
 print_and_output_mak "includedir" "$includedir"
 print_and_output_mak "libdir" "$libdir"
 print_and_output_mak "libdevdir" "$libdevdir"
+print_and_output_mak "relativelibdir" "$relativelibdir"
 print_and_output_mak "mandir" "$mandir"
 print_and_output_mak "datadir" "$datadir"
 
diff --git a/debian/changelog b/debian/changelog
index b9ee85c..f01b3a4 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,9 @@
+liburing (0.4-2) stable; urgency=low
+
+  * Fix /usr/lib/*/liburing.so symlink to /lib/*/liburing.so.1.0.4
+
+ -- Stefan Metzmacher <metze@samba.org>  Fri, 07 Feb 2020 15:30:00 +0100
+
 liburing (0.4-1) stable; urgency=low
 
   * Package liburing-0.4 using a packaging layout similar to libaio1
diff --git a/src/Makefile b/src/Makefile
index 1466dd4..5d13c09 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -61,7 +61,7 @@ install: $(all_targets)
 ifeq ($(ENABLE_SHARED),1)
 	install -D -m 755 $(libname) $(libdir)/$(libname)
 	ln -sf $(libname) $(libdir)/$(soname)
-	ln -sf $(libname) $(libdevdir)/liburing.so
+	ln -sf $(relativelibdir)$(libname) $(libdevdir)/liburing.so
 endif
 
 $(liburing_objs): include/liburing.h
-- 
2.17.1

