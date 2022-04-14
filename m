Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00081501E86
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 00:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347128AbiDNWom (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 18:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347120AbiDNWok (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 18:44:40 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CC6C6B77
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 15:42:14 -0700 (PDT)
Received: from integral2.. (unknown [36.80.217.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 8003F7E3A1;
        Thu, 14 Apr 2022 22:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649976134;
        bh=YALudYFMOzxJmec0xxldwQA2/SlxyLcwbBz0rPmnAiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9CiK/N+jaNCJNvpXA5CHnnmETEAZb/oxwZlymLtBSADA8syZKK+yJ5euircgjGcC
         p13Fdm2Fa96VpzC2ck/YQkIUCbsD4rV9bHEvlPP5oC4lqnAiJncBuvwokl2INqPqfh
         jGoVCTI6x9TklvPCSyW83jXSzdoBEUEfz+cLM3fyJZFnmKRq94eQBo0lFPOKtmYKk9
         xbUv0rV92xXQj3YGDHKRa6Ju+71pgG+1adFqafKDYFMzglhcqIMHjz5Wk5rhCnNj54
         /8rqZrTVQIFAofVp5L9103H0i80AClJxvy2PR+VT0ggIErcuNXOb8lRH2VT3h+3+oC
         kWPR2/xRH8+9A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing 3/3] arch/x86/syscall: Add x86 32-bit native syscall support
Date:   Fri, 15 Apr 2022 05:41:40 +0700
Message-Id: <20220414224001.187778-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220414224001.187778-1-ammar.faizi@intel.com>
References: <20220414224001.187778-1-ammar.faizi@intel.com>
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

Create __do_syscall{0..6} macros for x86 32-bit. Unlike x86-64, only
use these macros when CONFIG_NOLIBC is enabled for a 32-bit build. The
reason is that the libc syscall wrapper can do better in 32-bit.

libc syscall wrapper can dispatch the best syscall instruction that the
environment is supported, there are at least two variants of syscall
instruction for x86 32-bit, they are: `int $0x80` and `sysenter`. The
`int $0x80` instruction is always available, but `sysenter` is not, it
relies on VDSO. liburing always uses `int $0x80` for syscall if it's
compiled with CONFIG_NOLIBC, otherwise, it uses whatever the libc
provides.

Extra notes for __do_syscall6() macro:
On i386, the 6th argument of syscall goes in %ebp. However, both Clang
and GCC cannot use %ebp in the clobber list and the "r" constraint
without using -fomit-frame-pointer. To make it always available for any
kind of compilation, the below workaround is implemented:

  1) Push the 6-th argument.
  2) Push %ebp.
  3) Load the 6-th argument from 4(%esp) to %ebp.
  4) Do the syscall (int $0x80).
  5) Pop %ebp (restore the old value of %ebp).
  6) Add %esp by 4 (undo the stack pointer).

WARNING:
  Don't use register variables for __do_syscall6(), there is a known
  GCC bug that results in an endless loop.

BugLink: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105032

Link: https://lore.kernel.org/lkml/2e335ac54db44f1d8496583d97f9dab0@AcuMS.aculab.com
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/x86/syscall.h | 150 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 148 insertions(+), 2 deletions(-)

diff --git a/src/arch/x86/syscall.h b/src/arch/x86/syscall.h
index 89a68f6..8cd24dd 100644
--- a/src/arch/x86/syscall.h
+++ b/src/arch/x86/syscall.h
@@ -151,10 +151,156 @@
  * TODO: Add x86 (32-bit) nolibc support.
  */
 #ifdef CONFIG_NOLIBC
