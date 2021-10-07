Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BCC4255F6
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 17:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242259AbhJGPFD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 11:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242052AbhJGPFC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 11:05:02 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F33C061570
        for <io-uring@vger.kernel.org>; Thu,  7 Oct 2021 08:03:09 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 66so53214pgc.9
        for <io-uring@vger.kernel.org>; Thu, 07 Oct 2021 08:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qKecDzgGHoSKTajcDl9/qLo0okfLxSlAZcreLKYU4hA=;
        b=PM924c20BofxFk2Cv5favgGFngF68msfwmiLzIKKXoclOPxyXlyPnRbbnFUfwwObR9
         JdhUOIx7o1TSHi2BglZVeglUxuHJH8SzG0rxbQvDvLOszmzvwI4m0mV9tlkhG2mJ5fsK
         DD/xltyPmBq89NyPuNM/md4AHpYlLhHMrvqqiIck6nRoUHRLsfQDsIK+yxWF2LRuC45f
         Nv3eAgiFPF1iUzR9k9U+VpTs66bw54j4z8gv0V0TIgfXznpEgRVHO45P/bk+muLC5TTJ
         FFQf6L7hLy8f98C88WOpnagam5gEUGEabpfk497iLsW33F+C5d5PCFvILe6U8uh69Kas
         NjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qKecDzgGHoSKTajcDl9/qLo0okfLxSlAZcreLKYU4hA=;
        b=Quldw1NL3NHtiUJff1/j/plZHMI+3X0pL9zlIWlWcqfb2DKw5C3GlVALWdu2aU4X9e
         UOFapdSd2CbXwyKdpwRDRojxLNUsfHtp/5xS49Nu39xJT2xmv3CHMMRJ2OAp+KuK4tIN
         01KVC652+G/MC5uPx/3ewVxw+SBcB6gqr5ZgSaVE20yAHRQ1Xh95LzExa/gv6K5IYD/7
         SRLrbOvkvFB3YF2df1+zUefW+z16VNG+ZGr+Dzjq9xuh5JdhOmmveyLairspvpygLNkI
         y/wHVMmBfyqzhD5+zhWKmNuetsRaQo05FzsklSoGBInjSwbxq94ZEgspnvc64p0+kji/
         Tt9A==
X-Gm-Message-State: AOAM532WqsgkV7eFsEi/N0S2dB+r9MXGDH6UzjMeQr8hZDX8btEHiNfA
        XpwVV957dySyOxw6ege/iNYdag==
X-Google-Smtp-Source: ABdhPJzd14N4+R0r0L9Fl/qecNI06sU9lHKiqg/Jf85L9aqghh/x71RmmQNakN3S16L/HsStC69kew==
X-Received: by 2002:aa7:8116:0:b0:44b:e0d1:25e9 with SMTP id b22-20020aa78116000000b0044be0d125e9mr4621115pfi.53.1633618987018;
        Thu, 07 Oct 2021 08:03:07 -0700 (PDT)
Received: from integral.. ([182.2.71.117])
        by smtp.gmail.com with ESMTPSA id z23sm25078983pgv.45.2021.10.07.08.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 08:03:06 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 2/4] Add arch dependent directory and files
Date:   Thu,  7 Oct 2021 22:02:08 +0700
Message-Id: <20211007150210.1390189-3-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007150210.1390189-1-ammar.faizi@students.amikom.ac.id>
References: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
 <20211007150210.1390189-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create a new directory `src/arch` to save arch dependent sources.
Add support start from x86-64, add syscalls crafted in Assembly code
and lib (currently the lib only contains get page size function).

Link: https://github.com/axboe/liburing/issues/443
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/arch/x86/lib.h     |  26 ++++++
 src/arch/x86/syscall.h | 200 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)
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
index 0000000..be18165
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
+	register off_t r9 __asm__("r9") = offset;
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
+	long rax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)		/* %rax */
+		: "a"(__NR_munmap),	/* %rax */
+		  "D"(addr),		/* %rdi */
+		  "S"(length)		/* %rsi */
+		: "memory", "rcx", "r11"
+	);
+	return (int) rax;
+}
+
+static inline int __arch_impl_madvise(void *addr, size_t length, int advice)
+{
+	long rax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)		/* %rax */
+		: "a"(__NR_madvise),	/* %rax */
+		  "D"(addr),		/* %rdi */
+		  "S"(length),		/* %rsi */
+		  "d"(advice)		/* %rdx */
+		: "memory", "rcx", "r11"
+	);
+	return (int) rax;
+}
+
+static inline int __arch_impl_getrlimit(int resource, struct rlimit *rlim)
+{
+	long rax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)		/* %rax */
+		: "a"(__NR_getrlimit),	/* %rax */
+		  "D"(resource),	/* %rdi */
+		  "S"(rlim)		/* %rsi */
+		: "memory", "rcx", "r11"
+	);
+	return (int) rax;
+}
+
+static inline int __arch_impl_setrlimit(int resource, const struct rlimit *rlim)
+{
+	long rax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)		/* %rax */
+		: "a"(__NR_setrlimit),	/* %rax */
+		  "D"(resource),	/* %rdi */
+		  "S"(rlim)		/* %rsi */
+		: "memory", "rcx", "r11"
+	);
+	return (int) rax;
+}
+
+static inline int __arch_impl_close(int fd)
+{
+	long rax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)		/* %rax */
+		: "a"(__NR_close),	/* %rax */
+		  "D"(fd)		/* %rdi */
+		: "memory", "rcx", "r11"
+	);
+	return (int) rax;
+}
+
+static inline int __arch_impl_io_uring_register(int fd, unsigned opcode,
+						const void *arg,
+						unsigned nr_args)
+{
+	long rax;
+	register unsigned r10 __asm__("r10") = nr_args;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)			/* %rax */
+		: "a"(__NR_io_uring_register),	/* %rax */
+		  "D"(fd),			/* %rdi */
+		  "S"(opcode),			/* %rsi */
+		  "d"(arg),			/* %rdx */
+		  "r"(r10)			/* %r10 */
+		: "memory", "rcx", "r11"
+	);
+	return (int) rax;
+}
+
+static inline int __arch_impl_io_uring_setup(unsigned entries,
+					     struct io_uring_params *p)
+{
+	long rax;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)			/* %rax */
+		: "a"(__NR_io_uring_setup),	/* %rax */
+		  "D"(entries),			/* %rdi */
+		  "S"(p)			/* %rsi */
+		: "memory", "rcx", "r11"
+	);
+	return (int) rax;
+}
+
+static inline int __arch_impl_io_uring_enter(int fd, unsigned to_submit,
+					     unsigned min_complete,
+					     unsigned flags, sigset_t *sig,
+					     int sz)
+{
+	long rax;
+	register unsigned r10 __asm__("r10") = flags;
+	register sigset_t *r8 __asm__("r8") = sig;
+	register int r9 __asm__("r9") = sz;
+
+	__asm__ volatile(
+		"syscall"
+		: "=a"(rax)
+		: "a"(__NR_io_uring_enter),	/* %rax */
+		  "D"(fd),			/* %rdi */
+		  "S"(to_submit),		/* %rsi */
+		  "d"(min_complete),		/* %rdx */
+		  "r"(r10),			/* %r10 */
+		  "r"(r8),			/* %r8  */
+		  "r"(r9)			/* %r9  */
+		: "memory", "rcx", "r11"
+	);
+	return (int) rax;
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
-- 
2.30.2

