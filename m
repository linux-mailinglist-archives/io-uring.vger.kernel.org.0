Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17CC424076
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 16:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhJFOxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 10:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238436AbhJFOxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 10:53:07 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBA1C061753
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 07:51:15 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m21so2647299pgu.13
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 07:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WdoEgiYBOJ3ojClwtg9w0I9QjiLbSz8QPThVGHF2cDk=;
        b=XRC5SHAGRyyO5p+GrjWTClNvUw3I1hKBs2sM8o9xcKGxQGK2QUWMn92gKXSUsTMvge
         /87tU4BhuQ6qPMtkjC71HgI3dz1NlX8s0Lab85hX6b0xVQT8JI6b4WgWkIIDnGp6bBhl
         EOS8jjQuXwIB17oMP7UdPx6GhiwT6LWS7Oq9J1XPXzRI+pSP9M/7R3iyf65oenDMgVm8
         k6TA+cdfOG+MwN/sFHEjTDUH/9WZGb/mWIrsdkjSzJC9xO/bd5uoj9b5XVqJRtQA33iS
         SUVW8fBDP5FbbzZJO+QheMy2fYpaKT1od1TYOM7Df7vdoTLNdJx9fFwL8pZ+rXymF2hE
         asjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WdoEgiYBOJ3ojClwtg9w0I9QjiLbSz8QPThVGHF2cDk=;
        b=1O7Hune10VukirWX53Y6GCZpGN72CA3Z7JtTqOkuMZ5FTJF8pR0AJsoUvInE6skPyP
         CzgpNuu00vuESzGLq/9hBTe1QooCOcRKs7ga8GoRPqrX8MhOmrP9SvIIcZA6KWLhxkCi
         ZccuyJWu4LlrClWAbAsZagAQAavp/eW4yFpGSSZHMxIXUyl1Jooms1+NFTiwPt1RyWRE
         Is4G3NhH4+sZpm8hFsjz/HvqqdCMvFIH90hYNfBwgZtYmpinIZN/3uzPD+ayyDk22qjr
         eNljIb/hPN+zVMX5js3QMv16A5NxONKEhHUlfn3mOUyGegw8rDVDw38cPKBHV3cjRWHI
         abow==
X-Gm-Message-State: AOAM533hP8kt4qKSe9RxuGoRVGs6osNZqWefaCTmKZL6wzSUwQFk4cng
        9oshe8lC256s8X3Eh4/yc2bP6g==
X-Google-Smtp-Source: ABdhPJzYgqptnSgPXL2C66vQJf9KDv8U5FoVn10rTa1o5zPaNZ8qWiYQgckjxrv4PcD0YrRe0ns4Tw==
X-Received: by 2002:a63:374b:: with SMTP id g11mr20440521pgn.459.1633531874854;
        Wed, 06 Oct 2021 07:51:14 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id y197sm19155429pfc.56.2021.10.06.07.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 07:51:14 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v1 RFC liburing 3/6] Add x86-64 no libc build support
Date:   Wed,  6 Oct 2021 21:49:09 +0700
Message-Id: <20211006144911.1181674-4-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
References: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1) Initiate no libc support from x86-64 arch.
2) Create `src/arch` directory. This directory is used to save arch
   dependent files.
3) Add x86-64 syscalls and lib support.

All of these are supposed to support build liburing without libc.

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Link: https://github.com/axboe/liburing/issues/443
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/arch/x86/lib.h     |  26 ++++++
 src/arch/x86/syscall.h | 200 +++++++++++++++++++++++++++++++++++++++++
 src/lib.h              |   8 ++
 src/syscall.h          |  71 +++++++++++----
 4 files changed, 290 insertions(+), 15 deletions(-)
 create mode 100644 src/arch/x86/lib.h
 create mode 100644 src/arch/x86/syscall.h

