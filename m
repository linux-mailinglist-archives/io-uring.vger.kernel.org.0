Return-Path: <io-uring+bounces-6580-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 772C9A3DD1B
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 15:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 317D73BAD80
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 14:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2961F03CB;
	Thu, 20 Feb 2025 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="IgLFjm+4"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6581D5AD4;
	Thu, 20 Feb 2025 14:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740062105; cv=none; b=fHsRTbdd/gWBGlZiW3gCsRvp90fU0+JTKS0TSBXvciNWi+somUVDg6XJ8EbhNkjVVjmREeD+1/dlcioA+EfgjN4NE2oMJzxTZxa6QSbEzDSk7SRq7IngNQY7qFYIOkP1b7QdCSN2SxxCTPmc12WghrJ7GY2Yi0Bdcs50TrT5H80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740062105; c=relaxed/simple;
	bh=xxoB+UIOPvZk4BVlBN52bLxBYkRLA3Dg2MLLG17vDCw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ngz0MDM+sMIDKS4d6Bu7BhaMEucDrwXBVb6/ZBVyLexk+87KrweSsFC7IJ8nw2+eeJrtsqV9kn21TpyDjIL9ZKcRm2Di+YkbkXGMVcefGzYYn8mDqJC+aD8ipYiNr0yNKt/sfDqII1ykzlfjL/K5WAr5ccHW0Ljd6gBvZrbZtS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=IgLFjm+4; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1740062101;
	bh=xxoB+UIOPvZk4BVlBN52bLxBYkRLA3Dg2MLLG17vDCw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=IgLFjm+4B5/jg7TpCYIrAhgnHeU9KYvsGApQEOzTGIK+JJh/50NFZiosrQ8ja1nHj
	 RglqIjevgcqDo8TNjzQEUgFLZKsJZlCi9AxQuXikFa/BUuCdZDWS7aRmP5qFZts9EB
	 uvX64oOvBSisPg5HlVhMxD+miPHftldtwfzLD62Gf4nnuMUptuSXx1nAuHNGOICjZr
	 wvnAQMxqGY8dfXoHkJpArWr9juJKsdRLKZRfO+YZcoZxht/5tCZlfxKo7D+Wny3rbO
	 oQTc3LQx66we3Lksx9wzRjVa2X0sqpwy22LXbxY5kScO+8A5RoE+5MRoQBjfUCZA2v
	 MGkS3Q1TvvPgA==
Received: from integral2.. (unknown [182.253.126.96])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 59E8320744A7;
	Thu, 20 Feb 2025 14:34:59 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 3/3] Fix missing `aligned_alloc()` on some Android devices
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Thu, 20 Feb 2025 21:34:22 +0700
Message-Id: <20250220143422.3597245-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250220143422.3597245-1-ammarfaizi2@gnuweeb.org>
References: <20250220143422.3597245-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some Android versions lack `aligned_alloc()` in `<stdlib.h>`. Compiling
on Termux 0.118.0 yields this error:

```
cmd-discard.c:383:11: warning: call to undeclared library function \
'aligned_alloc' with type 'void *(unsigned long, unsigned long)'; ISO \
C99 and later do not support implicit function declarations \
[-Wimplicit-function-declaration]

        buffer = aligned_alloc(lba_size, lba_size);
                 ^
```

To avoid making large changes in tests, define a helper function that
wraps `posix_memalign()` as our own `aligned_alloc()`.

Just another day of working around platform quirks.

Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 examples/helpers.c  | 10 ++++++++++
 examples/helpers.h  |  7 +++++++
 examples/reg-wait.c |  2 ++
 test/helpers.c      | 10 ++++++++++
 test/helpers.h      |  8 ++++++++
 5 files changed, 37 insertions(+)

diff --git a/examples/helpers.c b/examples/helpers.c
index b70ce7c1f314..59b31ecb4aeb 100644
--- a/examples/helpers.c
+++ b/examples/helpers.c
@@ -51,12 +51,22 @@ int setup_listening_socket(int port, int ipv6)
 	if (ret < 0) {
 		perror("bind()");
 		return -1;
 	}
 
 	if (listen(fd, 1024) < 0) {
 		perror("listen()");
 		return -1;
 	}
 
 	return fd;
 }
