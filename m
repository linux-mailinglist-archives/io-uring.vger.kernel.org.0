Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262744B7285
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 17:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240786AbiBOPmn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 10:42:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242452AbiBOPm3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 10:42:29 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9759FD10B8
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 07:37:32 -0800 (PST)
Received: from integral2.. (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 2A3BC7E2A6;
        Tue, 15 Feb 2022 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644939438;
        bh=GkQxFr5EzK9Er/3ctU653qxp0LGT7nuAJlb4p77FuBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYKyL4Hpk89y70b2YlsE4KMNjQAuUFba3NtscSPVhbWhDsAT6KakDQbPWF2Z1722a
         JktJfqrXmd057ranxvri1r+dtADJRsSTyI0xmjE3TybVVWuf6mNkp1zmZnA7VORKUX
         tr3j4hLr5Nc6jRNaYYNJcTOe/rvoASwNWwS6duN9k9sAdaHT95a8OAdCTXcoibT3Y+
         d/leL6DZ/nIHY2BU3zf+VcIn3COUseT6aDyB9CgF2y9UoNLEOFga4R22HrVgF5G9GG
         qn6nDQisMyi714e4Av1P8z71sZS1qLjBNqFcwiftnPmAKA6A5W/S47YQCEz9yzF99l
         5ZQhyVaRhlMJg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Arthur Lapz <rlapz@gnuweeb.org>, Nugra <nnn@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 2/2] arch/x86: Create syscall __do_syscall{0..6} macros
Date:   Tue, 15 Feb 2022 22:36:51 +0700
Message-Id: <20220215153651.181319-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220215153651.181319-1-ammarfaizi2@gnuweeb.org>
References: <20220215153651.181319-1-ammarfaizi2@gnuweeb.org>
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

From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

Reduce arch dependent code by creating __do_syscall{0..6} macros.
These macros are made of inline Assembly x86-64. Use them to invoke
syscall via __sys* functions. By using this design, we don't have to
code in inline Assembly again when adding a new syscall.

Tested on Linux x86-64, all test passed, but rsrc_tags timedout.

Tested-by: Arthur Lapz <rlapz@gnuweeb.org>
Tested-by: Nugra <nnn@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/x86/syscall.h | 242 +++++++++++++++++++++--------------------
 1 file changed, 124 insertions(+), 118 deletions(-)

diff --git a/src/arch/x86/syscall.h b/src/arch/x86/syscall.h
index 02677f2..c4ae24e 100644
--- a/src/arch/x86/syscall.h
+++ b/src/arch/x86/syscall.h
@@ -29,162 +29,168 @@
  *   %r11 == %rflags and %rcx == %rip.
  */
 
