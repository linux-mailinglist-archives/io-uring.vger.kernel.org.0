Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0CD42024E
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 17:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhJCPha (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 11:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhJCPh3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 11:37:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C060C0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 08:35:42 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y5so9476940pll.3
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 08:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/6v/WSJIPzZtl7bbxNIWNtpDpXCNK0EzbezGEgqNvm4=;
        b=WBQGlSsUk3JjERkuaPqC1P+3gOcrckXDPOvi+YLBdghGJJk6TgBUvlEy3MENzt8r34
         ryG0bTVM06NmOn1n/no+cZgZD20S4DLOpDwvskkaf9rROUdlFYw1nrUU+9euij2qtRwd
         c4beCEMEOaXQvOLw+m5a7tCUXyZT1ok08URWbYuIUApq/q7cE2Zye00Geu6SuMtrpOoV
         8QJYYXm2nzb41+jmWkiJ33EQh7Cia1dE4+Ao0NI0RCSAOS8GZHMh/0/sTnznxev7AT5A
         uHrFLiKdjxEw3E5YhXYdrhnDRd6sk6drhQ7Vy5zpgmry9MUhiIEVzhU+OuZ6xk9hmjKo
         Dlbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/6v/WSJIPzZtl7bbxNIWNtpDpXCNK0EzbezGEgqNvm4=;
        b=cr/wKqIOdnz/DrxHp4FmwcpDBDsVKw127xdNUsVfBxTivjX5DaaxDoYuvmZeknq4Rm
         75xt8EEol0FJ7KFKvkgeOCkOt8zjpc26Lhg3+yVESz1v7Db10xYT9bdoRze36LZQZ7co
         4sgZJIqyGY4JvztHcKAq7RFVIhrYt0GnX76gfv9cV1Y+mVLhZFDlIBGrQXG+ZwyIFFG0
         paL2KftqSHH6bhWJefJ0LvrV52pILrcMaYPmQprW1wWxLwndoIy5Mr4e7MV26mGDR4g7
         wAr49ZHAshKIVcJCSGCMGpP2DQAtR1ACRHfhCG4xiEbF4HnQmNwv6cCrpvLTKkixn3e3
         vfgg==
X-Gm-Message-State: AOAM533ftGzZ5F7q2/6ugRUI4wuo6HXR0JYyQ5xNJsG8MuC5lyRx8+Y6
        OSZvv5rCJv8G3AJ4Pi9qDyLRCQ==
X-Google-Smtp-Source: ABdhPJzC6YiuvUMFVFRvqzqq9bBLFqEzhvH8D22D21OvxAi5vwMMZ2njAadO0PQk6pJEDd7hFbcAKQ==
X-Received: by 2002:a17:90a:8911:: with SMTP id u17mr31678601pjn.162.1633275342038;
        Sun, 03 Oct 2021 08:35:42 -0700 (PDT)
Received: from integral.. ([182.2.73.133])
        by smtp.gmail.com with ESMTPSA id y42sm2625075pfa.203.2021.10.03.08.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 08:35:41 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v5 liburing 3/3] Wrap all syscalls in a kernel style return value
Date:   Sun,  3 Oct 2021 22:34:28 +0700
Message-Id: <20211003153428.369258-4-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
References: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add new syscall wrapper functions:
  1) `uring_mmap`
  2) `uring_munmap`
  3) `uring_madvise`
  4) `uring_getrlimit`
  5) `uring_setrlimit`

All of them are `static inline`.

Use them to wrap the syscalls in a kernel style return value. The
main purpose of this change is to make it possible to remove the
dependency of `errno` variable in liburing C sources, so that later
we can support build without libc.

Extra new helpers:
  1) `ERR_PTR()`
  2) `PTR_ERR()`
  3) `IS_ERR()`

These helpers are used to deal with syscalls that return a pointer.
Currently only `uring_mmap()` that depends on these.

