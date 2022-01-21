Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1AD4964FC
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 19:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382089AbiAUS0n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 13:26:43 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:50888 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382083AbiAUS0m (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 21 Jan 2022 13:26:42 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 9CE411FA01;
        Fri, 21 Jan 2022 18:26:35 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Liu Changcheng <changcheng.liu@aliyun.com>,
        Eric Wong <e@80x24.org>
Subject: [PATCH v3 3/7] debian/rules: fix for newer debhelper
Date:   Fri, 21 Jan 2022 18:26:31 +0000
Message-Id: <20220121182635.1147333-4-e@80x24.org>
In-Reply-To: <20220121182635.1147333-1-e@80x24.org>
References: <20220121182635.1147333-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When testing on my Debian 11.x (stable) system, --add-udeb
causes the following build error:

  dh_makeshlibs: error: The udeb liburing1-udeb does not contain any shared
  libraries but --add-udeb=liburing1-udeb was passed!?
  make: *** [debian/rules:82: binary-arch] Error 255

Reading the current dh_makeshlibs(1) manpage reveals --add-udeb
is nowadays implicit as of debhelper 12.3 and no longer
necessary.  Compatibility with older debhelper on Debian
oldstable (buster) remains intact.  Tested with debhelper 12.1.1
on Debian 10.x (buster) and debhelper 13.3.4 on Debian 11.x
(bullseye).  Ubuntu was tested by Stefan since its version
strings contain non-numeric values (e.g. "12.10ubuntu1")

Tested-by: Stefan Metzmacher <metze@samba.org>
Link: https://lore.kernel.org/io-uring/8ccd3b34-bd3a-6c9f-fdb6-64d1b3b43f64@samba.org/
Signed-off-by: Eric Wong <e@80x24.org>
---
 debian/rules | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/debian/rules b/debian/rules
index 1a334b3..6631b10 100755
--- a/debian/rules
+++ b/debian/rules
@@ -70,7 +70,15 @@ binary-arch: install-arch
 	dh_strip -a --ddeb-migration='$(libdbg) (<< 0.3)'
 	dh_compress -a
 	dh_fixperms -a
-	dh_makeshlibs -a --add-udeb '$(libudeb)'
+
+# --add-udeb is needed for < 12.3, and breaks with auto-detection
+#  on debhelper 13.3.4, at least
+	if perl -MDebian::Debhelper::Dh_Version -e \
+	'($$v) = ($$Debian::Debhelper::Dh_Version::version =~ /\A([\d\.]+)/);' \
+	-e 'exit(eval("v$$v") lt v12.3)'; \
+		then dh_makeshlibs -a; else \
+		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
+
 	dh_shlibdeps -a
 	dh_installdeb -a
 	dh_gencontrol -a
