Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC484B2980
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 16:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349673AbiBKP6m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 10:58:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344108AbiBKP6k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 10:58:40 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A8B1A8
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 07:58:39 -0800 (PST)
Received: from integral2.. (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 727737E293;
        Fri, 11 Feb 2022 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644595119;
        bh=SHwPPGX2wYzjl9LDsa475V2vp3XbbaRb7l/2F+Fm1p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkKOVvQAEChWMAg1RWNIOKwXk9cp0LfGziV1JY2DHhnh2sn73+1xokJ3AtCUVfFHP
         VpdcnRDoShKe1jR11onIpDhsBnnZIcE5u6a3zVqFJefY8uSDyziSPTnu/2p7Xi+msD
         SyTFcPoFfLxjP+JsuF8LSE4iiBEr4Tp3wb2N1c6p0SVeYHq8Vc2E3AMRTci93P3LFm
         8X8+p4vNaFzKcyNd7WRE6qyYNvkCbWkb+ETe0yJkQHri7DiFWaywQXDdqYKG+K6DDH
         JPq3oc3p9vFadOB17isbbXvGKxa4Xrb0xNwGYypHGp+qYRKaltkHp8hKE1GFgTwNyL
         FwjY3jfGmohDQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Nugra <richiisei@gmail.com>
Subject: [PATCH liburing v1 4/4] Change all syscall function name prefix to __sys
Date:   Fri, 11 Feb 2022 22:57:53 +0700
Message-Id: <20220211155753.143698-5-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
References: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
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

Instead of using uring_mmap, uring_close, uring_madvise, etc. Let's
use __sys_mmap, __sys_close, __sys_madvise, etc. That looks better
convention for syscall function name like what we do with
__sys_io_uring* functions.

Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/generic/syscall.h | 12 ++++++------
 src/arch/x86/syscall.h     | 12 ++++++------
 src/nolibc.c               |  4 ++--
 src/register.c             |  4 ++--
 src/setup.c                | 22 +++++++++++-----------
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/src/arch/generic/syscall.h b/src/arch/generic/syscall.h
index 6b10fe3..fa93064 100644
--- a/src/arch/generic/syscall.h
+++ b/src/arch/generic/syscall.h
@@ -41,7 +41,7 @@ static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
 				       _NSIG / 8);
 }
 
-static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
+static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
 	void *ret;
@@ -49,35 +49,35 @@ static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
 	return (ret == MAP_FAILED) ? ERR_PTR(-errno) : ret;
 }
 