Link: https://github.com/axboe/liburing/issues/443#issuecomment-927873932
Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Suggested-by: Louvian Lyndal <louvianlyndal@gmail.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/queue.c    |  1 -
 src/register.c | 10 +++++----
 src/setup.c    | 53 ++++++++++++++++++++++-----------------------
 src/syscall.h  | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 32 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index c2881e9..31aa17c 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -5,7 +5,6 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 #include <stdbool.h>
 
diff --git a/src/register.c b/src/register.c
index cb09dea..074223f 100644
--- a/src/register.c
+++ b/src/register.c
@@ -6,7 +6,6 @@
 #include <sys/mman.h>
 #include <sys/resource.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 
 #include "liburing/compat.h"
@@ -104,13 +103,16 @@ int io_uring_register_files_update(struct io_uring *ring, unsigned off,
 
 static int increase_rlimit_nofile(unsigned nr)
 {
+	int ret;
 	struct rlimit rlim;
 
-	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
-		return -errno;
+	ret = uring_getrlimit(RLIMIT_NOFILE, &rlim);
+	if (ret < 0)
+		return ret;
+
 	if (rlim.rlim_cur < nr) {
 		rlim.rlim_cur += nr;
-		setrlimit(RLIMIT_NOFILE, &rlim);
+		uring_setrlimit(RLIMIT_NOFILE, &rlim);
 	}
 
 	return 0;
diff --git a/src/setup.c b/src/setup.c
index edfe94e..bdbf97c 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -3,9 +3,7 @@
 
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/mman.h>
 #include <unistd.h>
-#include <errno.h>
 #include <string.h>
 #include <stdlib.h>
 #include <signal.h>
@@ -18,9 +16,9 @@
 
 static void io_uring_unmap_rings(struct io_uring_sq *sq, struct io_uring_cq *cq)
 {
-	munmap(sq->ring_ptr, sq->ring_sz);
+	uring_munmap(sq->ring_ptr, sq->ring_sz);
 	if (cq->ring_ptr && cq->ring_ptr != sq->ring_ptr)
-		munmap(cq->ring_ptr, cq->ring_sz);
+		uring_munmap(cq->ring_ptr, cq->ring_sz);
 }
 
 static int io_uring_mmap(int fd, struct io_uring_params *p,
@@ -37,19 +35,21 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 			sq->ring_sz = cq->ring_sz;
 		cq->ring_sz = sq->ring_sz;
 	}
-	sq->ring_ptr = mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
-			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQ_RING);
-	if (sq->ring_ptr == MAP_FAILED)
-		return -errno;
+	sq->ring_ptr = uring_mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
+				  MAP_SHARED | MAP_POPULATE, fd,
+				  IORING_OFF_SQ_RING);
+	if (IS_ERR(sq->ring_ptr))
+		return PTR_ERR(sq->ring_ptr);
 
 	if (p->features & IORING_FEAT_SINGLE_MMAP) {
 		cq->ring_ptr = sq->ring_ptr;
 	} else {
-		cq->ring_ptr = mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
-				MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_CQ_RING);
-		if (cq->ring_ptr == MAP_FAILED) {
+		cq->ring_ptr = uring_mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
+					  MAP_SHARED | MAP_POPULATE, fd,
+					  IORING_OFF_CQ_RING);
+		if (IS_ERR(cq->ring_ptr)) {
+			ret = PTR_ERR(cq->ring_ptr);
 			cq->ring_ptr = NULL;
-			ret = -errno;
 			goto err;
 		}
 	}
@@ -63,11 +63,10 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 	sq->array = sq->ring_ptr + p->sq_off.array;
 
 	size = p->sq_entries * sizeof(struct io_uring_sqe);
