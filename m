Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF6C4B297D
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 16:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiBKP6g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 10:58:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344108AbiBKP6g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 10:58:36 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF511A8
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 07:58:35 -0800 (PST)
Received: from integral2.. (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id C3F1B7E2A2;
        Fri, 11 Feb 2022 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644595115;
        bh=dUciLIWfIrZMVgtawkGD50/UMdzFURrXWijfjIOGhu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAMr45uXQo9NEwDevn7/ujAyiT2Y9si81rNFXzyoXXdjy3dO7yuZMTMmvlgrx6/P7
         68kVmZKpmkEN/IimkTY1pKsPcSGnRuPLWWeRfCGNhk3fWGuPPKLbZya/zpeBP/b0wJ
         M7mSNP5/a0IV+iy6W8eJx9oLJkWrIq4yQ4VEU1xQM4O64w5gQ8MJbN2A9olURH3Ln9
         H5g9ZiiKQHJDSJjxgy/ObTnmJSGn366ldCtEfA357R/eMVGJPr5ElH6hgmw51p6LHR
         QkORMrnLUnBMj2hGvPWGyWVFVYEjD5sEtalJfq/yMQBugivD7nyIJ3sPvFt7t9OQDd
         apTj1WScBIXGQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Nugra <richiisei@gmail.com>
Subject: [PATCH liburing v1 3/4] lib.h: Split off lib header for arch specific and generic
Date:   Fri, 11 Feb 2022 22:57:52 +0700
Message-Id: <20220211155753.143698-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
References: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1) Clean up #ifdef/#endif for get_page_size().

2) Always use arch specific code for x86-64 to reduce libc usage.

3) For other archs, we will use src/arch/generic/lib.h header that
   contains libc wrapper.

At this point, on x86-64, we only use libc for memset(), malloc() and
free().

Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/generic/lib.h | 21 ++++++++++++++++++++
 src/arch/x86/lib.h     | 20 ++++++++++++-------
 src/lib.h              | 45 ++++++++++++++++++------------------------
 3 files changed, 53 insertions(+), 33 deletions(-)
 create mode 100644 src/arch/generic/lib.h

diff --git a/src/arch/generic/lib.h b/src/arch/generic/lib.h
new file mode 100644
index 0000000..737e795
--- /dev/null
+++ b/src/arch/generic/lib.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef __INTERNAL__LIBURING_LIB_H
+	#error "This file should be included from src/lib.h (liburing)"
+#endif
+
+#ifndef LIBURING_ARCH_GENERIC_LIB_H
+#define LIBURING_ARCH_GENERIC_LIB_H
+
+static inline long get_page_size(void)
+{
+	long page_size;
+
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0)
+		page_size = 4096;
+
+	return page_size;
+}
+
+#endif /* #ifndef LIBURING_ARCH_GENERIC_LIB_H */
diff --git a/src/arch/x86/lib.h b/src/arch/x86/lib.h
index 65ad396..bacf74e 100644
--- a/src/arch/x86/lib.h
+++ b/src/arch/x86/lib.h
@@ -1,15 +1,15 @@
 /* SPDX-License-Identifier: MIT */
 
+#ifndef __INTERNAL__LIBURING_LIB_H
+	#error "This file should be included from src/lib.h (liburing)"
+#endif
+
 #ifndef LIBURING_ARCH_X86_LIB_H
 #define LIBURING_ARCH_X86_LIB_H
 
-#ifndef LIBURING_LIB_H
-#  error "This file should be included from src/lib.h (liburing)"
-#endif
-
 #if defined(__x86_64__)
 
-static inline long __arch_impl_get_page_size(void)
+static inline long get_page_size(void)
 {
 	return 4096;
 }
@@ -17,9 +17,15 @@ static inline long __arch_impl_get_page_size(void)
 #else /* #if defined(__x86_64__) */
 
 /*
- * TODO: Add x86 (32-bit) support here.
+ * For x86 (32-bit), fallback to libc wrapper.
+ * We can't use CONFIG_NOLIBC for x86 (32-bit) at the moment.
+ *
+ * TODO: Add x86 (32-bit) nolibc support.
  */
-#error "x86 (32-bit) is currently not supported for nolibc builds"
+#ifdef CONFIG_NOLIBC
+	#error "x86 (32-bit) is currently not supported for nolibc builds"
+#endif
+#include "../generic/lib.h"
 
 #endif /* #if defined(__x86_64__) */
 
diff --git a/src/lib.h b/src/lib.h
index bd02805..6672cc5 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -6,23 +6,31 @@
 #include <string.h>
 #include <unistd.h>
 
-#ifdef CONFIG_NOLIBC
-#  if defined(__x86_64__) || defined(__i386__)
-#    include "arch/x86/lib.h"
-#  else
-#    error "This arch doesn't support building liburing without libc"
-#  endif
+#define __INTERNAL__LIBURING_LIB_H
+#if defined(__x86_64__) || defined(__i386__)
+	#include "arch/x86/lib.h"
+#else
+	/*
+	 * We don't have nolibc support for this arch. Must use libc!
+	 */
+	#ifdef CONFIG_NOLIBC
+		#error "This arch doesn't support building liburing without libc"
+	#endif
+	/* libc wrappers. */
+	#include "arch/generic/lib.h"
 #endif
+#undef __INTERNAL__LIBURING_LIB_H
+
 
 #ifndef offsetof
-# define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
+	#define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
 #endif
 
 #ifndef container_of
-# define container_of(PTR, TYPE, FIELD) ({				\
-	__typeof__(((TYPE *)0)->FIELD) *__FIELD_PTR = (PTR);		\
-	(TYPE *)((char *) __FIELD_PTR - offsetof(TYPE, FIELD));		\
-})
+	#define container_of(PTR, TYPE, FIELD) ({			\
+		__typeof__(((TYPE *)0)->FIELD) *__FIELD_PTR = (PTR);	\
+		(TYPE *)((char *) __FIELD_PTR - offsetof(TYPE, FIELD));	\
+	})
 #endif
 
 void *__uring_malloc(size_t len);
@@ -46,19 +54,4 @@ static inline void uring_free(void *ptr)
 #endif
 }
 
-static inline long get_page_size(void)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_get_page_size();
-#else
-	long page_size;
-
-	page_size = sysconf(_SC_PAGESIZE);
-	if (page_size < 0)
-		page_size = 4096;
-
-	return page_size;
-#endif
-}
-
 #endif /* #ifndef LIBURING_LIB_H */
-- 
2.32.0

