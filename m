Return-Path: <io-uring+bounces-8691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D07B06AB0
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 02:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89E153AACA5
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 00:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832B4194A65;
	Wed, 16 Jul 2025 00:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="mm/semdS"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E002517A31B;
	Wed, 16 Jul 2025 00:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752626655; cv=none; b=iInUP4l/KMVnzpXAfHWxfGsnhnCYqmEpD414QNuxg7YuQ4DpUUuGrZyYQmjSmhBWmUPWoJ+u22qzp6Bu4fMbNVKr6FNd+OmOHbIGjGhSoNJjCW6zCv8FRQs8KWQgbkUPlb1DWlUn2DD7h96VXkE0plGUFWx5HU+52RbKu/lgiVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752626655; c=relaxed/simple;
	bh=3DOqD1KPdUGm7DrqjlCi+p1ytymuiTFbmOFk0unuYtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TPPSDNqGEBPEuoLxlcz3Sf2BeBNm2ENlyHw3TLAqHIH0xz685mL9zVNqy9TCy1b7t4qPXjosHzBkJB4/mY+yP20mI2j3Z3m2qarqw2Oamho3S5bwVJ3rEPCOGuwhP7jwFGwSu/NSjomsCqlQ37CIcZfq2NtRZpKCLfPWhR3EiTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=mm/semdS; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752626651;
	bh=3DOqD1KPdUGm7DrqjlCi+p1ytymuiTFbmOFk0unuYtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=mm/semdSH3Gw7+cJMStOt7o4emCCrFGel5zLaoPHn2YfBiwExR4EWzyyJdIi+tgx2
	 Qqd3NY2z/uSOPbFuidQw+k86onCC/hgkJF2G/+r7y08BO85kCi2qwgE3bRJejiuQfe
	 Uk21vrrRa1Q42/PyTZEYJMqUw3PKebT2HFF1NLXecm1lIrOPkELf19mv7pDAp01pDr
	 s2q6OL4kt/bHeXBlLNlumo3bZA8JF8kwV7pfQN7pm0QpeeoJ4cwKdeSRsm9uZKZF+d
	 OF8elliCxMmxzQOPvAVvy2Ahq7O2/t+L04t3eC/nvIY1Sezdl3cSqUdNc8LB+pAGYp
	 J+BMqgUkmXfKA==
Received: from localhost.localdomain (unknown [68.183.184.174])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 4033D2109A7D;
	Wed, 16 Jul 2025 00:44:10 +0000 (UTC)
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v2 2/3] test: Move `memfd_create()` to helpers.c, make it accessible for all tests
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed, 16 Jul 2025 07:44:01 +0700
Message-Id: <20250716004402.3902648-3-alviro.iskandar@gnuweeb.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
References: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
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
index 405a812..b53a67d 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -32,17 +32,6 @@ static int pagesize;
 static rlim_t mlock_limit;
 static int devnull;
 
-#if !defined(CONFIG_HAVE_MEMFD_CREATE)
-#include <sys/syscall.h>
-#include <linux/memfd.h>
-
-int memfd_create(const char *name, unsigned int flags)
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


