Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AC241F943
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 03:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhJBByq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 21:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbhJBByq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 21:54:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B713FC061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 18:53:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g2so9441481pfc.6
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 18:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=POnc9qGJd0rATAG0I/Du+VwuzBG2D0HQROeYtmzO+RQ=;
        b=Dv4IZDak6Sg29bggelaUbXBoUsgvPX2V96mFrXrQXKI4FnEE95gtRyotQp6Ojllcb3
         5s2FuxvEQhIlILQHH8emvtas7HnXuperYh2crIPcuJ6VS62/2+EsyHg/5xxtjE6xCoZf
         nqw1dglJDxM84HBskPkNhwc1qHza8ur2dFw3zO6gW0uZkSDYnpRe9JO9yyc1t2F9/Ftb
         yOsWm1Y/DLz1rOWcTyGJcyCpNCPwMGQV6ijbmnUxD6dh08OoJOIm5Nbv+P5MyI89uYPO
         lNDIAF02wESoIoi6V8spvgKxPbfYVNe5xqZZpz02C+4SM4euV6BtLntYLQxWKdSIn3du
         q0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=POnc9qGJd0rATAG0I/Du+VwuzBG2D0HQROeYtmzO+RQ=;
        b=jYPh5ZbZNk84vtMGXXcJebfN3WrDWy2JcVhfLjiY2NRUjBZe0p4L1rdlhPnw7ivttx
         d2HXpSqRS0mUfvgQaPJO990biLKViAOd24N2ABP2OwFDxQppjuHYv18iM4e7aLiaXG5e
         C8fOHk+EXZkNssKq+V2JUyQs/6/Wijpz1xAn2FSgZEFkYI/ZCWm1k84v/CYQY086L3Hy
         gwEQEdvvJ3HpnaKYN6Ei6zuSG1F5nFLlIYZxyM++T8l68I1S+CYjVFGv7GWrkSALcnhF
         /FeitmNtYvkrT+1KjE+BoCG3i+vfrJLf3QhoaHaOOykIhX+51MOM+mrEMQNNsQ6y20an
         ODoA==
X-Gm-Message-State: AOAM533fmuSmVphqKANFfy1jec18oA+n81jKQSVpq/qKuPFNwPmUYayA
        s3u3diGxZ1zHAM+dRqJ25wm2Yg==
X-Google-Smtp-Source: ABdhPJzk4S9JS1gC6590Ylsjx3vI2e0G8s9G8CeLFWWJbdbCdsoc5rWTNxZcgRpMGk6Z1hoPMKyQ8g==
X-Received: by 2002:a63:f512:: with SMTP id w18mr999547pgh.280.1633139581216;
        Fri, 01 Oct 2021 18:53:01 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id u4sm6989804pfn.190.2021.10.01.18.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:53:00 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v3 RFC liburing 3/4] Wrap all syscalls in a kernel style return value
Date:   Sat,  2 Oct 2021 08:48:28 +0700
Message-Id: <20211002014829.109096-4-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
References: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add new syscall wrapper functions (5):
  1) `liburing_mmap`
  2) `liburing_munmap`
  3) `liburing_madvise`
  4) `liburing_getrlimit`
  5) `liburing_setrlimit`

All of them are `static inline`.

Use them to wrap the syscalls in a kernel style return value. The
main purpose of this change is to make it possible to remove the
dependency of `errno` variable in liburing sources (so that later,
we can support no libc environment).

Also add kernel error header `src/kernel_err.h`, this is taken from
the Linux kernel source `include/linux/err.h` with a bit modification.

The purpose of `src/kernel_err.h` file is to use `PTR_ERR()`,
`ERR_PTR()`, etc. to implement the kernel style return value (for
pointer return value). Currently only `liburing_mmap()` that depends
on this kernel error header file.

A bit modification summary on kernel erro header file:
  1) Add `__must_check` attribute macro.
  2) `#include <liburing.h>` to take the `uring_likely` and
     `uring_unlikely` macros.

Link: https://github.com/axboe/liburing/issues/443#issuecomment-927873932
Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Suggested-by: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/kernel_err.h | 75 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/register.c   |  5 ++--
 src/setup.c      | 56 +++++++++++++++++++-----------------
 src/syscall.h    | 48 +++++++++++++++++++++++++++++++
 4 files changed, 155 insertions(+), 29 deletions(-)
 create mode 100644 src/kernel_err.h

