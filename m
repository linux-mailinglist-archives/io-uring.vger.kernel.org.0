Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FD2295029
	for <lists+io-uring@lfdr.de>; Wed, 21 Oct 2020 17:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436649AbgJUPtI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Oct 2020 11:49:08 -0400
Received: from out0.migadu.com ([94.23.1.103]:54628 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731691AbgJUPtI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 21 Oct 2020 11:49:08 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 11:49:07 EDT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bl4ckb0ne.ca;
        s=default; t=1603294952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aWStt4hND+SzWI9eFO/cqUP/w5pbQ6OMmdBySDI3QP0=;
        b=MTgntzYttvIJBjnGp8hT4C/d/YM5TiiqRVRjPsI+20KyTj89NI3IkbdZdt7IEt3KCnvCmp
        WAQqBNTGY82Wb3oZTlUalfhoNk8PaJrDA0xOSmvO22Z098T51V5oFK96NTQcJhYyF9eWTs
        oZQfnpcctQxcoSbF5/2OMMXN88cgh8E=
From:   Simon Zeni <simon@bl4ckb0ne.ca>
To:     io-uring@vger.kernel.org
Cc:     Simon Zeni <simon@bl4ckb0ne.ca>
Subject: [PATCH liburing] add C11 support
Date:   Wed, 21 Oct 2020 11:42:16 -0400
Message-Id: <20201021154215.148695-1-simon@bl4ckb0ne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 0.00
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Simon Zeni <simon@bl4ckb0ne.ca>
---
 src/include/liburing/barrier.h | 8 ++++----
 src/queue.c                    | 2 ++
 src/register.c                 | 2 ++
 src/setup.c                    | 2 ++
 src/syscall.c                  | 2 ++
 5 files changed, 12 insertions(+), 4 deletions(-)

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
index 24fde2d..86fa5eb 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -1,3 +1,5 @@
+#define _POSIX_C_SOURCE 200112L
+
 /* SPDX-License-Identifier: MIT */
 #include <sys/types.h>
 #include <sys/stat.h>
diff --git a/src/register.c b/src/register.c
index f3787c0..b9c657c 100644
--- a/src/register.c
+++ b/src/register.c
@@ -1,3 +1,5 @@
+#define _POSIX_C_SOURCE 200112L
+
 /* SPDX-License-Identifier: MIT */
 #include <sys/types.h>
 #include <sys/stat.h>
diff --git a/src/setup.c b/src/setup.c
index 8e14085..0538e27 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -1,3 +1,5 @@
+#define _DEFAULT_SOURCE
+
 /* SPDX-License-Identifier: MIT */
 #include <sys/types.h>
 #include <sys/stat.h>
diff --git a/src/syscall.c b/src/syscall.c
index 598b531..543aa77 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -1,3 +1,5 @@
+#define _DEFAULT_SOURCE
+
 /* SPDX-License-Identifier: MIT */
 /*
  * Will go away once libc support is there
-- 
2.29.0