-	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
-				MAP_SHARED | MAP_POPULATE, fd,
-				IORING_OFF_SQES);
-	if (sq->sqes == MAP_FAILED) {
-		ret = -errno;
+	sq->sqes = uring_mmap(0, size, PROT_READ | PROT_WRITE,
+			      MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQES);
+	if (IS_ERR(sq->sqes)) {
+		ret = PTR_ERR(sq->sqes);
 err:
 		io_uring_unmap_rings(sq, cq);
 		return ret;
@@ -116,20 +115,20 @@ int io_uring_ring_dontfork(struct io_uring *ring)
 		return -EINVAL;
 
 	len = *ring->sq.kring_entries * sizeof(struct io_uring_sqe);
-	ret = madvise(ring->sq.sqes, len, MADV_DONTFORK);
-	if (ret == -1)
-		return -errno;
+	ret = uring_madvise(ring->sq.sqes, len, MADV_DONTFORK);
+	if (ret < 0)
+		return ret;
 
 	len = ring->sq.ring_sz;
-	ret = madvise(ring->sq.ring_ptr, len, MADV_DONTFORK);
-	if (ret == -1)
-		return -errno;
+	ret = uring_madvise(ring->sq.ring_ptr, len, MADV_DONTFORK);
+	if (ret < 0)
+		return ret;
 
 	if (ring->cq.ring_ptr != ring->sq.ring_ptr) {
 		len = ring->cq.ring_sz;
-		ret = madvise(ring->cq.ring_ptr, len, MADV_DONTFORK);
-		if (ret == -1)
-			return -errno;
+		ret = uring_madvise(ring->cq.ring_ptr, len, MADV_DONTFORK);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
@@ -173,7 +172,7 @@ void io_uring_queue_exit(struct io_uring *ring)
 	struct io_uring_sq *sq = &ring->sq;
 	struct io_uring_cq *cq = &ring->cq;
 
-	munmap(sq->sqes, *sq->kring_entries * sizeof(struct io_uring_sqe));
+	uring_munmap(sq->sqes, *sq->kring_entries * sizeof(struct io_uring_sqe));
 	io_uring_unmap_rings(sq, cq);
 	close(ring->ring_fd);
 }
diff --git a/src/syscall.h b/src/syscall.h
index f7f63aa..a9dd280 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -4,11 +4,15 @@
 
 #include <errno.h>
 #include <signal.h>
+#include <stdint.h>
 #include <unistd.h>
+#include <stdbool.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/resource.h>
 
+#include <liburing.h>
+
 #ifdef __alpha__
 /*
  * alpha and mips are exception, other architectures have
@@ -59,7 +63,20 @@ int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
 int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
 			    unsigned int nr_args);
 
+static inline void *ERR_PTR(intptr_t n)
+{
+	return (void *) n;
+}
 
+static inline intptr_t PTR_ERR(void *ptr)
+{
+	return (intptr_t) ptr;
+}
+
+static inline bool IS_ERR(void *ptr)
+{
+	return uring_unlikely((uintptr_t) ptr >= (uintptr_t) -4095UL);
+}
 
 static inline int ____sys_io_uring_register(int fd, unsigned opcode,
 					    const void *arg, unsigned nr_args)
@@ -98,4 +115,45 @@ static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
 				       _NSIG / 8);
 }
 
+static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
+			       int fd, off_t offset)
+{
+	void *ret;
+
+	ret = mmap(addr, length, prot, flags, fd, offset);
+	return (ret == MAP_FAILED) ? ERR_PTR(-errno) : ret;
+}
+
+static inline int uring_munmap(void *addr, size_t length)
+{
+	int ret;
+
+	ret = munmap(addr, length);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int uring_madvise(void *addr, size_t length, int advice)
+{
+	int ret;
+
+	ret = madvise(addr, length, advice);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int uring_getrlimit(int resource, struct rlimit *rlim)
+{
+	int ret;
+
+	ret = getrlimit(resource, rlim);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
+{
+	int ret;
+
+	ret = setrlimit(resource, rlim);
+	return (ret < 0) ? -errno : ret;
+}
+
 #endif
-- 
2.30.2

