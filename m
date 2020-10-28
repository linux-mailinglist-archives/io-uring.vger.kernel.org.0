Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02B629D375
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 22:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgJ1VoM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 17:44:12 -0400
Received: from out0.migadu.com ([94.23.1.103]:55878 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgJ1VoM (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 28 Oct 2020 17:44:12 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bl4ckb0ne.ca;
        s=default; t=1603855688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YaUrnbf+QSRZ25ulaDmEnq/GiKEToTyBYilmC+d0I+Y=;
        b=LIw3a2/Of08S2b217TWqLi5t3eQNL3a8XMGLjwXVCiml5l4J5QBdcf6I5xcFAYQGK5ESH4
        RiBdxASRhYDv19THHiq2kLxdYQG6yjCmW/zvxPZwxSFGgYh1rKfdTiLDrml1wFRTgPePdw
        3tqFaQcHzQ+5qhj4IbWO3HdF8WjhTtQ=
From:   Simon Zeni <simon@bl4ckb0ne.ca>
To:     io-uring@vger.kernel.org
Cc:     Simon Zeni <simon@bl4ckb0ne.ca>
Subject: [PATCH] Fix compilation with iso C standard
Date:   Tue, 27 Oct 2020 23:18:25 -0400
Message-Id: <20201028031824.16413-1-simon@bl4ckb0ne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 0.00
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The whole repo can now be built with iso C standard (c89, c99 and c11)

Signed-off-by: Simon Zeni <simon@bl4ckb0ne.ca>
---

References to the compiler extension `typeof` have been changed to
`__typeof__` for portability. See [GCC's documentation][1] about
`typeof`.

I've added the definition `_POSIX_C_SOURCE` in the source files that are
using functions not defined in by the POSIX standard, fixing a few
occurences of `sigset_t` not being defined.

I've also added the definition `_BSD_SOURCE` in `setup.c` and
`syscall.c` for respectively the `madvise` function (I know that
`posix_madvise` exists, but there is not equivalent for
`MADV_DONTFORK`), and `syscall`.

Cheers,

Simon

[1]: https://gcc.gnu.org/onlinedocs/gcc/Typeof.html

 src/include/liburing/barrier.h | 8 ++++----
 src/queue.c                    | 2 ++
 src/register.c                 | 2 ++
 src/setup.c                    | 3 +++
 src/syscall.c                  | 2 ++
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/src/include/liburing/barrier.h b/src/include/liburing/barrier.h
index a4a59fb..89ac682 100644
--- a/src/include/liburing/barrier.h
+++ b/src/include/liburing/barrier.h
@@ -56,17 +56,17 @@ static inline T io_uring_smp_load_acquire(const T *p)
 #include <stdatomic.h>

 #define IO_URING_WRITE_ONCE(var, val)				\
-	atomic_store_explicit((_Atomic typeof(var) *)&(var),	\
+	atomic_store_explicit((_Atomic __typeof__(var) *)&(var),	\
 			      (val), memory_order_relaxed)
 #define IO_URING_READ_ONCE(var)					\
-	atomic_load_explicit((_Atomic typeof(var) *)&(var),	\
+	atomic_load_explicit((_Atomic __typeof__(var) *)&(var),	\
 			     memory_order_relaxed)

 #define io_uring_smp_store_release(p, v)			\
-	atomic_store_explicit((_Atomic typeof(*(p)) *)(p), (v), \
+	atomic_store_explicit((_Atomic __typeof__(*(p)) *)(p), (v), \
 			      memory_order_release)
 #define io_uring_smp_load_acquire(p)				\
-	atomic_load_explicit((_Atomic typeof(*(p)) *)(p),	\
+	atomic_load_explicit((_Atomic __typeof__(*(p)) *)(p),	\
 			     memory_order_acquire)
 #endif

diff --git a/src/queue.c b/src/queue.c
index 24fde2d..053d430 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: MIT */
+#define _POSIX_C_SOURCE 200112L
+
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
diff --git a/src/register.c b/src/register.c
index f3787c0..994aaff 100644
--- a/src/register.c
+++ b/src/register.c
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: MIT */
+#define _POSIX_C_SOURCE 200112L
+
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
diff --git a/src/setup.c b/src/setup.c
index 8e14085..ce2ff4f 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: MIT */
+#define _BSD_SOURCE
+
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -6,6 +8,7 @@
 #include <errno.h>
 #include <string.h>
 #include <stdlib.h>
+#include <signal.h>

 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
diff --git a/src/syscall.c b/src/syscall.c
index 598b531..3f9aa9f 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: MIT */
+#define _BSD_SOURCE
+
 /*
  * Will go away once libc support is there
  */
--
2.29.1