+#define __do_syscall0(NUM) ({			\
+	intptr_t rax;				\
+						\
+	__asm__ volatile(			\
+		"syscall"			\
+		: "=a"(rax)	/* %rax */	\
+		: "a"(NUM)	/* %rax */	\
+		: "rcx", "r11", "memory"	\
+	);					\
+	rax;					\
+})
+
+#define __do_syscall1(NUM, ARG1) ({		\
+	intptr_t rax;				\
+						\
+	__asm__ volatile(			\
+		"syscall"			\
+		: "=a"(rax)	/* %rax */	\
+		: "a"((NUM)),	/* %rax */	\
+		  "D"((ARG1))	/* %rdi */	\
+		: "rcx", "r11", "memory"	\
+	);					\
+	rax;					\
+})
+
+#define __do_syscall2(NUM, ARG1, ARG2) ({	\
+	intptr_t rax;				\
+						\
+	__asm__ volatile(			\
+		"syscall"			\
+		: "=a"(rax)	/* %rax */	\
+		: "a"((NUM)),	/* %rax */	\
+		  "D"((ARG1)),	/* %rdi */	\
+		  "S"((ARG2))	/* %rsi */	\
+		: "rcx", "r11", "memory"	\
+	);					\
+	rax;					\
+})
+
+#define __do_syscall3(NUM, ARG1, ARG2, ARG3) ({	\
+	intptr_t rax;				\
+						\
+	__asm__ volatile(			\
+		"syscall"			\
+		: "=a"(rax)	/* %rax */	\
+		: "a"((NUM)),	/* %rax */	\
+		  "D"((ARG1)),	/* %rdi */	\
+		  "S"((ARG2)),	/* %rsi */	\
+		  "d"((ARG3))	/* %rdx */	\
+		: "rcx", "r11", "memory"	\
+	);					\
+	rax;					\
+})
+
+#define __do_syscall4(NUM, ARG1, ARG2, ARG3, ARG4) ({			\
+	intptr_t rax;							\
+	register __typeof__(ARG4) __r10 __asm__("r10") = (ARG4);	\
+									\
+	__asm__ volatile(						\
+		"syscall"						\
+		: "=a"(rax)	/* %rax */				\
+		: "a"((NUM)),	/* %rax */				\
+		  "D"((ARG1)),	/* %rdi */				\
+		  "S"((ARG2)),	/* %rsi */				\
+		  "d"((ARG3)),	/* %rdx */				\
+		  "r"(__r10)	/* %r10 */				\
+		: "rcx", "r11", "memory"				\
+	);								\
+	rax;								\
+})
+
+#define __do_syscall5(NUM, ARG1, ARG2, ARG3, ARG4, ARG5) ({		\
+	intptr_t rax;							\
+	register __typeof__(ARG4) __r10 __asm__("r10") = (ARG4);	\
+	register __typeof__(ARG5) __r8 __asm__("r8") = (ARG5);		\
+									\
+	__asm__ volatile(						\
+		"syscall"						\
+		: "=a"(rax)	/* %rax */				\
+		: "a"((NUM)),	/* %rax */				\
+		  "D"((ARG1)),	/* %rdi */				\
+		  "S"((ARG2)),	/* %rsi */				\
+		  "d"((ARG3)),	/* %rdx */				\
+		  "r"(__r10),	/* %r10 */				\
+		  "r"(__r8)	/* %r8 */				\
+		: "rcx", "r11", "memory"				\
+	);								\
+	rax;								\
+})
+
+#define __do_syscall6(NUM, ARG1, ARG2, ARG3, ARG4, ARG5, ARG6) ({	\
+	intptr_t rax;							\
+	register __typeof__(ARG4) __r10 __asm__("r10") = (ARG4);	\
+	register __typeof__(ARG5) __r8 __asm__("r8") = (ARG5);		\
+	register __typeof__(ARG6) __r9 __asm__("r9") = (ARG6);		\
+									\
+	__asm__ volatile(						\
+		"syscall"						\
+		: "=a"(rax)	/* %rax */				\
+		: "a"((NUM)),	/* %rax */				\
+		  "D"((ARG1)),	/* %rdi */				\
+		  "S"((ARG2)),	/* %rsi */				\
+		  "d"((ARG3)),	/* %rdx */				\
+		  "r"(__r10),	/* %r10 */				\
+		  "r"(__r8),	/* %r8 */				\
+		  "r"(__r9)	/* %r9 */				\
+		: "rcx", "r11", "memory"				\
+	);								\
+	rax;								\
+})
+
 static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
