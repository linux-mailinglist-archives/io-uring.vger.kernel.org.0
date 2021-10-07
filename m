Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0129F4255F7
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 17:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbhJGPFH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 11:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242262AbhJGPFG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 11:05:06 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4ECC061746
        for <io-uring@vger.kernel.org>; Thu,  7 Oct 2021 08:03:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g14so5601443pfm.1
        for <io-uring@vger.kernel.org>; Thu, 07 Oct 2021 08:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJYee+t8cOcEOM8iDMrDU8LNmsCMupYrMxPaLw6gyck=;
        b=XqMqXTqS9ZrZbw7utgHstii5EXR4vJkAwSGfm8lwKzSE//JCEqgQeSxhq5r42X7mVD
         PRkkNO0/v+JVC5zHS0yem9c0vyWNpjrsSUAYPGgJZJRkPDrv2EP4kSR0DY8A/0uKUsr3
         hRYIa57meNec5W3m+CKfkKxaxdwJBLjF1H3/2vK28YuxSRDeGKWHbLIWkxyBbDZtPVZX
         qyKSeU4mE7B9yzx/Ax/qgkqr8bX5DB4Gx6cyBQYTswPb2CIFpGESIx7iXv4NQB1gefRY
         5w5YlA596RIxvCnkuQgLK1EY3VBymLtkP7xzdyS/Eoas6upsbibQWVOZQBz2CgMmTPUQ
         3AbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJYee+t8cOcEOM8iDMrDU8LNmsCMupYrMxPaLw6gyck=;
        b=qPiLx6o3qw9NNQP1ENmgh592frVKHHqAvJCX7LnommuuAbKLZjajtyOo0JlHWKjVF4
         nUytBsab/SlSDceZa2P5hKFM1OhNIpfJL58KInqM2yt0Q/QjpaCP4+49Zl0hqBizgsKz
         gg8HdZEVIDQ2DWlHhwSM6jc/d54jYHzXCceeKWyQBNvlnPsoNKXx+3+Tu5BBH6ViIV5f
         nbHCp1MELCT3QzIsDP/uCG1G8zJj8JtJBnd3fGXhwmbfleFZlFkn1Wn3iU4WSmRr4kNi
         oF+qFWBS6z99qoHHfrj+2LsPh6P0x3KSFQIrHT3hFjR/HoLLj4QuAXpwDXHd0SZEz5BX
         ZfLQ==
X-Gm-Message-State: AOAM531CWKXRnV5+OUNCTAcLZlUHv61IRvO4jZeMBgzHe/8ODTxpY5TL
        r27W4n77hE8sXcPj0oLTDc6DnA==
X-Google-Smtp-Source: ABdhPJyY7U+L1kcEHHPNVHH0YLfpZHPaaqYIdfDG42qmEV9x0m3as5nGnD4pdGObgbBqVYVPSxOEvQ==
X-Received: by 2002:a63:597:: with SMTP id 145mr105481pgf.149.1633618992040;
        Thu, 07 Oct 2021 08:03:12 -0700 (PDT)
Received: from integral.. ([182.2.71.117])
        by smtp.gmail.com with ESMTPSA id z23sm25078983pgv.45.2021.10.07.08.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 08:03:11 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 3/4] Add no libc build support
Date:   Thu,  7 Oct 2021 22:02:09 +0700
Message-Id: <20211007150210.1390189-4-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007150210.1390189-1-ammar.faizi@students.amikom.ac.id>
References: <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
 <20211007150210.1390189-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create `src/nolibc.c` to provide libc functions like `memset()`,
`malloc()` and `free()`. Only build this file when we build liburing
without libc.

Add `get_page_size()` function to get the page size. When we build
with libc, it uses `sysconf(_SC_PAGESIZE)`, otherwise it uses arch
dependent implementation function that we provide at `src/arch` dir.

Add conditional preprocessor in `src/syscall.h` to use arch dependent
syscalls written in Assembly when we build liburing without libc.

