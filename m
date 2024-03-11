Return-Path: <io-uring+bounces-888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F321878552
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 17:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33AFF1F22C94
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 16:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309E556448;
	Mon, 11 Mar 2024 16:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwaRu8PO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DF356445;
	Mon, 11 Mar 2024 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710174040; cv=none; b=uYa5U8Yfxc0W+Go0l4L4DEshG8G9O93ZTz6y71KwDF/nBPNDYLOmL2BpTTbMMqbh2TEMSjsHotbLZQafdG+9lIp9jT7qsc33y9tNQ5c4pLxBlYSsjjecIj4b/mjUwHePLmW/X12ErycWjjnOtzdE+/N7E2W7rDpGJ89hBmdYuGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710174040; c=relaxed/simple;
	bh=wd8neVZpk/GvLCTO+77Ndomdio0+UKtd1+l8xOPggWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+GmhYaUXWGfjhULOiILX2HeuAsGk9PQaRsVnA8IORG1hk/Ou4CZgHn7Jp847FbVoksJ6N0NC4+2Szgrg8iT6wYDggHuwD2dRz/uj/ZYIexadndOpq9ikoGbcr3ZGH4q7I6gXVuST772cmNZTWVTrBV8DjX6LzUr7EN+uTmei80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwaRu8PO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F62C433F1;
	Mon, 11 Mar 2024 16:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710174039;
	bh=wd8neVZpk/GvLCTO+77Ndomdio0+UKtd1+l8xOPggWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwaRu8POPENlEeaB26XFdLLRycRZZv5WkTlFYWoJfcwUgieDLO/qAKXpbmTTMnMGy
	 WcQfa0k6kAMQe3HCXi8Ayj6xQTyRdA36t2vChiKpwFTbkyGBX+6za9jZMGyx0irco0
	 9BnS34mB+nr0fTdQ3nynNQNE/rwHhtOXINXgzZWVPtMi0YuNe0FMuQBUGBGG32TQkf
	 NbghaloNQamSmg2u2CGEFMcq3z+V9Twy+N9egLR0kb5FE1DFG2uRhFCtspxraU9uj8
	 k8+JR07Yl5+ryCPgOuCZQpqrtLRY5yVFl0fMYCm7WqFt+xx5eqDOZGR+SjsCK3oJ11
	 R0UnEPWUGgoNg==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: io-uring@vger.kernel.org
Subject: [PATCH v2 3/3] common/rc: notrun if io_uring is disabled by sysctl
Date: Tue, 12 Mar 2024 00:20:29 +0800
Message-ID: <20240311162029.1102849-4-zlang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240311162029.1102849-1-zlang@kernel.org>
References: <20240311162029.1102849-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If kernel supports io_uring, userspace still can/might disable that
supporting by set /proc/sys/kernel/io_uring_disabled=2. Let's notrun
if io_uring is disabled by that way.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 README        |  6 ++++++
 common/rc     | 10 ++++++++++
 src/feature.c | 19 ++++++++++++-------
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/README b/README
index c46690c4..477136de 100644
--- a/README
+++ b/README
@@ -142,6 +142,12 @@ Setup Environment
    https://www.lscdweb.com/registered/udf_verifier.html, then copy the udf_test
    binary to xfstests/src/.
 
+8. (optional) To do io_uring related testing, please make sure below 3 things:
+     1) kernel is built with CONFIG_IO_URING=y
+     2) sysctl -w kernel.io_uring_disabled=0 (or set it to 2 to disable io_uring
+        testing dynamically if kernel supports)
+     3) install liburing development package contains liburing.h before building
+        fstests
 
 For example, to run the tests with loopback partitions:
 
diff --git a/common/rc b/common/rc
index 50dde313..1406d8d9 100644
--- a/common/rc
+++ b/common/rc
@@ -2317,6 +2317,8 @@ _require_aiodio()
 # this test requires that the kernel supports IO_URING
 _require_io_uring()
 {
+	local n
+
 	$here/src/feature -R
 	case $? in
 	0)
@@ -2324,6 +2326,14 @@ _require_io_uring()
 	1)
 		_notrun "kernel does not support IO_URING"
 		;;
+	2)
+		n=$(sysctl -n kernel.io_uring_disabled 2>/dev/null)
+		if [ "$n" != "0" ];then
+			_notrun "io_uring isn't enabled totally by admin"
+		else
+			_fail "unexpected EPERM error, please check selinux or something else"
+		fi
+		;;
 	*)
 		_fail "unexpected error testing for IO_URING support"
 		;;
diff --git a/src/feature.c b/src/feature.c
index 941f96fb..7e474ce5 100644
--- a/src/feature.c
+++ b/src/feature.c
@@ -232,15 +232,20 @@ check_uring_support(void)
 	int err;
 
 	err = io_uring_queue_init(1, &ring, 0);
-	if (err == 0)
+	switch (err) {
+	case 0:
 		return 0;
-
-	if (err == -ENOSYS) /* CONFIG_IO_URING=n */
+	case -ENOSYS:
+		/* CONFIG_IO_URING=n */
 		return 1;
-
-	fprintf(stderr, "unexpected error from io_uring_queue_init(): %s\n",
-		strerror(-err));
-	return 2;
+	case -EPERM:
+		/* Might be due to sysctl io_uring_disabled isn't 0 */
+		return 2;
+	default:
+		fprintf(stderr, "unexpected error from io_uring_queue_init(): %s\n",
+			strerror(-err));
+		return 100;
+	}
 #else
 	/* liburing is unavailable, assume IO_URING is unsupported */
 	return 1;
-- 
2.43.0