diff --git a/src/arch/x86/lib.h b/src/arch/x86/lib.h
new file mode 100644
index 0000000..0d4b321
--- /dev/null
+++ b/src/arch/x86/lib.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef LIBURING_ARCH_X86_LIB_H
+#define LIBURING_ARCH_X86_LIB_H
+
+#ifndef LIBURING_LIB_H
+#  error "This file should be included from src/lib.h (liburing)"
+#endif
+
+#if defined(__x86_64__)
+
+static inline long __arch_impl_get_page_size(void)
+{
+	return 4096;
+}
+
+#else /* #if defined(__x86_64__) */
+
+/*
+ * TODO: Add x86 (32-bit) support here.
+ */
+#error "x86 (32-bit) is currently not supported"
+
+#endif /* #if defined(__x86_64__) */
+
+#endif /* #ifndef LIBURING_ARCH_X86_LIB_H */
diff --git a/src/arch/x86/syscall.h b/src/arch/x86/syscall.h
new file mode 100644
index 0000000..1f36310
--- /dev/null
+++ b/src/arch/x86/syscall.h
@@ -0,0 +1,200 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef LIBURING_ARCH_X86_SYSCALL_H
+#define LIBURING_ARCH_X86_SYSCALL_H
+
+#ifndef LIBURING_SYSCALL_H
+#  error "This file should be included from src/syscall.h (liburing)"
+#endif
+
+#if defined(__x86_64__)
+/**
+ * Note for syscall registers usage (x86-64):
+ *   - %rax is the syscall number.
+ *   - %rax is also the return value.
+ *   - %rdi is the 1st argument.
+ *   - %rsi is the 2nd argument.
+ *   - %rdx is the 3rd argument.
+ *   - %r10 is the 4th argument (**yes it's %r10, not %rcx!**).
+ *   - %r8  is the 5th argument.
+ *   - %r9  is the 6th argument.
+ *
+ * `syscall` instruction will clobber %r11 and %rcx.
+ *
+ * After the syscall returns to userspace:
+ *   - %r11 will contain %rflags.
+ *   - %rcx will contain the return address.
+ *
+ * IOW, after the syscall returns to userspace:
+ *   %r11 == %rflags and %rcx == %rip.
+ */
+
+static inline void *__arch_impl_mmap(void *addr, size_t length, int prot,
+				     int flags, int fd, off_t offset)
+{
+	void *rax;
+	register int r10 __asm__("r10") = flags;
+	register int r8 __asm__("r8") = fd;
+	register int r9 __asm__("r9") = offset;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)
+		: "a"(__NR_mmap),	/* %rax */
+		  "D"(addr),		/* %rdi */
+		  "S"(length),		/* %rsi */
+		  "d"(prot),		/* %rdx */
+		  "r"(r10),		/* %r10 */
+		  "r"(r8),		/* %r8  */
+		  "r"(r9)		/* %r9  */
+		: "memory", "rcx", "r11"
+	);
+	return rax;
+}
+
+static inline int __arch_impl_munmap(void *addr, size_t length)
+{
+	int eax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(eax)		/* %rax */
+		: "a"(__NR_munmap),	/* %rax */
+		  "D"(addr),		/* %rdi */
+		  "S"(length)		/* %rsi */
+		: "memory", "rcx", "r11"
+	);
+	return eax;
+}
+
+static inline int __arch_impl_madvise(void *addr, size_t length, int advice)
+{
+	int eax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(eax)		/* %rax */
+		: "a"(__NR_madvise),	/* %rax */
+		  "D"(addr),		/* %rdi */
+		  "S"(length),		/* %rsi */
+		  "d"(advice)		/* %rdx */
+		: "memory", "rcx", "r11"
+	);
+	return eax;
+}
+
+static inline int __arch_impl_getrlimit(int resource, struct rlimit *rlim)
+{
+	int eax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(eax)		/* %rax */
+		: "a"(__NR_getrlimit),	/* %rax */
+		  "D"(resource),	/* %rdi */
+		  "S"(rlim)		/* %rsi */
+		: "memory", "rcx", "r11"
+	);
+	return eax;
+}
+
+static inline int __arch_impl_setrlimit(int resource, const struct rlimit *rlim)
+{
+	int eax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(eax)		/* %rax */
+		: "a"(__NR_setrlimit),	/* %rax */
+		  "D"(resource),	/* %rdi */
+		  "S"(rlim)		/* %rsi */
+		: "memory", "rcx", "r11"
+	);
+	return eax;
+}
+
+static inline int __arch_impl_close(int fd)
+{
+	int eax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(eax)		/* %rax */
+		: "a"(__NR_close),	/* %rax */
+		  "D"(fd)		/* %rdi */
+		: "memory", "rcx", "r11"
+	);
+	return eax;
+}
+
+static inline int __arch_impl_io_uring_register(int fd, unsigned opcode,
+						const void *arg,
+						unsigned nr_args)
+{
+	int eax;
+	register unsigned r10 __asm__("r10") = nr_args;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(eax)			/* %rax */
+		: "a"(__NR_io_uring_register),	/* %rax */
+		  "D"(fd),			/* %rdi */
+		  "S"(opcode),			/* %rsi */
+		  "d"(arg),			/* %rdx */
+		  "r"(r10)			/* %r10 */
+		: "memory", "rcx", "r11"
+	);
+	return eax;
+}
+
+static inline int __arch_impl_io_uring_setup(unsigned entries,
+					     struct io_uring_params *p)
+{
+	int eax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(eax)			/* %rax */
+		: "a"(__NR_io_uring_setup),	/* %rax */
+		  "D"(entries),			/* %rdi */
+		  "S"(p)			/* %rsi */
+		: "memory", "rcx", "r11"
+	);
+	return eax;
+}
+
+static inline int __arch_impl_io_uring_enter(int fd, unsigned to_submit,
+					     unsigned min_complete,
+					     unsigned flags, sigset_t *sig,
+					     int sz)
+{
+	int eax;
+	register unsigned r10 __asm__("r10") = flags;
+	register sigset_t *r8 __asm__("r8") = sig;
+	register int r9 __asm__("r9") = sz;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(eax)
+		: "a"(__NR_io_uring_enter),	/* %rax */
+		  "D"(fd),			/* %rdi */
+		  "S"(to_submit),		/* %rsi */
+		  "d"(min_complete),		/* %rdx */
+		  "r"(r10),			/* %r10 */
+		  "r"(r8),			/* %r8  */
+		  "r"(r9)			/* %r9  */
+		: "memory", "rcx", "r11"
+	);
+	return eax;
+}
+
+#else /* #if defined(__x86_64__) */
+
+/*
+ * TODO: Add x86 (32-bit) support here.
+ */
+#error "x86 (32-bit) is currently not supported"
+
+#endif /* #if defined(__x86_64__) */
+
+#endif /* #ifndef LIBURING_ARCH_X86_SYSCALL_H */
diff --git a/src/lib.h b/src/lib.h
index 171eee7..baacabe 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -6,6 +6,14 @@
 #include <string.h>
 #include <unistd.h>
 