-static inline int uring_munmap(void *addr, size_t length)
+static inline int __sys_munmap(void *addr, size_t length)
 {
 	int ret;
 	ret = munmap(addr, length);
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int uring_madvise(void *addr, size_t length, int advice)
+static inline int __sys_madvise(void *addr, size_t length, int advice)
 {
 	int ret;
 	ret = madvise(addr, length, advice);
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int uring_getrlimit(int resource, struct rlimit *rlim)
+static inline int __sys_getrlimit(int resource, struct rlimit *rlim)
 {
 	int ret;
 	ret = getrlimit(resource, rlim);
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
+static inline int __sys_setrlimit(int resource, const struct rlimit *rlim)
 {
 	int ret;
 	ret = setrlimit(resource, rlim);
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int uring_close(int fd)
+static inline int __sys_close(int fd)
 {
 	int ret;
 	ret = close(fd);
diff --git a/src/arch/x86/syscall.h b/src/arch/x86/syscall.h
index 2d5642c..02677f2 100644
--- a/src/arch/x86/syscall.h
+++ b/src/arch/x86/syscall.h
@@ -29,7 +29,7 @@
  *   %r11 == %rflags and %rcx == %rip.
  */
 
-static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
+static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
 	void *rax;
@@ -52,7 +52,7 @@ static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
 	return rax;
 }
 
-static inline int uring_munmap(void *addr, size_t length)
+static inline int __sys_munmap(void *addr, size_t length)
 {
 	long rax;
 
@@ -67,7 +67,7 @@ static inline int uring_munmap(void *addr, size_t length)
 	return (int) rax;
 }
 
-static inline int uring_madvise(void *addr, size_t length, int advice)
+static inline int __sys_madvise(void *addr, size_t length, int advice)
 {
 	long rax;
 
@@ -83,7 +83,7 @@ static inline int uring_madvise(void *addr, size_t length, int advice)
 	return (int) rax;
 }
 
-static inline int uring_getrlimit(int resource, struct rlimit *rlim)
+static inline int __sys_getrlimit(int resource, struct rlimit *rlim)
 {
 	long rax;
 
@@ -98,7 +98,7 @@ static inline int uring_getrlimit(int resource, struct rlimit *rlim)
 	return (int) rax;
 }
 
-static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
+static inline int __sys_setrlimit(int resource, const struct rlimit *rlim)
 {
 	long rax;
 
@@ -113,7 +113,7 @@ static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
 	return (int) rax;
 }
 
-static inline int uring_close(int fd)
+static inline int __sys_close(int fd)
 {
 	long rax;
 
diff --git a/src/nolibc.c b/src/nolibc.c
index f7848d3..1e17d22 100644
--- a/src/nolibc.c
+++ b/src/nolibc.c
@@ -27,7 +27,7 @@ void *__uring_malloc(size_t len)
 {
 	struct uring_heap *heap;
 
-	heap = uring_mmap(NULL, sizeof(*heap) + len, PROT_READ | PROT_WRITE,
+	heap = __sys_mmap(NULL, sizeof(*heap) + len, PROT_READ | PROT_WRITE,
 			  MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (IS_ERR(heap))
 		return NULL;
@@ -44,5 +44,5 @@ void __uring_free(void *p)
 		return;
 
 	heap = container_of(p, struct uring_heap, user_p);
-	uring_munmap(heap, heap->len);
+	__sys_munmap(heap, heap->len);
 }
diff --git a/src/register.c b/src/register.c
index a1b1a22..cd73fce 100644
--- a/src/register.c
+++ b/src/register.c
@@ -100,13 +100,13 @@ static int increase_rlimit_nofile(unsigned nr)
 	int ret;
 	struct rlimit rlim;
 
-	ret = uring_getrlimit(RLIMIT_NOFILE, &rlim);
+	ret = __sys_getrlimit(RLIMIT_NOFILE, &rlim);
 	if (ret < 0)
 		return ret;
 
 	if (rlim.rlim_cur < nr) {
 		rlim.rlim_cur += nr;
-		uring_setrlimit(RLIMIT_NOFILE, &rlim);
+		__sys_setrlimit(RLIMIT_NOFILE, &rlim);
 	}
 
 	return 0;
diff --git a/src/setup.c b/src/setup.c
index 1e4dbf4..544adaf 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -10,9 +10,9 @@
 
 static void io_uring_unmap_rings(struct io_uring_sq *sq, struct io_uring_cq *cq)
 {
-	uring_munmap(sq->ring_ptr, sq->ring_sz);
+	__sys_munmap(sq->ring_ptr, sq->ring_sz);
 	if (cq->ring_ptr && cq->ring_ptr != sq->ring_ptr)
-		uring_munmap(cq->ring_ptr, cq->ring_sz);
+		__sys_munmap(cq->ring_ptr, cq->ring_sz);
 }
 
 static int io_uring_mmap(int fd, struct io_uring_params *p,
@@ -29,7 +29,7 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 			sq->ring_sz = cq->ring_sz;
 		cq->ring_sz = sq->ring_sz;
 	}
-	sq->ring_ptr = uring_mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
+	sq->ring_ptr = __sys_mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
 				  MAP_SHARED | MAP_POPULATE, fd,
 				  IORING_OFF_SQ_RING);
 	if (IS_ERR(sq->ring_ptr))
@@ -38,7 +38,7 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 	if (p->features & IORING_FEAT_SINGLE_MMAP) {
 		cq->ring_ptr = sq->ring_ptr;
 	} else {
-		cq->ring_ptr = uring_mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
+		cq->ring_ptr = __sys_mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
 					  MAP_SHARED | MAP_POPULATE, fd,
 					  IORING_OFF_CQ_RING);
 		if (IS_ERR(cq->ring_ptr)) {
@@ -57,7 +57,7 @@ static int io_uring_mmap(int fd, struct io_uring_params *p,
 	sq->array = sq->ring_ptr + p->sq_off.array;
 
 	size = p->sq_entries * sizeof(struct io_uring_sqe);
-	sq->sqes = uring_mmap(0, size, PROT_READ | PROT_WRITE,
+	sq->sqes = __sys_mmap(0, size, PROT_READ | PROT_WRITE,
 			      MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQES);
 	if (IS_ERR(sq->sqes)) {
 		ret = PTR_ERR(sq->sqes);
@@ -109,18 +109,18 @@ int io_uring_ring_dontfork(struct io_uring *ring)
 		return -EINVAL;
 
 	len = *ring->sq.kring_entries * sizeof(struct io_uring_sqe);
-	ret = uring_madvise(ring->sq.sqes, len, MADV_DONTFORK);
+	ret = __sys_madvise(ring->sq.sqes, len, MADV_DONTFORK);
 	if (ret < 0)
 		return ret;
 
 	len = ring->sq.ring_sz;
-	ret = uring_madvise(ring->sq.ring_ptr, len, MADV_DONTFORK);
+	ret = __sys_madvise(ring->sq.ring_ptr, len, MADV_DONTFORK);
 	if (ret < 0)
 		return ret;
 
 	if (ring->cq.ring_ptr != ring->sq.ring_ptr) {
 		len = ring->cq.ring_sz;
-		ret = uring_madvise(ring->cq.ring_ptr, len, MADV_DONTFORK);
+		ret = __sys_madvise(ring->cq.ring_ptr, len, MADV_DONTFORK);
 		if (ret < 0)
 			return ret;
 	}
@@ -139,7 +139,7 @@ int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 
 	ret = io_uring_queue_mmap(fd, p, ring);
 	if (ret) {
-		uring_close(fd);
+		__sys_close(fd);
 		return ret;
 	}
 
@@ -166,9 +166,9 @@ void io_uring_queue_exit(struct io_uring *ring)
 	struct io_uring_sq *sq = &ring->sq;
 	struct io_uring_cq *cq = &ring->cq;
 
-	uring_munmap(sq->sqes, *sq->kring_entries * sizeof(struct io_uring_sqe));
+	__sys_munmap(sq->sqes, *sq->kring_entries * sizeof(struct io_uring_sqe));
 	io_uring_unmap_rings(sq, cq);
-	uring_close(ring->ring_fd);
+	__sys_close(ring->ring_fd);
 }
 
 struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
-- 
2.32.0

