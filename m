Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B076D424075
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 16:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhJFOxD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 10:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238440AbhJFOxB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 10:53:01 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F1FC061753
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 07:51:09 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m5so2574935pfk.7
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 07:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MogOipOAwJIQ5uX57MD9henwnkoTFr+JVIw/x76Tg70=;
        b=B9aSZH9lBCu6LIwx21SJfIcz6H0aBmubX9wRlvZP6NayoN4YShlZhuAsX4tKhwGjXD
         rhhyyUUyTjBSzbqETszIZx+jFrjXHtBZ8H79qeIjpjYNaJiFXjDFvROEYuOujBUR4+GO
         OscPtl5o2vZsW902DDTR9nzkB21Gr5dIgmlg86Im7S0nqbCo6r6AExhVa7efmSWxzx9D
         KIfJy4zGhdg4ccrk7pkduxyoYPaNaBMd9cFszgkX/pd1GKZr549UAoMuBJLqQ9Ti7Mie
         J88H0kCSlxkrK20udmfJc9+sNQI3zbNflp3wAmluKOnryWlmwwXyPz3oMWICE/0gWfkI
         q8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MogOipOAwJIQ5uX57MD9henwnkoTFr+JVIw/x76Tg70=;
        b=pVyiB5WBEUCZM+/3K8W8dxm3y6w9g7Rsp62xo+DwP5a2202w+cfkNhfzcbX1M1R2lm
         g4VMEtyDtgPv3vefyd+jiPdUySBnbNLOtA+Aj2Tmchq/1VmkuTo+f+kjkY8BSIERNIQk
         qGpMuhPespCrAFbvjQ3gRoJRRzQxXABXg9iqj+b79RvRnmTXAYtUPcR/C0Mjwln5lNI5
         K5UyTeRgZ0DsB27EzVZU11nyMIWIkbTocZQyX8IrMKxvJpMMviErvjx0Bnk3J6lezVx5
         aXV//WfQ+5FNCVgeGL3AhMqujIIo1jOEOOextN2ufS3insWJ1DQPeWkhSYKidg1wsyCV
         izcA==
X-Gm-Message-State: AOAM530vpO0ac5CjaBLP/pLM6frd/HFjq7Fe7X/I7hT12gsEt2TZZrlN
        d42bfzphdOzeZsArKbATJQrC6+xDvLeIcMat
X-Google-Smtp-Source: ABdhPJw+ckQBDsSsJQPi2ZZjX6xK8UbwOIwgsLpeHwxRlM3v7YoRlDD4/As/vM2atVGqtcBrMu5uAQ==
X-Received: by 2002:a63:ef57:: with SMTP id c23mr20581570pgk.60.1633531868715;
        Wed, 06 Oct 2021 07:51:08 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id y197sm19155429pfc.56.2021.10.06.07.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 07:51:08 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v1 RFC liburing 2/6] Add no libc support
Date:   Wed,  6 Oct 2021 21:49:08 +0700
Message-Id: <20211006144911.1181674-3-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
References: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create `src/no_libc.c` to substitute libc functions like `memset()`,
`malloc()` and `free()`. Only build this file when we build liburing
without libc.

Wrap libc functions with `static inline` functions, defined in
`src/lib.h`, currently we have:
 1) `get_page_size`
 2) `uring_memset`
 3) `uring_malloc`
 4) `uring_free`

Extra notes for tests:
 1) Functions in `src/syscall.c` require libc to work.
 2) Tests require functions in `src/syscall.c`.

So we build `src/syscall.c` manually from test's Makefile.

The Makefile in `src/` dir still builds `src/syscall.c` when we
compile liburing with libc.

Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Cc: Louvian Lyndal <louvianlyndal@gmail.com>
Link: https://github.com/axboe/liburing/issues/443
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/Makefile   | 13 +++++++++-
 src/lib.h      | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 src/no_libc.c  | 48 +++++++++++++++++++++++++++++++++++
 src/queue.c    |  1 +
 src/register.c |  1 +
 src/setup.c    | 16 +++++-------
 src/syscall.c  | 11 +++++++-
 test/Makefile  | 23 ++++++++++++++---
 8 files changed, 167 insertions(+), 15 deletions(-)
 create mode 100644 src/lib.h
 create mode 100644 src/no_libc.c

diff --git a/src/Makefile b/src/Makefile
index 5e46a9d..3ca2ac7 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -32,11 +32,22 @@ endif
 
 all: $(all_targets)
 