+#ifdef LIBURING_NOLIBC
+#  if defined(__x86_64__) || defined(__i386__)
+#    include "arch/x86/lib.h"
+#  else
+#    error "The arch is currently not supported to build liburing without libc"
+#  endif
+#endif
+
 #ifndef offsetof
 # define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
 #endif
diff --git a/src/syscall.h b/src/syscall.h
index 9eff968..82f5db0 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -29,13 +29,13 @@
 # endif
 #elif defined __mips__
 # ifndef __NR_io_uring_setup
-#  define __NR_io_uring_setup           (__NR_Linux + 425)
+#  define __NR_io_uring_setup		(__NR_Linux + 425)
 # endif
 # ifndef __NR_io_uring_enter
-#  define __NR_io_uring_enter           (__NR_Linux + 426)
+#  define __NR_io_uring_enter		(__NR_Linux + 426)
 # endif
 # ifndef __NR_io_uring_register
-#  define __NR_io_uring_register        (__NR_Linux + 427)
+#  define __NR_io_uring_register	(__NR_Linux + 427)
 # endif
 #else /* !__alpha__ and !__mips__ */
 # ifndef __NR_io_uring_setup
@@ -49,9 +49,22 @@
 # endif
 #endif
 
-
+/*
+ * Don't put this below the #include "arch/$arch/syscall.h", that
+ * file may need it.
+ */
 struct io_uring_params;
 
