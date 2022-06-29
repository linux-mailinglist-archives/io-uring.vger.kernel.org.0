Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54795560825
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 19:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiF2R7p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 13:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiF2R7o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 13:59:44 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4F5E9
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:59:43 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id A9EDF800C2;
        Wed, 29 Jun 2022 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656525582;
        bh=tXlRsNACrIIuE5j8bau8IWlvgcABX3OwzjyOsmPpR8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDvje2StSbllRIjCDNlUJYAVkWiJLy2Hn8Ztk/Kuhgr4EjkWPRUUOHLIqAUDpnVmL
         kVS3AnG42tmVCJNqF+nsLO+pgOHD7cPM1R1vnpkSS/QwCv3XdeGwGHhL9jriKq3oqX
         Ph9x5AgRI207RNDO2PsLHl/hCkG6kJjOqMYhcre8pMgza+gRDmfDB8E1VgYSijhMrf
         1uZ7iXqNbZQpxii2QGXPbbcqM4CqntYGITQLgh1GCsOD8rV5l3p54uv16+xubaZ2ay
         PotIQasXnIcRodopue7mOnHqXTi1YcFSX2IxGgG5S80GBTCxzxDa7llunhXtkTNZPA
         v+sK/EHcsE/Hg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v2 4/8] arch: Remove `__INTERNAL__LIBURING_LIB_H` checks
Date:   Thu, 30 Jun 2022 00:58:26 +0700
Message-Id: <20220629175255.1377052-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629175255.1377052-1-ammar.faizi@intel.com>
References: <20220629175255.1377052-1-ammar.faizi@intel.com>
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
was added by me when adding the x86 syscalls. For aarch64 we will
include this header from lib.h but we are restricted by this check.
Let's just remove it for all archs. User shouldn't touch this code
directly anyway.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/aarch64/syscall.h | 4 ----
 src/arch/generic/lib.h     | 4 ----
 src/arch/generic/syscall.h | 4 ----
 src/arch/x86/lib.h         | 4 ----
 src/arch/x86/syscall.h     | 4 ----
 src/lib.h                  | 2 --
 src/syscall.h              | 2 --
 7 files changed, 24 deletions(-)

diff --git a/src/arch/aarch64/syscall.h b/src/arch/aarch64/syscall.h
index 5e26714..9786c14 100644
--- a/src/arch/aarch64/syscall.h
+++ b/src/arch/aarch64/syscall.h
@@ -1,9 +1,5 @@
 /* SPDX-License-Identifier: MIT */
 
-#ifndef __INTERNAL__LIBURING_SYSCALL_H
-	#error "This file should be included from src/syscall.h (liburing)"
-#endif
-
 #ifndef LIBURING_ARCH_AARCH64_SYSCALL_H
 #define LIBURING_ARCH_AARCH64_SYSCALL_H
 
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
 
diff --git a/src/lib.h b/src/lib.h
index 6672cc5..e5f3680 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -6,7 +6,6 @@
 #include <string.h>
 #include <unistd.h>
 
-#define __INTERNAL__LIBURING_LIB_H
 #if defined(__x86_64__) || defined(__i386__)
 	#include "arch/x86/lib.h"
 #else
@@ -19,7 +18,6 @@
 	/* libc wrappers. */
 	#include "arch/generic/lib.h"
 #endif
-#undef __INTERNAL__LIBURING_LIB_H
 
 
 #ifndef offsetof
diff --git a/src/syscall.h b/src/syscall.h
index 214789d..73b04b4 100644
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

