Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58921428198
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhJJNzu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 09:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhJJNzt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 09:55:49 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1815FC061570
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 06:53:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id np13so11181461pjb.4
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 06:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cpSfIWM5bzLkJBtX/pgypTbxu1NHrzvtNLLCLwv7OKA=;
        b=RXAZ/xf68NAWAqs5ZycMG462Fh8p+utnpaMJfD0iVtVkflWcnKWOe8efTBJfH9DclS
         mYSjw6R3uqBZXLQif6zdnK0J1UKN/CzZvDQAFTHIYaC83Q9z+iDAip24+lJdYzzxqncN
         xXK3Kf7N6LXI91XLocTpQr8hqRsq64gI9Qr10mj0XVIrlc0OT/BcS5nHGG3nzlMBwhzo
         MrP9aqHURrBUWO860jnpjzWNe2mGQjlx2MmZmIq0HUA/n4iMIa7Pt9UtBL64SZDqbJ0X
         HJZ6NZ9G1UdZVPRb1pPUS8w+DjfWSHV9Ql0OYb5FEGgLpXDfNo4j2SoaqquUMJY4mDI9
         iuaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cpSfIWM5bzLkJBtX/pgypTbxu1NHrzvtNLLCLwv7OKA=;
        b=mVKqgPoCOutdVz19nouSc5xRh4AltHEIh7Vz7HZJ+bhPZUkZA+k04s6tYdLK5WSH2R
         bAG45FFk5jAQ/WP5zW3Ue4HubYuIiWjcxGmwhN7U8Eu4dVXNNiIjHzRpV7whTzlUvGb0
         ZNqyWUxt2HWjy8IItIb10v7Jb2vfijtiGCboK6CqnJCkzxZZyg6tQ6NNGrELq3lARboW
         JRhh6JRQRZx5xAEM3lo18DKtFXfDWaz1nuD4AvnvxBi6gJZG59Xd+y03z/Zq3vtEJTuh
         UhBejvq8Tk7ibCHfNr1xVxxi3S6fwH1gQXwPZ2Xet1VL3T/eOoq35oDr/Qjw5lYE7lw5
         fWSA==
X-Gm-Message-State: AOAM532/m/iDyP/Z2vCUdPsel0BAFvLotouHvuPqOuSQy+h7w6sxISx2
        rI+VLawVS8dpU75TT3cYNX/eMw==
X-Google-Smtp-Source: ABdhPJwg4ABiuFHVqZSjIlRHdsn2DVOqwZSK/Aelf9EODBTuUWsEjxBbtSkldp5tAARlCGNwBaqqQg==
X-Received: by 2002:a17:90a:718c:: with SMTP id i12mr24604592pjk.182.1633874030645;
        Sun, 10 Oct 2021 06:53:50 -0700 (PDT)
Received: from integral.. ([182.2.41.40])
        by smtp.gmail.com with ESMTPSA id p4sm4557249pjo.0.2021.10.10.06.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 06:53:50 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v3 liburing 1/3] Add arch dependent directory and files
Date:   Sun, 10 Oct 2021 20:53:36 +0700
Message-Id: <20211010135338.397115-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010135338.397115-1-ammar.faizi@students.amikom.ac.id>
References: <20211010135338.397115-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create a new directory `src/arch` to save arch dependent sources.
Add support start from x86-64, add syscalls crafted in Assembly code
and lib (currently the lib only contains get page size function).

Link: https://github.com/axboe/liburing/issues/443
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/arch/x86/lib.h     |  26 ++++++
 src/arch/x86/syscall.h | 200 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)
 create mode 100644 src/arch/x86/lib.h
 create mode 100644 src/arch/x86/syscall.h

diff --git a/src/arch/x86/lib.h b/src/arch/x86/lib.h
new file mode 100644
index 0000000..65ad396
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
+#error "x86 (32-bit) is currently not supported for nolibc builds"
+
+#endif /* #if defined(__x86_64__) */
+
+#endif /* #ifndef LIBURING_ARCH_X86_LIB_H */
diff --git a/src/arch/x86/syscall.h b/src/arch/x86/syscall.h
new file mode 100644
index 0000000..2fb3552
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
+		: "=a"(rax)		/* %rax */
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
+		: "=a"(rax)			/* %rax */
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
+#error "x86 (32-bit) is currently not supported for nolibc builds"
+
+#endif /* #if defined(__x86_64__) */
+
+#endif /* #ifndef LIBURING_ARCH_X86_SYSCALL_H */
-- 
2.30.2