+
+#ifdef LIBURING_NOLIBC
+#  if defined(__x86_64__) || defined(__i386__)
+#    include "arch/x86/syscall.h"
+#  else
+#    error "The arch is currently not supported to build liburing without libc"
+#  endif
+#endif
+
+
 /*
  * System calls
  */
@@ -68,12 +81,12 @@ static inline void *ERR_PTR(intptr_t n)
 	return (void *) n;
 }
 
-static inline intptr_t PTR_ERR(void *ptr)
+static inline intptr_t PTR_ERR(const void *ptr)
 {
 	return (intptr_t) ptr;
 }
 
-static inline bool IS_ERR(void *ptr)
+static inline bool IS_ERR(const void *ptr)
 {
 	return uring_unlikely((uintptr_t) ptr >= (uintptr_t) -4095UL);
 }
@@ -81,30 +94,40 @@ static inline bool IS_ERR(void *ptr)
 static inline int ____sys_io_uring_register(int fd, unsigned opcode,
 					    const void *arg, unsigned nr_args)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_io_uring_register(fd, opcode, arg, nr_args);
+#else
 	int ret;
-
 	ret = syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
 	return (ret < 0) ? -errno : ret;
+#endif
 }
 
 static inline int ____sys_io_uring_setup(unsigned entries,
 					 struct io_uring_params *p)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_io_uring_setup(entries, p);
+#else
 	int ret;
-
 	ret = syscall(__NR_io_uring_setup, entries, p);
 	return (ret < 0) ? -errno : ret;
+#endif
 }
 
 static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
 					  unsigned min_complete, unsigned flags,
 					  sigset_t *sig, int sz)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_io_uring_enter(fd, to_submit, min_complete, flags,
+					  sig, sz);
+#else
 	int ret;
-
 	ret = syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags,
 		      sig, sz);
 	return (ret < 0) ? -errno : ret;
+#endif
 }
 
 static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
@@ -118,50 +141,68 @@ static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
 static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_mmap(addr, length, prot, flags, fd, offset);
+#else
 	void *ret;
-
 	ret = mmap(addr, length, prot, flags, fd, offset);
 	return (ret == MAP_FAILED) ? ERR_PTR(-errno) : ret;
+#endif
 }
 
 static inline int uring_munmap(void *addr, size_t length)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_munmap(addr, length);
+#else
 	int ret;
-
 	ret = munmap(addr, length);
 	return (ret < 0) ? -errno : ret;
+#endif
 }
 
 static inline int uring_madvise(void *addr, size_t length, int advice)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_madvise(addr, length, advice);
+#else
 	int ret;
-
 	ret = madvise(addr, length, advice);
 	return (ret < 0) ? -errno : ret;
+#endif
 }
 
 static inline int uring_getrlimit(int resource, struct rlimit *rlim)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_getrlimit(resource, rlim);
+#else
 	int ret;
-
 	ret = getrlimit(resource, rlim);
 	return (ret < 0) ? -errno : ret;
+#endif
 }
 
 static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_setrlimit(resource, rlim);
+#else
 	int ret;
-
 	ret = setrlimit(resource, rlim);
 	return (ret < 0) ? -errno : ret;
+#endif
 }
 
 static inline int uring_close(int fd)
 {
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_close(fd);
+#else
 	int ret;
-
 	ret = close(fd);
 	return (ret < 0) ? -errno : ret;
+#endif
 }
 
 #endif
-- 
2.30.2