-	#error "x86 (32-bit) is currently not supported for nolibc builds"
-#endif
+/**
+ * Note for syscall registers usage (x86, 32-bit):
+ *   - %eax is the syscall number.
+ *   - %eax is also the return value.
+ *   - %ebx is the 1st argument.
+ *   - %ecx is the 2nd argument.
+ *   - %edx is the 3rd argument.
+ *   - %esi is the 4th argument.
+ *   - %edi is the 5th argument.
+ *   - %ebp is the 6th argument.
+ */
+
+#define __do_syscall0(NUM) ({			\
+	intptr_t eax;				\
+						\
+	__asm__ volatile(			\
+		"int	$0x80"			\
+		: "=a"(eax)	/* %eax */	\
+		: "a"(NUM)	/* %eax */	\
+		: "memory"			\
+	);					\
+	eax;					\
+})
+
+#define __do_syscall1(NUM, ARG1) ({		\
+	intptr_t eax;				\
+						\
+	__asm__ volatile(			\
+		"int	$0x80"			\
+		: "=a"(eax)	/* %eax */	\
+		: "a"(NUM),	/* %eax */	\
+		  "b"((ARG1))	/* %ebx */	\
+		: "memory"			\
+	);					\
+	eax;					\
+})
+
+#define __do_syscall2(NUM, ARG1, ARG2) ({	\
+	intptr_t eax;				\
+						\
+	__asm__ volatile(			\
+		"int	$0x80"			\
+		: "=a" (eax)	/* %eax */	\
+		: "a"(NUM),	/* %eax */	\
+		  "b"((ARG1)),	/* %ebx */	\
+		  "c"((ARG2))	/* %ecx */	\
+		: "memory"			\
+	);					\
+	eax;					\
+})
+
+#define __do_syscall3(NUM, ARG1, ARG2, ARG3) ({	\
+	intptr_t eax;				\
+						\
+	__asm__ volatile(			\
+		"int	$0x80"			\
+		: "=a" (eax)	/* %eax */	\
+		: "a"(NUM),	/* %eax */	\
+		  "b"((ARG1)),	/* %ebx */	\
+		  "c"((ARG2)),	/* %ecx */	\
+		  "d"((ARG3))	/* %edx */	\
+		: "memory"			\
+	);					\
+	eax;					\
+})
+
+#define __do_syscall4(NUM, ARG1, ARG2, ARG3, ARG4) ({	\
+	intptr_t eax;					\
+							\
+	__asm__ volatile(				\
+		"int	$0x80"				\
+		: "=a" (eax)	/* %eax */		\
+		: "a"(NUM),	/* %eax */		\
+		  "b"((ARG1)),	/* %ebx */		\
+		  "c"((ARG2)),	/* %ecx */		\
+		  "d"((ARG3)),	/* %edx */		\
+		  "S"((ARG4))	/* %esi */		\
+		: "memory"				\
+	);						\
+	eax;						\
+})
+
+#define __do_syscall5(NUM, ARG1, ARG2, ARG3, ARG4, ARG5) ({	\
+	intptr_t eax;						\
+								\
+	__asm__ volatile(					\
+		"int	$0x80"					\
+		: "=a" (eax)	/* %eax */			\
+		: "a"(NUM),	/* %eax */			\
+		  "b"((ARG1)),	/* %ebx */			\
+		  "c"((ARG2)),	/* %ecx */			\
+		  "d"((ARG3)),	/* %edx */			\
+		  "S"((ARG4)),	/* %esi */			\
+		  "D"((ARG5))	/* %edi */			\
+		: "memory"					\
+	);							\
+	eax;							\
+})
+
+
+/*
+ * On i386, the 6th argument of syscall goes in %ebp. However, both Clang
+ * and GCC cannot use %ebp in the clobber list and in the "r" constraint
+ * without using -fomit-frame-pointer. To make it always available for
+ * any kind of compilation, the below workaround is implemented:
+ *
+ *  1) Push the 6-th argument.
+ *  2) Push %ebp.
+ *  3) Load the 6-th argument from 4(%esp) to %ebp.
+ *  4) Do the syscall (int $0x80).
+ *  5) Pop %ebp (restore the old value of %ebp).
+ *  6) Add %esp by 4 (undo the stack pointer).
+ *
+ * WARNING:
+ *   Don't use register variables for __do_syscall6(), there is a known
+ *   GCC bug that results in an endless loop.
+ *
+ * BugLink: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105032
+ *
+ */
+#define __do_syscall6(NUM, ARG1, ARG2, ARG3, ARG4, ARG5, ARG6) ({	\
+	intptr_t eax  = (intptr_t)(NUM);				\
+	intptr_t arg6 = (intptr_t)(ARG6); /* Always in memory */	\
+	__asm__ volatile (						\
+		"pushl	%[_arg6]\n\t"					\
+		"pushl	%%ebp\n\t"					\
+		"movl	4(%%esp),%%ebp\n\t"				\
+		"int	$0x80\n\t"					\
+		"popl	%%ebp\n\t"					\
+		"addl	$4,%%esp"					\
+		: "+a"(eax)		/* %eax */			\
+		: "b"(ARG1),		/* %ebx */			\
+		  "c"(ARG2),		/* %ecx */			\
+		  "d"(ARG3),		/* %edx */			\
+		  "S"(ARG4),		/* %esi */			\
+		  "D"(ARG5),		/* %edi */			\
+		  [_arg6]"m"(arg6)	/* memory */			\
+		: "memory", "cc"					\
+	);								\
+	eax;								\
+})
+
+#include "../syscall-defs.h"
+
+#else /* #ifdef CONFIG_NOLIBC */
+
 #include "../generic/syscall.h"
 
+#endif /* #ifdef CONFIG_NOLIBC */
+
 #endif /* #if defined(__x86_64__) */
 
 #endif /* #ifndef LIBURING_ARCH_X86_SYSCALL_H */
-- 
Ammar Faizi

