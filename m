Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3D64B297E
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 16:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244110AbiBKP6f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 10:58:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiBKP6e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 10:58:34 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19A21A8
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 07:58:32 -0800 (PST)
Received: from integral2.. (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 2F3967E29E;
        Fri, 11 Feb 2022 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644595112;
        bh=dXo3RBFkl3Y2bNho36NmMAZCmF4azk36jBgdvonFr1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGHPtzdngNqBYNOf3NE5HV6sst1geqYU7Ujl5lfQ5aMtiGw0hdk1VnUBBcgHweNLG
         +pKdR2XOKKNkFvGPT8i1qqqWLCs0ndNP+pOirMPBahqLdJ8QvfbwIZ28wACNJX2hZV
         4N/zLRGcWjh5VLdiFQ0EDqjv63tKcKebLcLSLKM2R/SFtxR0+JvNeU+uYGhIDubqyL
         5D7azSXcONNzp+RP8zuHZShWnj/9bHNPCR83NFwz1Ve+Swvug+1VUdpvx91jThhkDd
         ZZ/BFnfIJrkgiMMSIc71n5WY9o08bbOvfV2IPdU2WpzSQu1WeLIejKYJrT6l8CpMsF
         eRJiRhfZvKKuw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Nugra <richiisei@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 2/4] arch/x86, syscall: Refactor arch specific and generic syscall wrappers
Date:   Fri, 11 Feb 2022 22:57:51 +0700
Message-Id: <20220211155753.143698-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
References: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

In the previous patch, we create a file src/arch/generic/syscall.h.
Let's use it. There are 3 things in this patch (a, b, c):

a) Remove all ____sys* and uring_* functions from src/syscall.h. We
   will define them in the src/arch/* files, so we can avoid many
   #ifdef/#endif.

b) Rename all __arch_impl_* functions in src/arch/x86/syscall.h with
   ____sys* and uring_* to support point (1).

c) Always use arch specific code for x86-64 syscalls, even with
   CONFIG_NOLIBC disabled. For other archs, currently, will still
   use the libc wrappers (we provided it in src/arch/generic*).

Major changes happen in point (c). We will always use inline assembly
for invoking syscall for x86-64. Reasoning:

1. It reduces function calls.
------------------------------
If we use libc, we need to call syscall(2) function and deal with a
global state via `errno` macro (`errno` macro will expand to a
function call too).

If we use inline Assembly, we eliminate many functions calls, we
don't need to use `errno` or any global state anymore as it will
just directly return error code that we can check with a simple
comparison.

2. Allow the compiler to reuse caller clobbered registers.
-----------------------------------------------------------
By the rule of System V ABI x86-64, a function call clobbers %rax,
%rdi, %rsi, %rdx, %rcx, %r8, %r9, %r10 and %r11. On Linux, syscall
only clobbers %rax, %rcx and %r11. But since libc syscall(2) wrapper
is a function call, the compiler will always miss the opportunity
to reuse those clobbered registers. That means it has to preserve
the life values on the stack if they happen to be in the clobbered
registers (that's also extra memory access).

By inlining the syscall instruction, the compiler has an opportunity
to reuse all registers after invoking syscall, except %rax, %rcx and
%r11.

3. Smaller binary size.
------------------------
Point (1) and (2) will also reduce the data movement, hence smaller
Assembly code, smaller binary size.

4. Reduce %rip round trip to libc.so.
--------------------------------------
Call to a libc function will make the %rip jump to libc.so memory
area. This can have extra overhead and extra icache misses in some
scenario. If we inline the syscall instruction, this overhead can
be removed.

No functional change should be visible to user. At this point, we
may stil use libc for malloc(), free() and memset(), so CONFIG_NOLIBC
is still meaningful after these changes.

Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/generic/syscall.h |   4 +
 src/arch/x86/syscall.h     |  57 ++++++++------
 src/syscall.h              | 155 ++++++-------------------------------
 3 files changed, 63 insertions(+), 153 deletions(-)

diff --git a/src/arch/generic/syscall.h b/src/arch/generic/syscall.h
index 7136290..6b10fe3 100644
--- a/src/arch/generic/syscall.h
+++ b/src/arch/generic/syscall.h
@@ -1,5 +1,9 @@
 /* SPDX-License-Identifier: MIT */
 
+#ifndef __INTERNAL__LIBURING_SYSCALL_H
+	#error "This file should be included from src/syscall.h (liburing)"
+#endif
+
 #ifndef LIBURING_ARCH_GENERIC_SYSCALL_H
 #define LIBURING_ARCH_GENERIC_SYSCALL_H
 