Extra notes for tests:
 1) Functions in `src/syscall.c` require libc to work.
 2) Tests require functions in `src/syscall.c`.

So we build `src/syscall.c` manually from the test's Makefile.

The Makefile in `src/` dir still builds `src/syscall.c` when we
build liburing with libc.

Link: https://github.com/axboe/liburing/issues/443
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/lib.h      | 44 +++++++++++++++++++++++++++++++
 src/nolibc.c   | 48 ++++++++++++++++++++++++++++++++++
 src/queue.c    | 14 +++-------
 src/register.c | 12 +++------
 src/setup.c    | 17 +++---------
 src/syscall.c  | 11 +++++++-
 src/syscall.h  | 71 +++++++++++++++++++++++++++++++++++++++-----------
 test/Makefile  | 19 +++++++++++---
 8 files changed, 183 insertions(+), 53 deletions(-)
 create mode 100644 src/lib.h
 create mode 100644 src/nolibc.c

diff --git a/src/lib.h b/src/lib.h
new file mode 100644
index 0000000..4c147f5
--- /dev/null
+++ b/src/lib.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: MIT */
+#ifndef LIBURING_LIB_H
+#define LIBURING_LIB_H
+
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#ifdef LIBURING_NOLIBC
+#  if defined(__x86_64__) || defined(__i386__)
+#    include "arch/x86/lib.h"
+#  else
+#    error "The arch is currently not supported to build liburing without libc"
+#  endif
+#endif
+
+#ifndef offsetof
+# define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
+#endif
+
+#ifndef container_of
+# define container_of(PTR, TYPE, FIELD) ({				\
+	__typeof__(((TYPE *)0)->FIELD) *__FIELD_PTR = (PTR);		\
+	(TYPE *)((char *) __FIELD_PTR - offsetof(TYPE, FIELD));		\
+})
+#endif
+
+
+static inline long get_page_size(void)
+{
+#ifdef LIBURING_NOLIBC
+	return __arch_impl_get_page_size();
+#else
+	long page_size;
+
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0)
+		page_size = 4096;
+
+	return page_size;
+#endif
+}
+
+#endif /* #ifndef LIBURING_LIB_H */
diff --git a/src/nolibc.c b/src/nolibc.c
new file mode 100644
index 0000000..cdf0e04
--- /dev/null
+++ b/src/nolibc.c
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef LIBURING_NOLIBC
+# error "This file should only be compiled for no libc build"
+#endif
+
+#include "lib.h"
+#include "syscall.h"
+
+void *memset(void *s, int c, size_t n)
+{
+	size_t i;
+	unsigned char *p = s;
+
+	for (i = 0; i < n; i++)
+		p[i] = (unsigned char) c;
+
+	return s;
+}
+
+struct uring_heap {
+	size_t		len;
+	char		user_p[];
+};
+
+void *malloc(size_t len)
+{
+	struct uring_heap *heap;
+
+	heap = uring_mmap(NULL, sizeof(*heap) + len, PROT_READ | PROT_WRITE,
+			  MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (IS_ERR(heap))
+		return NULL;
+
+	heap->len = sizeof(*heap) + len;
+	return heap->user_p;
+}
+
+void free(void *p)
+{
+	struct uring_heap *heap;
+
+	if (uring_unlikely(!p))
+		return;
+
+	heap = container_of(p, struct uring_heap, user_p);
+	uring_munmap(heap, heap->len);
+}
diff --git a/src/queue.c b/src/queue.c
index 9af29d5..eb0c736 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -1,19 +1,11 @@
 /* SPDX-License-Identifier: MIT */
 #define _POSIX_C_SOURCE 200112L
 
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/mman.h>
-#include <unistd.h>
-#include <string.h>
-#include <stdbool.h>
-
+#include "lib.h"
+#include "syscall.h"
+#include "liburing.h"
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
-#include "liburing.h"
-#include "liburing/barrier.h"
-
-#include "syscall.h"
 
 /*
  * Returns true if we're not using SQ thread (thus nobody submits but us)
diff --git a/src/register.c b/src/register.c
index 074223f..1f2c409 100644
--- a/src/register.c
+++ b/src/register.c
@@ -1,18 +1,12 @@
 /* SPDX-License-Identifier: MIT */
 #define _POSIX_C_SOURCE 200112L
 
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/mman.h>
-#include <sys/resource.h>
-#include <unistd.h>
-#include <string.h>
-
+#include "lib.h"
+#include "syscall.h"
+#include "liburing.h"
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
-#include "liburing.h"
 
-#include "syscall.h"
 
 int io_uring_register_buffers_update_tag(struct io_uring *ring, unsigned off,
 					 const struct iovec *iovecs,
diff --git a/src/setup.c b/src/setup.c
index 4f006de..5543468 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -1,18 +1,12 @@
 /* SPDX-License-Identifier: MIT */
 #define _DEFAULT_SOURCE
 
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include <string.h>
-#include <stdlib.h>
-#include <signal.h>
-
+#include "lib.h"
+#include "syscall.h"
+#include "liburing.h"
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
-#include "liburing.h"
 
-#include "syscall.h"
 
 static void io_uring_unmap_rings(struct io_uring_sq *sq, struct io_uring_cq *cq)
 {
@@ -336,10 +330,7 @@ ssize_t io_uring_mlock_size_params(unsigned entries, struct io_uring_params *p)
 		cq_entries = 2 * entries;
 	}
 
-	page_size = sysconf(_SC_PAGESIZE);
-	if (page_size < 0)
-		page_size = 4096;
-
+	page_size = get_page_size();
 	return rings_size(entries, cq_entries, page_size);
 }
 
diff --git a/src/syscall.c b/src/syscall.c
index 5923fbb..cfb3ee2 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -1,6 +1,16 @@
 /* SPDX-License-Identifier: MIT */
 #define _DEFAULT_SOURCE
 
+/*
+ * Functions in this file require libc, only build them when we use libc.
+ *
+ * Note:
+ * liburing's tests still need these functions.
+ */
+#if defined(LIBURING_NOLIBC) && !defined(LIBURING_BUILD_TEST)
+# error "This file should only be compiled for libc build"
+#endif
+
 /*
  * Will go away once libc support is there
  */
@@ -11,7 +21,6 @@
 #include "liburing/io_uring.h"
 #include "syscall.h"
 
-
 int __sys_io_uring_register(int fd, unsigned opcode, const void *arg,
 			    unsigned nr_args)
 {
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
diff --git a/test/Makefile b/test/Makefile
index 2936469..1a10a24 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -21,8 +21,8 @@ ifdef CONFIG_HAVE_ARRAY_BOUNDS
 endif
 
 CXXFLAGS ?= $(CFLAGS)
-override CFLAGS += $(XCFLAGS)
-override CXXFLAGS += $(XCFLAGS) -std=c++11
+override CFLAGS += $(XCFLAGS) -DLIBURING_BUILD_TEST
+override CXXFLAGS += $(XCFLAGS) -std=c++11 -DLIBURING_BUILD_TEST
 LDFLAGS ?=
 override LDFLAGS += -L../src/ -luring
 
@@ -153,11 +153,22 @@ test_targets += sq-full-cpp
 endif
 all_targets += sq-full-cpp
 
-helpers = helpers.o
+#
+# Build ../src/syscall.c manually from test's Makefile to support
+# liburing nolibc.
+#
+# Functions in ../src/syscall.c require libc to work with, if we
+# build liburing without libc, we don't have those functions
+# in liburing.a. So build it manually here.
+#
+helpers = helpers.o ../src/syscall.o
 
 all: ${helpers} $(test_targets)
 
-helpers.o: helpers.c helpers.c
+../src/syscall.o: ../src/syscall.c
+	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
+
+helpers.o: helpers.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
 
 %: %.c ${helpers} helpers.h
-- 
2.30.2

