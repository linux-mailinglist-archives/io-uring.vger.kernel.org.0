Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33814562EA
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 19:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhKRSx2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 13:53:28 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:40956 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233974AbhKRSxV (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Nov 2021 13:53:21 -0500
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 8A6B91F9F4;
        Thu, 18 Nov 2021 18:50:20 +0000 (UTC)
Date:   Thu, 18 Nov 2021 18:50:20 +0000
From:   Eric Wong <e@80x24.org>
To:     io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCHv2 8/7] debian/rules: fix version comparison for Ubuntu
Message-ID: <20211118185020.M466694@dcvr>
References: <20211116224456.244746-1-e@80x24.org>
 <20211118031016.354105-1-e@80x24.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211118031016.354105-1-e@80x24.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Perl version strings do not accept values such as "12.10ubuntu1",
so only compare the digits and "." parts at the beginning.

Tested-by: Stefan Metzmacher <metze@samba.org>
Link: https://lore.kernel.org/io-uring/8ccd3b34-bd3a-6c9f-fdb6-64d1b3b43f64@samba.org/
Signed-off-by: Eric Wong <e@80x24.org>
---
 debian/rules | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/debian/rules b/debian/rules
index cd41bb8..d0b4eea 100755
--- a/debian/rules
+++ b/debian/rules
@@ -84,7 +84,8 @@ binary-arch: install-arch
 # --add-udeb is needed for < 12.3, and breaks with auto-detection
 #  on debhelper 13.3.4, at least
 	if perl -MDebian::Debhelper::Dh_Version -e \
-	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") lt v12.3)'; \
+	'($$v) = ($$Debian::Debhelper::Dh_Version::version =~ /\A([\d\.]+)/);' \
+	-e 'exit(eval("v$$v") lt v12.3)'; \
 		then dh_makeshlibs -a; else \
 		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
 