diff --git a/src/arch/x86/syscall.h b/src/arch/x86/syscall.h
index 2fb3552..2d5642c 100644
--- a/src/arch/x86/syscall.h
+++ b/src/arch/x86/syscall.h
@@ -1,12 +1,12 @@
 /* SPDX-License-Identifier: MIT */
 
+#ifndef __INTERNAL__LIBURING_SYSCALL_H
+	#error "This file should be included from src/syscall.h (liburing)"
+#endif
+
 #ifndef LIBURING_ARCH_X86_SYSCALL_H
 #define LIBURING_ARCH_X86_SYSCALL_H
 
-#ifndef LIBURING_SYSCALL_H
-#  error "This file should be included from src/syscall.h (liburing)"
-#endif
-
 #if defined(__x86_64__)
 /**
  * Note for syscall registers usage (x86-64):
@@ -29,8 +29,8 @@
  *   %r11 == %rflags and %rcx == %rip.
  */
 
-static inline void *__arch_impl_mmap(void *addr, size_t length, int prot,
-				     int flags, int fd, off_t offset)
+static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
+			       int fd, off_t offset)
 {
 	void *rax;
 	register int r10 __asm__("r10") = flags;
@@ -52,7 +52,7 @@ static inline void *__arch_impl_mmap(void *addr, size_t length, int prot,
 	return rax;
 }
 
-static inline int __arch_impl_munmap(void *addr, size_t length)
+static inline int uring_munmap(void *addr, size_t length)
 {
 	long rax;
 
@@ -67,7 +67,7 @@ static inline int __arch_impl_munmap(void *addr, size_t length)
 	return (int) rax;
 }
 
-static inline int __arch_impl_madvise(void *addr, size_t length, int advice)
+static inline int uring_madvise(void *addr, size_t length, int advice)
 {
 	long rax;
 
@@ -83,7 +83,7 @@ static inline int __arch_impl_madvise(void *addr, size_t length, int advice)
 	return (int) rax;
 }
 
-static inline int __arch_impl_getrlimit(int resource, struct rlimit *rlim)
+static inline int uring_getrlimit(int resource, struct rlimit *rlim)
 {
 	long rax;
 
@@ -98,7 +98,7 @@ static inline int __arch_impl_getrlimit(int resource, struct rlimit *rlim)
 	return (int) rax;
 }
 
-static inline int __arch_impl_setrlimit(int resource, const struct rlimit *rlim)
+static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
 {
 	long rax;
 
@@ -113,7 +113,7 @@ static inline int __arch_impl_setrlimit(int resource, const struct rlimit *rlim)
 	return (int) rax;
 }
 
-static inline int __arch_impl_close(int fd)
+static inline int uring_close(int fd)
 {
 	long rax;
 
@@ -127,9 +127,9 @@ static inline int __arch_impl_close(int fd)
 	return (int) rax;
 }
 
-static inline int __arch_impl_io_uring_register(int fd, unsigned opcode,
-						const void *arg,
-						unsigned nr_args)
+static inline int ____sys_io_uring_register(int fd, unsigned opcode,
+					    const void *arg,
+					    unsigned nr_args)
 {
 	long rax;
 	register unsigned r10 __asm__("r10") = nr_args;
@@ -147,8 +147,8 @@ static inline int __arch_impl_io_uring_register(int fd, unsigned opcode,
 	return (int) rax;
 }
 
-static inline int __arch_impl_io_uring_setup(unsigned entries,
-					     struct io_uring_params *p)
+static inline int ____sys_io_uring_setup(unsigned entries,
+					 struct io_uring_params *p)
 {
 	long rax;
 
@@ -163,10 +163,9 @@ static inline int __arch_impl_io_uring_setup(unsigned entries,
 	return (int) rax;
 }
 
-static inline int __arch_impl_io_uring_enter(int fd, unsigned to_submit,
-					     unsigned min_complete,
-					     unsigned flags, sigset_t *sig,
-					     int sz)
+static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
+					  unsigned min_complete, unsigned flags,
+					  sigset_t *sig, int sz)
 {
 	long rax;
 	register unsigned r10 __asm__("r10") = flags;
@@ -188,12 +187,26 @@ static inline int __arch_impl_io_uring_enter(int fd, unsigned to_submit,
 	return (int) rax;
 }
 
+static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
+					 unsigned min_complete, unsigned flags,
+					 sigset_t *sig)
+{
+	return ____sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
+				       _NSIG / 8);
+}
+
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
+#include "../generic/syscall.h"
 
 #endif /* #if defined(__x86_64__) */
 
diff --git a/src/syscall.h b/src/syscall.h
index 4b336f1..beb357e 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -55,27 +55,6 @@
  */
 struct io_uring_params;
 
-
-#ifdef CONFIG_NOLIBC
-#  if defined(__x86_64__) || defined(__i386__)
-#    include "arch/x86/syscall.h"
-#  else
-#    error "This arch doesn't support building liburing without libc"
-#  endif
-#endif
-
-
-/*
- * System calls
- */
-int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p);
-int __sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
-			 unsigned flags, sigset_t *sig);
-int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
-			  unsigned flags, sigset_t *sig, int sz);
-int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
-			    unsigned int nr_args);
-
 static inline void *ERR_PTR(intptr_t n)
 {
 	return (void *) n;
@@ -91,118 +70,32 @@ static inline bool IS_ERR(const void *ptr)
 	return uring_unlikely((uintptr_t) ptr >= (uintptr_t) -4095UL);
 }
 