-liburing_srcs := setup.c queue.c syscall.c register.c
+liburing_srcs := setup.c queue.c register.c
+
+ifeq ($(LIBURING_NOLIBC),y)
+	liburing_srcs += no_libc.c
+	override CFLAGS += -nostdlib -nolibc -nodefaultlibs -ffreestanding -fno-stack-protector -fpic
+	override CPPFLAGS += -nostdlib -nolibc -nodefaultlibs -ffreestanding -fno-stack-protector -fpic
+	override LINK_FLAGS += -nostdlib -nolibc -nodefaultlibs -fpic
+else
+	liburing_srcs += syscall.c
+endif
 
 liburing_objs := $(patsubst %.c,%.ol,$(liburing_srcs))
 liburing_sobjs := $(patsubst %.c,%.os,$(liburing_srcs))
 
+$(liburing_srcs): syscall.h lib.h
+
 $(liburing_objs) $(liburing_sobjs): include/liburing/io_uring.h
 
 %.os: %.c
diff --git a/src/lib.h b/src/lib.h
new file mode 100644
index 0000000..171eee7
--- /dev/null
+++ b/src/lib.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: MIT */
+#ifndef LIBURING_LIB_H
+#define LIBURING_LIB_H
+
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
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
+void *__uring_memset(void *s, int c, size_t n);
+
+static inline void *uring_memset(void *s, int c, size_t n)
+{
+#ifdef LIBURING_NOLIBC
+	return __uring_memset(s, c, n);
+#else
+	return memset(s, c, n);
+#endif
+}
+
+void *__uring_malloc(size_t len);
+
+static inline void *uring_malloc(size_t len)
+{
+#ifdef LIBURING_NOLIBC
+	return __uring_malloc(len);
+#else
+	return malloc(len);
+#endif
+}
+
+void __uring_free(void *p);
+
+static inline void uring_free(void *p)
+{
+#ifdef LIBURING_NOLIBC
+	__uring_free(p);
+#else
+	free(p);
+#endif
+}
+
+#endif /* #ifndef LIBURING_LIB_H */
diff --git a/src/no_libc.c b/src/no_libc.c
new file mode 100644
index 0000000..149426c
--- /dev/null
+++ b/src/no_libc.c
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
+void *__uring_memset(void *s, int c, size_t n)
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
+void *__uring_malloc(size_t len)
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
+void __uring_free(void *p)
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
index 9af29d5..cd76048 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -13,6 +13,7 @@
 #include "liburing.h"
 #include "liburing/barrier.h"
 
+#include "lib.h"
 #include "syscall.h"
 
 /*
diff --git a/src/register.c b/src/register.c
index 074223f..f8e88cf 100644
--- a/src/register.c
+++ b/src/register.c
@@ -12,6 +12,7 @@
 #include "liburing/io_uring.h"
 #include "liburing.h"
 
+#include "lib.h"
 #include "syscall.h"
 
 int io_uring_register_buffers_update_tag(struct io_uring *ring, unsigned off,
diff --git a/src/setup.c b/src/setup.c
index 4f006de..0f64a35 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -12,6 +12,7 @@
 #include "liburing/io_uring.h"
 #include "liburing.h"
 
+#include "lib.h"
 #include "syscall.h"
 
 static void io_uring_unmap_rings(struct io_uring_sq *sq, struct io_uring_cq *cq)
@@ -161,7 +162,7 @@ int io_uring_queue_init(unsigned entries, struct io_uring *ring, unsigned flags)
 {
 	struct io_uring_params p;
 
-	memset(&p, 0, sizeof(p));
+	uring_memset(&p, 0, sizeof(p));
 	p.flags = flags;
 
 	return io_uring_queue_init_params(entries, ring, &p);
@@ -184,16 +185,16 @@ struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
 	int r;
 
 	len = sizeof(*probe) + 256 * sizeof(struct io_uring_probe_op);
-	probe = malloc(len);
+	probe = uring_malloc(len);
 	if (!probe)
 		return NULL;
-	memset(probe, 0, len);
+	uring_memset(probe, 0, len);
 
 	r = io_uring_register_probe(ring, probe, 256);
 	if (r >= 0)
 		return probe;
 
-	free(probe);
+	uring_free(probe);
 	return NULL;
 }
 
@@ -214,7 +215,7 @@ struct io_uring_probe *io_uring_get_probe(void)
 
 void io_uring_free_probe(struct io_uring_probe *probe)
 {
-	free(probe);
+	uring_free(probe);
 }
 
 static int __fls(int x)
@@ -336,10 +337,7 @@ ssize_t io_uring_mlock_size_params(unsigned entries, struct io_uring_params *p)
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
diff --git a/test/Makefile b/test/Makefile
index 2936469..ddb589b 100644
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
 
@@ -153,11 +153,26 @@ test_targets += sq-full-cpp
 endif
 all_targets += sq-full-cpp
 
-helpers = helpers.o
+#
+# Note:
+#
+# Build ../src/syscall.c manually from test's Makefile to support
+# build liburing without libc.
+#
+# Functions in ../src/syscall.c require libc to work with, if we
+# build liburing.so without libc, we don't have those functions
+# in liburing.so.
+#
+# This makes the tests can run for liburing.so without libc.
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