diff --git a/src/kernel_err.h b/src/kernel_err.h
new file mode 100644
index 0000000..b9ea5fe
--- /dev/null
+++ b/src/kernel_err.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ERR_H
+#define _LINUX_ERR_H
+
+#include <linux/types.h>
+
+#include <asm/errno.h>
+
+#include <stdbool.h>
+#include <liburing.h>
+
+/*
+ * Kernel pointers have redundant information, so we can use a
+ * scheme where we can return either an error code or a normal
+ * pointer with the same return value.
+ *
+ * This should be a per-architecture thing, to allow different
+ * error and pointer decisions.
+ */
+#define MAX_ERRNO	4095
+
+#ifndef __ASSEMBLY__
+
+#define IS_ERR_VALUE(x) uring_unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warn_005funused_005fresult-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#nodiscard-warn-unused-result
+ */
+#define __must_check __attribute__((__warn_unused_result__))
+
+static inline void * __must_check ERR_PTR(long error)
+{
+	return (void *) error;
+}
+
+static inline long __must_check PTR_ERR(const void *ptr)
+{
+	return (long) ptr;
+}
+
+static inline bool __must_check IS_ERR(const void *ptr)
+{
+	return IS_ERR_VALUE((unsigned long)ptr);
+}
+
+static inline bool __must_check IS_ERR_OR_NULL(const void *ptr)
+{
+	return uring_unlikely(!ptr) || IS_ERR_VALUE((unsigned long)ptr);
+}
+
+/**
+ * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
+ * @ptr: The pointer to cast.
+ *
+ * Explicitly cast an error-valued pointer to another pointer type in such a
+ * way as to make it clear that's what's going on.
+ */
+static inline void * __must_check ERR_CAST(const void *ptr)
+{
+	/* cast away the const */
+	return (void *) ptr;
+}
+
+static inline int __must_check PTR_ERR_OR_ZERO(const void *ptr)
+{
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+	else
+		return 0;
+}
+
+#endif /* #ifndef __ASSEMBLY__ */
+
+#endif /* #ifndef _LINUX_ERR_H */
diff --git a/src/register.c b/src/register.c
index 944852e..770a672 100644
--- a/src/register.c
+++ b/src/register.c
@@ -4,7 +4,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
@@ -107,11 +106,11 @@ static int increase_rlimit_nofile(unsigned nr)
 {
 	struct rlimit rlim;
 
-	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
+	if (liburing_getrlimit(RLIMIT_NOFILE, &rlim) < 0)
 		return -errno;
 	if (rlim.rlim_cur < nr) {
 		rlim.rlim_cur += nr;
-		setrlimit(RLIMIT_NOFILE, &rlim);
+		liburing_setrlimit(RLIMIT_NOFILE, &rlim);
 	}
 
 	return 0;
diff --git a/src/setup.c b/src/setup.c
index edfe94e..7476e1e 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -3,7 +3,6 @@
 
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/mman.h>
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
@@ -15,12 +14,13 @@
 #include "liburing.h"
 
 #include "syscall.h"
+#include "kernel_err.h"
 
 static void io_uring_unmap_rings(struct io_uring_sq *sq, struct io_uring_cq *cq)
 {
-	munmap(sq->ring_ptr, sq->ring_sz);
+	liburing_munmap(sq->ring_ptr, sq->ring_sz);
 	if (cq->ring_ptr && cq->ring_ptr != sq->ring_ptr)
-		munmap(cq->ring_ptr, cq->ring_sz);
+		liburing_munmap(cq->ring_ptr, cq->ring_sz);
 }
 
 static int io_uring_mmap(int fd, struct io_uring_params *p,
@@ -37,19 +37,22 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 			sq->ring_sz = cq->ring_sz;
 		cq->ring_sz = sq->ring_sz;
 	}
-	sq->ring_ptr = mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
-			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQ_RING);
-	if (sq->ring_ptr == MAP_FAILED)
-		return -errno;
+	sq->ring_ptr = liburing_mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
+				     MAP_SHARED | MAP_POPULATE, fd,
+				     IORING_OFF_SQ_RING);
+	if (IS_ERR(sq->ring_ptr))
+		return PTR_ERR(sq->ring_ptr);
 
 	if (p->features & IORING_FEAT_SINGLE_MMAP) {
 		cq->ring_ptr = sq->ring_ptr;
 	} else {
-		cq->ring_ptr = mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
-				MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_CQ_RING);
-		if (cq->ring_ptr == MAP_FAILED) {
+		cq->ring_ptr = liburing_mmap(0, cq->ring_sz,
+					     PROT_READ | PROT_WRITE,
+					     MAP_SHARED | MAP_POPULATE, fd,
+					     IORING_OFF_CQ_RING);
+		if (IS_ERR(cq->ring_ptr)) {
+			ret = PTR_ERR(cq->ring_ptr);
 			cq->ring_ptr = NULL;
-			ret = -errno;
 			goto err;
 		}
 	}
