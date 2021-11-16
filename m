Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA10E453C68
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 23:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhKPW4g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 17:56:36 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:43828 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhKPW4g (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 16 Nov 2021 17:56:36 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id A83701FA01;
        Tue, 16 Nov 2021 22:44:56 +0000 (UTC)
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 3/4] debian/rules: fix for newer debhelper
Date:   Tue, 16 Nov 2021 22:44:55 +0000
Message-Id: <20211116224456.244746-4-e@80x24.org>
In-Reply-To: <20211116224456.244746-1-e@80x24.org>
References: <20211116224456.244746-1-e@80x24.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When testing on my Debian 11.x (stable) system, --add-udeb
causes the following build error:

  dh_makeshlibs: error: The udeb liburing1-udeb does not contain any shared librar
  ies but --add-udeb=liburing1-udeb was passed!?
  make: *** [debian/rules:82: binary-arch] Error 255

Reading the current dh_makeshlibs(1) manpage reveals --add-udeb
is nowadays implicit as of debhelper 12.3 and no longer
necessary.  Compatibility with Debian oldstable (buster) remains
intact.  Tested with debhelper 12.1.1 on Debian 10.x (buster)
and debhelper 13.3.4 on Debian 11.x (bullseye).

Signed-off-by: Eric Wong <e@80x24.org>
---
 debian/rules | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/debian/rules b/debian/rules
index 1a334b3..2a0d563 100755
--- a/debian/rules
+++ b/debian/rules
@@ -70,7 +70,14 @@ binary-arch: install-arch
 	dh_strip -a --ddeb-migration='$(libdbg) (<< 0.3)'
 	dh_compress -a
 	dh_fixperms -a
-	dh_makeshlibs -a --add-udeb '$(libudeb)'
+
+# --add-udeb is needed for <= 12.3, and breaks with auto-detection
+#  on debhelper 13.3.4, at least
+	if perl -MDebian::Debhelper::Dh_Version -e \
+	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") le v12.3)'; \
+		then dh_makeshlibs -a; else \
+		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
+
 	dh_shlibdeps -a
 	dh_installdeb -a
 	dh_gencontrol -a
