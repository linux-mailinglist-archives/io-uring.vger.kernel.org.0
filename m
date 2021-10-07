Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55997424D51
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 08:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhJGGeV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 02:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhJGGeU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 02:34:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0D4C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 23:32:27 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id j15so3250932plh.7
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 23:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qKecDzgGHoSKTajcDl9/qLo0okfLxSlAZcreLKYU4hA=;
        b=COQDjVii9yHTdos8et4Y66U9Oe/h0wliweoSL/y+UrvYvoNQtWICRyhswDnOTaot9S
         TOhoxtetjuGQj1TmTEwW55PfjktCZunaPJ+x+NUrbkx9mLR0GD2hTXTX1GQRuCc3tLMR
         8lZwUvs6HKuKIQfqhYsL84Rcag1t/Q2caaic/GlhHNpCJU3PaO1FqIdEY8dLVAy5qUMz
         Nfbd3GKokOCAV+fayG9w8W3cQe+8ypM5GnLhmVhpkvqGAx0GY8YwnIJvZPii8+etcNxd
         XAFkvnenNe/5fl2HyqfTKuGL9T9Z0NycEbcaKiP5t+EpdAjBKRUiEDtOd+T9y1pJvDoI
         yhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qKecDzgGHoSKTajcDl9/qLo0okfLxSlAZcreLKYU4hA=;
        b=azlzEKKHLrR9r5McHzd/QswSeJfPpV48okzDrI/I/4oKJb/Abhj6DuZrfsOc1kbtrg
         EWy5Y84OZ1WHxLeAHz8WTgsyKW6VbjZ1q1Tc51C1DObPAWi5Vp0iHEILdt6hbCjDFaZV
         gHgLh785Y0sxr0Bh7X2g+Dnf58qbqDKagcqEpQF/HltTOT0gVwy51XacBNOCQ1jweF7s
         DUf3csH42HPOgwmLmtcWEz/cH66D5fZdWuPCLrPaMqyGkrmz4I+YQDeKGsd53cPM9Obv
         RyQfGDJr9fTEVEeSJwWWcaDPoDFvfcyJ7E/oVL2nfRPkGPG4G3MsyD5Bv+eAUwQAQDGO
         iBIw==
X-Gm-Message-State: AOAM531VvMlcejpa9SzqzzX6QcVv7GLhEM+4hr4b4YFQ2x/TmlLAwiuK
        BVeHHLO0dr5Xe+mFdZ+XtJzVgm2RAlZrzOms
X-Google-Smtp-Source: ABdhPJzol5xWq5soi19tR6/pMrflOnW0lsUrpgR43+uHCrtQmDpXTUASEsQ1tqpqF4vGaGCMTldyOw==
X-Received: by 2002:a17:902:b70d:b0:13d:f6c9:2066 with SMTP id d13-20020a170902b70d00b0013df6c92066mr2260107pls.2.1633588347044;
        Wed, 06 Oct 2021 23:32:27 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id k35sm7103919pjc.53.2021.10.06.23.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 23:32:26 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v2 RFC liburing 3/5] Add arch dependent directory and files
Date:   Thu,  7 Oct 2021 13:31:55 +0700
Message-Id: <20211007063157.1311033-4-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
References: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
 <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
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