@@ -63,11 +66,11 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 	sq->array = sq->ring_ptr + p->sq_off.array;
 
 	size = p->sq_entries * sizeof(struct io_uring_sqe);
-	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
-				MAP_SHARED | MAP_POPULATE, fd,
-				IORING_OFF_SQES);
-	if (sq->sqes == MAP_FAILED) {
-		ret = -errno;
+	sq->sqes = liburing_mmap(0, size, PROT_READ | PROT_WRITE,
+				 MAP_SHARED | MAP_POPULATE, fd,
+				 IORING_OFF_SQES);
+	if (IS_ERR(sq->sqes)) {
+		ret = PTR_ERR(sq->sqes);
 err:
 		io_uring_unmap_rings(sq, cq);
 		return ret;
@@ -116,20 +119,20 @@ int io_uring_ring_dontfork(struct io_uring *ring)
 		return -EINVAL;
 
 	len = *ring->sq.kring_entries * sizeof(struct io_uring_sqe);
-	ret = madvise(ring->sq.sqes, len, MADV_DONTFORK);
-	if (ret == -1)
-		return -errno;
+	ret = liburing_madvise(ring->sq.sqes, len, MADV_DONTFORK);
+	if (uring_unlikely(ret))
+		return ret;
 
 	len = ring->sq.ring_sz;
-	ret = madvise(ring->sq.ring_ptr, len, MADV_DONTFORK);
-	if (ret == -1)
-		return -errno;
+	ret = liburing_madvise(ring->sq.ring_ptr, len, MADV_DONTFORK);
+	if (uring_unlikely(ret))
+		return ret;
 
 	if (ring->cq.ring_ptr != ring->sq.ring_ptr) {
 		len = ring->cq.ring_sz;
-		ret = madvise(ring->cq.ring_ptr, len, MADV_DONTFORK);
-		if (ret == -1)
-			return -errno;
+		ret = liburing_madvise(ring->cq.ring_ptr, len, MADV_DONTFORK);
+		if (uring_unlikely(ret))
+			return ret;
 	}
 
 	return 0;
@@ -173,7 +176,8 @@ void io_uring_queue_exit(struct io_uring *ring)
 	struct io_uring_sq *sq = &ring->sq;
 	struct io_uring_cq *cq = &ring->cq;
 
-	munmap(sq->sqes, *sq->kring_entries * sizeof(struct io_uring_sqe));
+	liburing_munmap(sq->sqes,
+			*sq->kring_entries * sizeof(struct io_uring_sqe));
 	io_uring_unmap_rings(sq, cq);
 	close(ring->ring_fd);
 }
diff --git a/src/syscall.h b/src/syscall.h
index 5f7343f..0de021f 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -5,7 +5,10 @@
 #include <errno.h>
 #include <signal.h>
 #include <unistd.h>
+#include <sys/mman.h>
 #include <sys/syscall.h>
+#include <sys/resource.h>
+#include "kernel_err.h"
 
 #ifdef __alpha__
 /*
@@ -99,4 +102,49 @@ static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
 				       _NSIG / 8);
 }
 
+static inline void *liburing_mmap(void *addr, size_t length, int prot,
+				  int flags, int fd, off_t offset)
+{
+	void *ret;
+
+	ret = mmap(addr, length, prot, flags, fd, offset);
+	if (ret == MAP_FAILED)
+		ret = ERR_PTR(-errno);
+
+	return ret;
+}
+
+static inline int liburing_munmap(void *addr, size_t length)
+{
+	int ret;
+
+	ret = munmap(addr, length);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int liburing_madvise(void *addr, size_t length, int advice)
+{
+	int ret;
+
+	ret = madvise(addr, length, advice);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int liburing_getrlimit(int resource, struct rlimit *rlim)
+{
+	int ret;
+
+	ret = getrlimit(resource, rlim);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int liburing_setrlimit(int resource, const struct rlimit *rlim)
+{
+	int ret;
+
+	ret = setrlimit(resource, rlim);
+	return (ret < 0) ? -errno : ret;
+}
+
+
 #endif
-- 
2.30.2