-static inline int ____sys_io_uring_register(int fd, unsigned opcode,
-					    const void *arg, unsigned nr_args)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_io_uring_register(fd, opcode, arg, nr_args);
-#else
-	int ret;
-	ret = syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
-	return (ret < 0) ? -errno : ret;
-#endif
-}
-
-static inline int ____sys_io_uring_setup(unsigned entries,
-					 struct io_uring_params *p)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_io_uring_setup(entries, p);
+#define __INTERNAL__LIBURING_SYSCALL_H
+#if defined(__x86_64__) || defined(__i386__)
+	#include "arch/x86/syscall.h"
 #else
-	int ret;
-	ret = syscall(__NR_io_uring_setup, entries, p);
-	return (ret < 0) ? -errno : ret;
+	/*
+	 * We don't have native syscall wrappers
+	 * for this arch. Must use libc!
+	 */
+	#ifdef CONFIG_NOLIBC
+		#error "This arch doesn't support building liburing without libc"
+	#endif
+	/* libc syscall wrappers. */
+	#include "arch/generic/syscall.h"
 #endif
-}
-
-static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
-					  unsigned min_complete, unsigned flags,
-					  sigset_t *sig, int sz)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_io_uring_enter(fd, to_submit, min_complete, flags,
-					  sig, sz);
-#else
-	int ret;
-	ret = syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags,
-		      sig, sz);
-	return (ret < 0) ? -errno : ret;
-#endif
-}
-
-static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
-					 unsigned min_complete, unsigned flags,
-					 sigset_t *sig)
-{
-	return ____sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
-				       _NSIG / 8);
-}
-
-static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
-			       int fd, off_t offset)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_mmap(addr, length, prot, flags, fd, offset);
-#else
-	void *ret;
-	ret = mmap(addr, length, prot, flags, fd, offset);
-	return (ret == MAP_FAILED) ? ERR_PTR(-errno) : ret;
-#endif
-}
+#undef __INTERNAL__LIBURING_SYSCALL_H
 
-static inline int uring_munmap(void *addr, size_t length)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_munmap(addr, length);
-#else
-	int ret;
-	ret = munmap(addr, length);
-	return (ret < 0) ? -errno : ret;
-#endif
-}
-
-static inline int uring_madvise(void *addr, size_t length, int advice)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_madvise(addr, length, advice);
-#else
-	int ret;
-	ret = madvise(addr, length, advice);
-	return (ret < 0) ? -errno : ret;
-#endif
-}
-
-static inline int uring_getrlimit(int resource, struct rlimit *rlim)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_getrlimit(resource, rlim);
-#else
-	int ret;
-	ret = getrlimit(resource, rlim);
-	return (ret < 0) ? -errno : ret;
-#endif
-}
-
-static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_setrlimit(resource, rlim);
-#else
-	int ret;
-	ret = setrlimit(resource, rlim);
-	return (ret < 0) ? -errno : ret;
-#endif
-}
-
-static inline int uring_close(int fd)
-{
-#ifdef CONFIG_NOLIBC
-	return __arch_impl_close(fd);
-#else
-	int ret;
-	ret = close(fd);
-	return (ret < 0) ? -errno : ret;
-#endif
-}
+/*
+ * For backward compatibility.
+ * (these __sys* functions always use libc, see syscall.c)
+ */
+int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p);
+int __sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
+			 unsigned flags, sigset_t *sig);
+int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
+			  unsigned flags, sigset_t *sig, int sz);
+int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
+			    unsigned int nr_args);
 
 #endif
-- 
2.32.0

