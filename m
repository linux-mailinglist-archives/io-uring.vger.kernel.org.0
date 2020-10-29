Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEFA29E04C
	for <lists+io-uring@lfdr.de>; Thu, 29 Oct 2020 02:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgJ2BVA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 21:21:00 -0400
Received: from out1.migadu.com ([91.121.223.63]:64758 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730069AbgJ2BUI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 28 Oct 2020 21:20:08 -0400
X-Greylist: delayed 12656 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2020 21:20:07 EDT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bl4ckb0ne.ca;
        s=default; t=1603934406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OtBMpQjIMkPtDq7wXaVt3tBnyQsCf9IiyRVODNv3Uhs=;
        b=MguP4sp67D76+0BWVjvhF7QkWWizgVcNpp6sSU1lQ5S/5d7tO6VWDC6ooRLdA+PcPdjZcy
        TCH26QLggIAq0t9hagZSSlygX+NHiLVJH6rv+HquESHuqY8eu7TyfKTz0XAcXhWhgwykoO
        HsYolFUce+6tF5rbRFrTP9JI2AuAZpw=
From:   Simon Zeni <simon@bl4ckb0ne.ca>
To:     io-uring@vger.kernel.org
Cc:     Simon Zeni <simon@bl4ckb0ne.ca>
Subject: [PATCH v2] Fix compilation with iso C standard (c89, c99 and c11)
Date:   Wed, 28 Oct 2020 21:19:59 -0400
Message-Id: <20201029011959.25554-1-simon@bl4ckb0ne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 0.00
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

- References to the compiler extension `typeof` have been changed to
`__typeof__` for portability. See [GCC's documentation][1] about
`typeof`.

- Added the definition `_POSIX_C_SOURCE` in the source files that are
using functions not defined in by the POSIX standard, fixing a few
occurences of `sigset_t` not being defined.

- Added the definition `_DEFAULT_SOURCE` in `setup.c` and
`syscall.c` for respectively the `madvise` function (`posix_madvise` exists,
but there is not equivalent for`MADV_DONTFORK`), and `syscall`.

[1]: https://gcc.gnu.org/onlinedocs/gcc/Typeof.html

Signed-off-by: Simon Zeni <simon@bl4ckb0ne.ca>
---
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
index 8e14085..dded481 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: MIT */
+#define _DEFAULT_SOURCE
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
index 598b531..49b4ec2 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: MIT */
+#define _DEFAULT_SOURCE
+
 /*
  * Will go away once libc support is there
  */
--
2.29.1

