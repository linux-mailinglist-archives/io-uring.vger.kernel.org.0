Return-Path: <io-uring+bounces-8676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C97CB05094
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 07:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C79A24A74CF
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 05:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB61625F99B;
	Tue, 15 Jul 2025 05:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="ZIhi5pfT"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF8211A35;
	Tue, 15 Jul 2025 05:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556005; cv=none; b=gimNuQLwmY11K8YpCqaAJb5GIdpCj15G/15GIgYAtYe6ctPyokVm4mBKq0Cm7bcjNu+sHZTDq8zTeSLpB+uX90CAbZqGdNfsUtesPibr26mM8alvW8m0EeFE999wfjFxhCxUdV6rq5hTlSjhAqpnMTdq6d8s/KKunxGzyt/qBwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556005; c=relaxed/simple;
	bh=M4kWDyZCqYHuWnsGkdgcYbAx+5ci5psYJKq6L5JYEH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ulHkdY1Yk/ajwohgQdeoSP0rdRnnWM1AfNocNpL4qIwtWaW4ubmiPahUl8B40q8/9m/IeAAx9h0m1FVnn1IxwxvvXJnJA6GJ0SSHkCioqtE7bVU5g9Q2XKt5sSDiOGbglWelr5bHHWtSz5PFQHGWZZuXsJ3jsUa2KPs5V3YHGhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=ZIhi5pfT; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752555996;
	bh=M4kWDyZCqYHuWnsGkdgcYbAx+5ci5psYJKq6L5JYEH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=ZIhi5pfTkYwr5WPSGDV9MMUub7QPY1/ty6c+SJ4fEBsuTolic3DQDJtHu/6tDyqAz
	 ZO9t9zKb/rRZSEgcWRpRz5EnIUfmmTTKTzJ08+mSH1Uu89VWWTABo4uO7H1ohY8A40
	 snyeEVIwYif6vmzE+HRZqKyhbCYuTDpGfWG0BA8Be9xNRvHMepLWXJ1zkBk2hlVqhq
	 MpnChGp/M7Y+gy7b24leJHbwTEL9JFfQBgLy7++5RkaXHiKPi8X8zeb3IK+TnONvtc
	 f/JvPd/NW2b0ZSr2MnusmRoBQx+T4pUwnZNX/6E58SOLkkLQWT+tFdPIxXq1S7QjCw
	 X+KoBKI3GNOHg==
Received: from server-vie001.gnuweeb.org (unknown [192.168.57.1])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 526C52109A3A;
	Tue, 15 Jul 2025 05:06:36 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing 2/3] test: Move `memfd_create()` to helpers.c, make it accessible for all tests
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Tue, 15 Jul 2025 12:06:28 +0700
Message-Id: <20250715050629.1513826-3-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
References: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, the static definition of `memfd_create()` was limited to
io_uring_register.c. Now, promote it to a shared location accessible
to all test cases, ensuring that future tests using `memfd_create()`
do not trigger build failures on Android targets where the syscall
is undefined in the standard headers. It improves portability and
prevents regressions across test builds.

Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
---
 test/helpers.c           |  8 ++++++++
 test/helpers.h           |  5 +++++
 test/io_uring_register.c | 11 -----------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/test/helpers.c b/test/helpers.c
index 0589548..f1d4477 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -18,6 +18,14 @@
 #include "helpers.h"
 #include "liburing.h"
 
+#ifndef CONFIG_HAVE_MEMFD_CREATE
+#include <sys/syscall.h>
+int memfd_create(const char *name, unsigned int flags)
+{
+	return (int)syscall(SYS_memfd_create, name, flags);
+}
+#endif
+
 /*
  * Helper for allocating memory in tests.
  */
diff --git a/test/helpers.h b/test/helpers.h
index 3f0c11a..8ab0920 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -122,6 +122,11 @@ unsigned long long mtime_since_now(struct timeval *tv);
 unsigned long long utime_since(const struct timeval *s, const struct timeval *e);
 unsigned long long utime_since_now(struct timeval *tv);
 
+#ifndef CONFIG_HAVE_MEMFD_CREATE
+#include <linux/memfd.h>
+#endif
+int memfd_create(const char *name, unsigned int flags);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index f08f0ca..c36c4d8 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -32,17 +32,6 @@ static int pagesize;
 static rlim_t mlock_limit;
 static int devnull;
 
-#if !defined(CONFIG_HAVE_MEMFD_CREATE)
-#include <sys/syscall.h>
-#include <linux/memfd.h>
-
-static int memfd_create(const char *name, unsigned int flags)
-{
-	return (int)syscall(SYS_memfd_create, name, flags);
-}
-#endif
-
-
 static int expect_fail(int fd, unsigned int opcode, void *arg,
 		       unsigned int nr_args, int error, int error2)
 {
-- 
Alviro Iskandar Setiawan