+
+void *aligned_alloc(size_t alignment, size_t size)
+{
+	void *ret;
+
+	if (posix_memalign(&ret, alignment, size))
+		return NULL;
+
+	return ret;
+}
diff --git a/examples/helpers.h b/examples/helpers.h
index 9b1cf34f9b0d..d73ee4a5bc1a 100644
--- a/examples/helpers.h
+++ b/examples/helpers.h
@@ -1,7 +1,14 @@
 /* SPDX-License-Identifier: MIT */
 #ifndef LIBURING_EX_HELPERS_H
 #define LIBURING_EX_HELPERS_H
 
 int setup_listening_socket(int port, int ipv6);
 
+/*
+ * Some Android versions lack aligned_alloc in stdlib.h.
+ * To avoid making large changes in tests, define a helper
+ * function that wraps posix_memalign as our own aligned_alloc.
+ */
+void *aligned_alloc(size_t alignment, size_t size);
+
 #endif
diff --git a/examples/reg-wait.c b/examples/reg-wait.c
index 0e119aaf4f03..ff61b8d10387 100644
--- a/examples/reg-wait.c
+++ b/examples/reg-wait.c
@@ -4,24 +4,26 @@
  *
  * (C) 2024 Jens Axboe <axboe@kernel.dk>
  */
 #include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include <assert.h>
 #include <sys/time.h>
 #include <liburing.h>
 
+#include "helpers.h"
+
 static unsigned long long mtime_since(const struct timeval *s,
 				      const struct timeval *e)
 {
 	long long sec, usec;
 
 	sec = e->tv_sec - s->tv_sec;
 	usec = (e->tv_usec - s->tv_usec);
 	if (sec > 0 && usec < 0) {
 		sec--;
 		usec += 1000000;
 	}
 
diff --git a/test/helpers.c b/test/helpers.c
index e84aaa7aee15..0718691174de 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -354,12 +354,22 @@ unsigned long long utime_since(const struct timeval *s, const struct timeval *e)
 
 	sec *= 1000000;
 	return sec + usec;
 }
 
 unsigned long long utime_since_now(struct timeval *tv)
 {
 	struct timeval end;
 
 	gettimeofday(&end, NULL);
 	return utime_since(tv, &end);
 }
+
+void *aligned_alloc(size_t alignment, size_t size)
+{
+	void *ret;
+
+	if (posix_memalign(&ret, alignment, size))
+		return NULL;
+
+	return ret;
+}
diff --git a/test/helpers.h b/test/helpers.h
index 9e1cdf5ec05c..d0294eba63e4 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -4,36 +4,44 @@
  */
 #ifndef LIBURING_HELPERS_H
 #define LIBURING_HELPERS_H
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
 #include "liburing.h"
 #include "../src/setup.h"
 #include <arpa/inet.h>
 #include <sys/time.h>
+#include <stdlib.h>
 
 enum t_setup_ret {
 	T_SETUP_OK	= 0,
 	T_SETUP_SKIP,
 };
 
 enum t_test_result {
 	T_EXIT_PASS   = 0,
 	T_EXIT_FAIL   = 1,
 	T_EXIT_SKIP   = 77,
 };
 
+/*
+ * Some Android versions lack aligned_alloc in stdlib.h.
+ * To avoid making large changes in tests, define a helper
+ * function that wraps posix_memalign as our own aligned_alloc.
+ */
+void *aligned_alloc(size_t alignment, size_t size);
+
 /*
  * Helper for binding socket to an ephemeral port.
  * The port number to be bound is returned in @addr->sin_port.
  */
 int t_bind_ephemeral_port(int fd, struct sockaddr_in *addr);
 
 
 /*
  * Helper for allocating memory in tests.
  */
 void *t_malloc(size_t size);
 
-- 
Ammar Faizi


