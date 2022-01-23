Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92AC497087
	for <lists+io-uring@lfdr.de>; Sun, 23 Jan 2022 08:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbiAWHna (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jan 2022 02:43:30 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:48064
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230390AbiAWHna (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jan 2022 02:43:30 -0500
Received: from integral2.. (unknown [125.163.200.97])
        by gnuweeb.org (Postfix) with ESMTPSA id 403F9C2DAE;
        Sun, 23 Jan 2022 07:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1642923808;
        bh=LGnmNCnB7OqjUzoB8+bGGCdld3PTk7xq2rS7VduDXa0=;
        h=From:To:Cc:Subject:Date:From;
        b=cQJFgeNGRF1JZ04DTe59jk2SzLVX/P7x/mzZo+HaGyD9b8w3aE/8q03xwRUofubNA
         FUPeQQmmAr07j3Mmqzwh3UmsAskQW/Z7GMPZvt8ujHerl1Rok/j6cK6BfnsOv2zheY
         zntsomMM+MlGXeoS3Wj88Rch3jd0nj4613j0Lgj90+bfV3my/67tgHruMCNanzuWbS
         NYOUpLhe6jzf5efK0gQ+dop8zdCxy4AkXRLmXr6FC3S/UeVaImU1JZ/udWXLpLTS8A
         05TB3fRTrqDivSJJ9YZVKDnxs1M2+wqUtG8yrfxfRNnQv4TduprXxdE49dlxMIlADu
         xWPn++3QDHjZQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Miyasaki Kohaku <kohaku.mski@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Subject: [PATCH] nolibc: Don't use `malloc()` and `free()` as the function name
Date:   Sun, 23 Jan 2022 14:42:30 +0700
Message-Id: <20220123074230.3353274-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Miyasaki reports that liburing with CONFIG_NOLIBC breaks apps that
use libc. The first spotted issue was a realloc() call that results
in an invalid pointer, and then the program exits with SIGABRT.

The cause is liburing nolibc overrides malloc() and free() from the
libc (especially when we statically link the "liburing.a" to the apps
that use libc).

The malloc() and free() from liburing nolibc use hand-coded Assembly
to invoke mmap() and munmap() syscall directly. That means any
allocation from malloc() is not a valid object with respect to the
libc, and free() will also break the app if we use it to free a
pointer from a libc function (e.g., strdup()).

liburing nolibc should not break any libc app.

This renames the malloc() and free() to __uring_malloc() and
__uring_free(). Also, add new inline functions to wrap the malloc()
and free(), they are uring_malloc() and uring_free(). These wrappers
will call the appropriate functions depending on CONFIG_NOLIBC.

Fixes: f48ee3168cdc325233825603269f304d348d323c ("Add nolibc build support")
Cc: Tea Inside Mailing List <timl@vger.teainside.org>
Reported-by: Miyasaki Kohaku <kohaku.mski@gmail.com>
Tested-by: Miyasaki Kohaku <kohaku.mski@gmail.com>
Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h    | 20 ++++++++++++++++++++
 src/nolibc.c |  4 ++--
 src/setup.c  |  6 +++---
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/src/lib.h b/src/lib.h
index 58d91be..bd02805 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -25,6 +25,26 @@
 })
 #endif
 
+void *__uring_malloc(size_t len);
+void __uring_free(void *p);
+
+static inline void *uring_malloc(size_t len)
+{
+#ifdef CONFIG_NOLIBC
+	return __uring_malloc(len);
+#else
+	return malloc(len);
+#endif
+}
+
+static inline void uring_free(void *ptr)
+{
+#ifdef CONFIG_NOLIBC
+	__uring_free(ptr);
+#else
+	free(ptr);
+#endif
+}
 
 static inline long get_page_size(void)
 {
diff --git a/src/nolibc.c b/src/nolibc.c
index 251780b..f7848d3 100644
--- a/src/nolibc.c
+++ b/src/nolibc.c
@@ -23,7 +23,7 @@ struct uring_heap {
 	char		user_p[] __attribute__((__aligned__));
 };
 
-void *malloc(size_t len)
+void *__uring_malloc(size_t len)
 {
 	struct uring_heap *heap;
 
@@ -36,7 +36,7 @@ void *malloc(size_t len)
 	return heap->user_p;
 }
 
-void free(void *p)
+void __uring_free(void *p)
 {
 	struct uring_heap *heap;
 
diff --git a/src/setup.c b/src/setup.c
index 891fc43..1e4dbf4 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -178,7 +178,7 @@ struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
 	int r;
 
 	len = sizeof(*probe) + 256 * sizeof(struct io_uring_probe_op);
-	probe = malloc(len);
+	probe = uring_malloc(len);
 	if (!probe)
 		return NULL;
 	memset(probe, 0, len);
@@ -187,7 +187,7 @@ struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
 	if (r >= 0)
 		return probe;
 
-	free(probe);
+	uring_free(probe);
 	return NULL;
 }
 
@@ -208,7 +208,7 @@ struct io_uring_probe *io_uring_get_probe(void)
 
 void io_uring_free_probe(struct io_uring_probe *probe)
 {
-	free(probe);
+	uring_free(probe);
 }
 
 static inline int __fls(int x)
-- 
2.32.0