-	void *rax;
-	register int r10 __asm__("r10") = flags;
-	register int r8 __asm__("r8") = fd;
-	register off_t r9 __asm__("r9") = offset;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)		/* %rax */
-		: "a"(__NR_mmap),	/* %rax */
-		  "D"(addr),		/* %rdi */
-		  "S"(length),		/* %rsi */
-		  "d"(prot),		/* %rdx */
-		  "r"(r10),		/* %r10 */
-		  "r"(r8),		/* %r8  */
-		  "r"(r9)		/* %r9  */
-		: "memory", "rcx", "r11"
-	);
-	return rax;
+	return (void *) __do_syscall6(__NR_mmap, addr, length, prot, flags, fd,
+				      offset);
 }
 
 static inline int __sys_munmap(void *addr, size_t length)
 {
-	long rax;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)		/* %rax */
-		: "a"(__NR_munmap),	/* %rax */
-		  "D"(addr),		/* %rdi */
-		  "S"(length)		/* %rsi */
-		: "memory", "rcx", "r11"
-	);
-	return (int) rax;
+	return (int) __do_syscall2(__NR_munmap, addr, length);
 }
 
 static inline int __sys_madvise(void *addr, size_t length, int advice)
 {
-	long rax;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)		/* %rax */
-		: "a"(__NR_madvise),	/* %rax */
-		  "D"(addr),		/* %rdi */
-		  "S"(length),		/* %rsi */
-		  "d"(advice)		/* %rdx */
-		: "memory", "rcx", "r11"
-	);
-	return (int) rax;
+	return (int) __do_syscall2(__NR_madvise, addr, length);
 }
 
 static inline int __sys_getrlimit(int resource, struct rlimit *rlim)
 {
-	long rax;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)		/* %rax */
-		: "a"(__NR_getrlimit),	/* %rax */
-		  "D"(resource),	/* %rdi */
-		  "S"(rlim)		/* %rsi */
-		: "memory", "rcx", "r11"
-	);
-	return (int) rax;
+	return (int) __do_syscall2(__NR_getrlimit, resource, rlim);
 }
 
 static inline int __sys_setrlimit(int resource, const struct rlimit *rlim)
 {
-	long rax;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)		/* %rax */
-		: "a"(__NR_setrlimit),	/* %rax */
-		  "D"(resource),	/* %rdi */
-		  "S"(rlim)		/* %rsi */
-		: "memory", "rcx", "r11"
-	);
-	return (int) rax;
+	return (int) __do_syscall2(__NR_setrlimit, resource, rlim);
 }
 
 static inline int __sys_close(int fd)
 {
-	long rax;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)		/* %rax */
-		: "a"(__NR_close),	/* %rax */
-		  "D"(fd)		/* %rdi */
-		: "memory", "rcx", "r11"
-	);
-	return (int) rax;
+	return (int) __do_syscall1(__NR_close, fd);
 }
 
 static inline int ____sys_io_uring_register(int fd, unsigned opcode,
-					    const void *arg,
-					    unsigned nr_args)
+					    const void *arg, unsigned nr_args)
 {
-	long rax;
-	register unsigned r10 __asm__("r10") = nr_args;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)			/* %rax */
-		: "a"(__NR_io_uring_register),	/* %rax */
-		  "D"(fd),			/* %rdi */
-		  "S"(opcode),			/* %rsi */
-		  "d"(arg),			/* %rdx */
-		  "r"(r10)			/* %r10 */
-		: "memory", "rcx", "r11"
-	);
-	return (int) rax;
+	return (int) __do_syscall4(__NR_io_uring_register, fd, opcode, arg,
+				   nr_args);
 }
 
 static inline int ____sys_io_uring_setup(unsigned entries,
 					 struct io_uring_params *p)
 {
-	long rax;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)			/* %rax */
-		: "a"(__NR_io_uring_setup),	/* %rax */
-		  "D"(entries),			/* %rdi */
-		  "S"(p)			/* %rsi */
-		: "memory", "rcx", "r11"
-	);
-	return (int) rax;
+	return (int) __do_syscall2(__NR_io_uring_setup, entries, p);
 }
 
 static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
 					  unsigned min_complete, unsigned flags,
 					  sigset_t *sig, int sz)
 {
-	long rax;
-	register unsigned r10 __asm__("r10") = flags;
-	register sigset_t *r8 __asm__("r8") = sig;
-	register int r9 __asm__("r9") = sz;
-
-	__asm__ volatile(
-		"syscall"
-		: "=a"(rax)			/* %rax */
-		: "a"(__NR_io_uring_enter),	/* %rax */
-		  "D"(fd),			/* %rdi */
-		  "S"(to_submit),		/* %rsi */
-		  "d"(min_complete),		/* %rdx */
-		  "r"(r10),			/* %r10 */
-		  "r"(r8),			/* %r8  */
-		  "r"(r9)			/* %r9  */
-		: "memory", "rcx", "r11"
-	);
-	return (int) rax;
+	return (int) __do_syscall6(__NR_io_uring_enter, fd, to_submit,
+				   min_complete, flags, sig, sz);
 }
 
 static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
-- 
2.32.0

