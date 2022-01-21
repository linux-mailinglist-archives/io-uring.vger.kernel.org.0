Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5554964FF
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 19:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381955AbiAUS0u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 13:26:50 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:51004 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382094AbiAUS0s (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Jan 2022 13:26:48 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id EB9581FA18;
        Fri, 21 Jan 2022 18:26:35 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>,
        Eric Wong <e@80x24.org>
Subject: [PATCH v3 5/7] debian: rename package to liburing2 to match .so version
Date:   Fri, 21 Jan 2022 18:26:33 +0000
Message-Id: <20220121182635.1147333-6-e@80x24.org>
In-Reply-To: <20220121182635.1147333-1-e@80x24.org>
References: <20220121182635.1147333-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reported-by: Stefan Metzmacher <metze@samba.org>
Link: https://lore.kernel.org/io-uring/0178c27e-4f22-ac44-1f9f-f2c8f5f176b5@samba.org/
Signed-off-by: Eric Wong <e@80x24.org>
---
 debian/control                                            | 6 +++---
 debian/{liburing1-udeb.install => liburing2-udeb.install} | 0
 debian/{liburing1.install => liburing2.install}           | 0
 debian/{liburing1.symbols => liburing2.symbols}           | 2 +-
 debian/rules                                              | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)
 rename debian/{liburing1-udeb.install => liburing2-udeb.install} (100%)
 rename debian/{liburing1.install => liburing2.install} (100%)
 rename debian/{liburing1.symbols => liburing2.symbols} (97%)

diff --git a/debian/control b/debian/control
index 831a314..afce9b1 100644
--- a/debian/control
+++ b/debian/control
@@ -8,7 +8,7 @@ Homepage: https://git.kernel.dk/cgit/liburing/tree/README
 Vcs-Git: https://git.kernel.dk/liburing
 Vcs-Browser: https://git.kernel.dk/cgit/liburing/
 
-Package: liburing1
+Package: liburing2
 Architecture: linux-any
 Multi-Arch: same
 Pre-Depends: ${misc:Pre-Depends}
@@ -21,7 +21,7 @@ Description: userspace library for using io_uring
  .
  This package contains the shared library.
 
-Package: liburing1-udeb
+Package: liburing2-udeb
 Package-Type: udeb
 Section: debian-installer
 Architecture: linux-any
@@ -38,7 +38,7 @@ Package: liburing-dev
 Section: libdevel
 Architecture: linux-any
 Multi-Arch: same
-Depends: ${misc:Depends}, liburing1 (= ${binary:Version}),
+Depends: ${misc:Depends}, liburing2 (= ${binary:Version}),
 Description: userspace library for using io_uring
  io_uring is kernel feature to improve development
  The newese Linux IO interface, io_uring could improve
diff --git a/debian/liburing1-udeb.install b/debian/liburing2-udeb.install
similarity index 100%
rename from debian/liburing1-udeb.install
rename to debian/liburing2-udeb.install
diff --git a/debian/liburing1.install b/debian/liburing2.install
similarity index 100%
rename from debian/liburing1.install
rename to debian/liburing2.install
diff --git a/debian/liburing1.symbols b/debian/liburing2.symbols
similarity index 97%
rename from debian/liburing1.symbols
rename to debian/liburing2.symbols
index 29109f2..5bb203f 100644
--- a/debian/liburing1.symbols
+++ b/debian/liburing2.symbols
@@ -1,4 +1,4 @@
-liburing.so.1 liburing1 #MINVER#
+liburing.so.2 liburing2 #MINVER#
  (symver)LIBURING_0.1 0.1-1
  io_uring_get_sqe@LIBURING_0.1 0.1-1
  io_uring_queue_exit@LIBURING_0.1 0.1-1
diff --git a/debian/rules b/debian/rules
index f26271e..d0b4eea 100755
--- a/debian/rules
+++ b/debian/rules
@@ -21,7 +21,7 @@ endif
 
 export CC
 
-lib := liburing1
+lib := liburing2
 libdbg := $(lib)-dbg
 libudeb := $(lib)-udeb
 libdev := liburing-dev
