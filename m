Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1258D56648F
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 10:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiGEHpS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 03:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiGEHpR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 03:45:17 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5C512D06
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 00:45:17 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id EE68A804BA;
        Tue,  5 Jul 2022 07:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1657007116;
        bh=6bBA0RzqNQHU+KNZkMB9Bl8Vzccae/D0VMnWkd8WCaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKrl7SrFuqglteQCI+HLm/U4tSDv8Ht825tVd8fwLLT9u+Z5uYeSeQ8L8GSjTnx0p
         BHhyoxs+y2JtWfkz6P7CrJ1lInCajRapXNgYIhsnUtWaI9FbkU2dFLNcmkiR00PXpS
         JxzNFY8Frrlxt3KsaYj66jaXaNdmw35Pp4kOLSn1RVijx4pEa/2tEUlQ/MLC3kUAdu
         icVaWmj/ubOl8TfCx27MCFgVWOoaRu2buAqF/YL+xCfHuG1FZw/qJyRGQLFiNIfkhU
         MV6nxTLxoB1PKSoXFJFRmR+hKujAr5MOL0UeO7lsk8ic/bHCseUyPsNKYQcMifAeVk
         J30Yh5jsm5Paw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v5 04/10] arch: Remove `__INTERNAL__LIBURING_LIB_H` checks
Date:   Tue,  5 Jul 2022 14:43:54 +0700
Message-Id: <20220705073920.367794-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220705073920.367794-1-ammar.faizi@intel.com>
References: <20220705073920.367794-1-ammar.faizi@intel.com>
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

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
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
index c0ab7e2..b00e90b 100644
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
index 89a40f2..7bbacb9 100644
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

