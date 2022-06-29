Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8707B55F265
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiF2A2h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiF2A2g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:36 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5156275EC
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:35 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 532BC7FBEF;
        Wed, 29 Jun 2022 00:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462515;
        bh=lFX0gtBvdl/QClxwZ1H0rjuc8UGox5YBfq11uac/YEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOF3E9eJ5Pgl5F4RBuKE5jCtP0cq3UCwknVZ9EJtpB96y8kYMQXlDHQ5TQu9b41u4
         pGKHxSAmEcrzcLOl+5RfoWXoJT4JuESWh/XA8/u5roG9I65vrwehF31rzh64ayBqRM
         yHghI2/t1Y/C0NZllxDpxwtdfdlyJp8CQpCnLdE2To7PlCm4wP2rxmQMXrij9nFr3/
         2QUHDFSi5Jnoonz6815tGQ4zTDySnlPCEA03+tqaE7WTfPQ7mcFWQ8GLgSCS8w0mJR
         +uu6+QjBPlih16OxKnd2SvcyztSgpG2LawoTG1uOwiLwQyI8qPPK6B9nmIxZ4oTC5t
         y3fVOqLbHLSIA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 6/9] arch: syscall: Remove `__INTERNAL__LIBURING_SYSCALL_H` checks
Date:   Wed, 29 Jun 2022 07:27:50 +0700
Message-Id: <20220629002028.1232579-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629002028.1232579-1-ammar.faizi@intel.com>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

We will include the syscall.h from another place as well. This check
was added by me when refactoring the x86 syscall. For aarch64 we will
include this header from lib.h but we are restricted by this check.

Just remove it for all archs. User shouldn't touch this code directly
anyway.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/arm64/syscall.h   | 4 ----
 src/arch/generic/lib.h     | 4 ----
 src/arch/generic/syscall.h | 4 ----
 src/arch/x86/lib.h         | 4 ----
 src/arch/x86/syscall.h     | 4 ----
 src/syscall.h              | 2 --
 6 files changed, 22 deletions(-)

diff --git a/src/arch/arm64/syscall.h b/src/arch/arm64/syscall.h
index 732ada0..69a36a3 100644
--- a/src/arch/arm64/syscall.h
+++ b/src/arch/arm64/syscall.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: MIT */
 
-#ifndef __INTERNAL__LIBURING_SYSCALL_H
-	#error "This file should be included from src/syscall.h (liburing)"
-#endif
-
 #ifndef LIBURING_ARCH_ARM64_SYSCALL_H
 #define LIBURING_ARCH_ARM64_SYSCALL_H
 
diff --git a/src/arch/generic/lib.h b/src/arch/generic/lib.h
index 737e795..6b006c6 100644
--- a/src/arch/generic/lib.h
+++ b/src/arch/generic/lib.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: MIT */
 
-#ifndef __INTERNAL__LIBURING_LIB_H
-	#error "This file should be included from src/lib.h (liburing)"
-#endif
-
 #ifndef LIBURING_ARCH_GENERIC_LIB_H
 #define LIBURING_ARCH_GENERIC_LIB_H
 
diff --git a/src/arch/generic/syscall.h b/src/arch/generic/syscall.h
index 22252a1..e637890 100644
--- a/src/arch/generic/syscall.h
+++ b/src/arch/generic/syscall.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: MIT */
 
-#ifndef __INTERNAL__LIBURING_SYSCALL_H
-	#error "This file should be included from src/syscall.h (liburing)"
-#endif
-
 #ifndef LIBURING_ARCH_GENERIC_SYSCALL_H
 #define LIBURING_ARCH_GENERIC_SYSCALL_H
 
diff --git a/src/arch/x86/lib.h b/src/arch/x86/lib.h
index e6a74f3..6ece2d4 100644
--- a/src/arch/x86/lib.h
+++ b/src/arch/x86/lib.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: MIT */
 
-#ifndef __INTERNAL__LIBURING_LIB_H
-	#error "This file should be included from src/lib.h (liburing)"
-#endif
-
 #ifndef LIBURING_ARCH_X86_LIB_H
 #define LIBURING_ARCH_X86_LIB_H
 
diff --git a/src/arch/x86/syscall.h b/src/arch/x86/syscall.h
index 43c576b..cb8fb91 100644
--- a/src/arch/x86/syscall.h
+++ b/src/arch/x86/syscall.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: MIT */
 
-#ifndef __INTERNAL__LIBURING_SYSCALL_H
-	#error "This file should be included from src/syscall.h (liburing)"
-#endif
-
 #ifndef LIBURING_ARCH_X86_SYSCALL_H
 #define LIBURING_ARCH_X86_SYSCALL_H
 
diff --git a/src/syscall.h b/src/syscall.h
index 9e72e6f..39a18df 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -70,7 +70,6 @@ static inline bool IS_ERR(const void *ptr)
 	return uring_unlikely((uintptr_t) ptr >= (uintptr_t) -4095UL);
 }
 
-#define __INTERNAL__LIBURING_SYSCALL_H
 #if defined(__x86_64__) || defined(__i386__)
 #include "arch/x86/syscall.h"
 #elif defined(__aarch64__)
@@ -86,7 +85,6 @@ static inline bool IS_ERR(const void *ptr)
 /* libc syscall wrappers. */
 #include "arch/generic/syscall.h"
 #endif
-#undef __INTERNAL__LIBURING_SYSCALL_H
 
 /*
  * For backward compatibility.
-- 
Ammar Faizi

