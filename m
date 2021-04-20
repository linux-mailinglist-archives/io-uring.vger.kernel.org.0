Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F9D3661D6
	for <lists+io-uring@lfdr.de>; Wed, 21 Apr 2021 00:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhDTWB5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 18:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbhDTWB4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 18:01:56 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB516C06174A
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 15:01:24 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id a4so39266280wrr.2
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 15:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AfFpROTOFi9W5NxOfPVJscGivhNPt7PXV2fqqAQAMv0=;
        b=GSipU9TLahdpPJmRqr9IbeUuT9n84gw3rhBfmN18awm47jxM+Eiow3WxoIqidUstZx
         q+NFGOurrPkNATbDEL60fmcSmz9z+Te5KYVzY3+NIHAKebAmRSZsN9O0Yy72DgztwJ/Y
         T6+eKK/pbI+7zDIJShMdpABgmqvox4Nm37r03j3FtAvj/K6Kwp8T6yoKdbmzxpJXRhC0
         +psZuS7tp84h2715VsUw9q/HWhVvT3/sMBIgpAO535DA2hyIGnSWc8dfKZ2VuDEPkL6p
         IcxhAs9bmRc68BymRrzRSViYHoUkWeKDHCpFZQRXUGhIisYD/lzSF0TI6v03/FzFWvYq
         zkIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AfFpROTOFi9W5NxOfPVJscGivhNPt7PXV2fqqAQAMv0=;
        b=btXTiGWuZoO+kkCzNGXH7qL8czPDExKNpfbSX51P+lAH9oDoUDNNWkYGOknj+RpshH
         ktQIPoqXhsBn5ZCtigVqfq8WIfPCZ12+PreeoTkaJN9LPbLDVilTKkHjX5uqpyAoVtFq
         9HmdlDYwg3WE2URJ/Di8+Wd4Hw6CxGAWx9MGvssktW3ARdme0X5EGPO1g43+xbgbdVrI
         +UPfX8rG9OmiM3vhZmSvw8a/HTyeXQWCP3GiqYhlSuZyb8e73QNqr3CuO28AdNkag0V+
         Y31b3eX07JaGPCZC/Mmj4H+UrodqN8RThedSYJbZ4uI98ZhHYnU8IAB/uhA68vwiWP7K
         AZIQ==
X-Gm-Message-State: AOAM532hkbpTQ1wMj0T64rxIdd0/DyenTS0+odiavBYuTXZpdIyt/gT8
        IKi+WLfsdX5dD7dX8S7ARnrTPcQlcDZJ1Q==
X-Google-Smtp-Source: ABdhPJyL9h/WszbUNpLLnKeqS9HAUStCAA+Uc3aPboj2EzpTkBbH7lJHorl07z9hfSP3w88JxQmKeQ==
X-Received: by 2002:a5d:5041:: with SMTP id h1mr23287259wrt.100.1618956083437;
        Tue, 20 Apr 2021 15:01:23 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.116])
        by smtp.gmail.com with ESMTPSA id c16sm330983wrm.93.2021.04.20.15.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 15:01:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: remove -EBUSY on CQE backlog tests
Date:   Tue, 20 Apr 2021 23:01:15 +0100
Message-Id: <602ed592631aaa6605d414b12419ca2f1896a810.1618956047.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From 5.13 the kernel doesn't limit users submission with CQE backlog,
that was previously failed with -EBUSY. Remove related tests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile           |   2 -
 test/cq-overflow-peek.c |  88 -----------------
 test/cq-overflow.c      | 204 ----------------------------------------
 3 files changed, 294 deletions(-)
 delete mode 100644 test/cq-overflow-peek.c

diff --git a/test/Makefile b/test/Makefile
index 210571c..4572564 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -34,7 +34,6 @@ test_targets += \
 	connect \
 	cq-full \
 	cq-overflow \
-	cq-overflow-peek \
 	cq-peek-batch \
 	cq-ready \
 	cq-size \
@@ -169,7 +168,6 @@ test_srcs := \
 	close-opath.c \
 	connect.c \
 	cq-full.c \
-	cq-overflow-peek.c \
 	cq-overflow.c \
 	cq-peek-batch.c \
 	cq-ready.c\
diff --git a/test/cq-overflow-peek.c b/test/cq-overflow-peek.c
deleted file mode 100644
index 353c6f3..0000000
--- a/test/cq-overflow-peek.c
+++ /dev/null
@@ -1,88 +0,0 @@
-/*
- * Check if the kernel sets IORING_SQ_CQ_OVERFLOW so that peeking events
- * still enter the kernel to flush events, if the CQ side is overflown.
- */
-#include <stdio.h>
-#include <string.h>
-#include <assert.h>
-#include "liburing.h"
-
-static int test_cq_overflow(struct io_uring *ring)
-{
-	struct io_uring_cqe *cqe;
-	struct io_uring_sqe *sqe;
-	unsigned flags;
-	int issued = 0;
-	int ret = 0;
-
-	do {
-		sqe = io_uring_get_sqe(ring);
-		if (!sqe) {
-			fprintf(stderr, "get sqe failed\n");
-			goto err;
-		}
-		ret = io_uring_submit(ring);
-		if (ret <= 0) {
-			if (ret != -EBUSY)
-				fprintf(stderr, "sqe submit failed: %d\n", ret);
-			break;
-		}
-		issued++;
-	} while (ret > 0);
-
-	assert(ret == -EBUSY);
-
-	flags = IO_URING_READ_ONCE(*ring->sq.kflags);
-	if (!(flags & IORING_SQ_CQ_OVERFLOW)) {
-		fprintf(stdout, "OVERFLOW not set on -EBUSY, skipping\n");
-		goto done;
-	}
-
-	while (issued) {
-		ret = io_uring_peek_cqe(ring, &cqe);
-		if (ret) {
-			if (ret != -EAGAIN) {
-				fprintf(stderr, "peek completion failed: %s\n",
-					strerror(ret));
-				break;
-			}
-			continue;
-		}
-		io_uring_cqe_seen(ring, cqe);
-		issued--;
-	}
-
-done:
-	return 0;
-err:
-	return 1;
-}
-
-int main(int argc, char *argv[])
-{
-	int ret;
-	struct io_uring ring;
-	struct io_uring_params p = { };
-
-	if (argc > 1)
-		return 0;
-
-	ret = io_uring_queue_init_params(16, &ring, &p);
-	if (ret) {
-		fprintf(stderr, "ring setup failed: %d\n", ret);
-		return 1;
-	}
-
-	if (!(p.features & IORING_FEAT_NODROP)) {
-		fprintf(stdout, "No overflow protection, skipped\n");
-		return 0;
-	}
-
-	ret = test_cq_overflow(&ring);
-	if (ret) {
-		fprintf(stderr, "test_cq_overflow failed\n");
-		return 1;
-	}
-
-	return 0;
-}
diff --git a/test/cq-overflow.c b/test/cq-overflow.c
index 274a815..945dc93 100644
--- a/test/cq-overflow.c
+++ b/test/cq-overflow.c
@@ -177,98 +177,6 @@ static int reap_events(struct io_uring *ring, unsigned nr_events, int do_wait)
 	return i ? i : ret;
 }
 
-/*
- * Setup ring with CQ_NODROP and check we get -EBUSY on trying to submit new IO
- * on an overflown ring, and that we get all the events (even overflows) when
- * we finally reap them.
- */
-static int test_overflow_nodrop(void)
-{
-	struct __kernel_timespec ts;
-	struct io_uring_sqe *sqe;
-	struct io_uring_params p;
-	struct io_uring ring;
-	unsigned pending;
-	int ret, i, j;
-
-	memset(&p, 0, sizeof(p));
-	ret = io_uring_queue_init_params(4, &ring, &p);
-	if (ret) {
-		fprintf(stderr, "io_uring_queue_init failed %d\n", ret);
-		return 1;
-	}
-	if (!(p.features & IORING_FEAT_NODROP)) {
-		fprintf(stdout, "FEAT_NODROP not supported, skipped\n");
-		return 0;
-	}
-
-	ts.tv_sec = 0;
-	ts.tv_nsec = 10000000;
-
-	/* submit 4x4 SQEs, should overflow the ring by 8 */
-	pending = 0;
-	for (i = 0; i < 4; i++) {
-		for (j = 0; j < 4; j++) {
-			sqe = io_uring_get_sqe(&ring);
-			if (!sqe) {
-				fprintf(stderr, "get sqe failed\n");
-				goto err;
-			}
-
-			io_uring_prep_timeout(sqe, &ts, -1U, 0);
-			sqe->user_data = (i * 4) + j;
-		}
-
-		ret = io_uring_submit(&ring);
-		if (ret <= 0) {
-			if (ret == -EBUSY)
-				break;
-			fprintf(stderr, "sqe submit failed: %d, %d\n", ret, pending);
-			goto err;
-		}
-		pending += ret;
-	}
-
-	/* wait for timers to fire */
-	usleep(2 * 10000);
-
-	/*
-	 * We should have 16 pending CQEs now, 8 of them in the overflow list. Any
-	 * attempt to queue more IO should return -EBUSY
-	 */
-	sqe = io_uring_get_sqe(&ring);
-	if (!sqe) {
-		fprintf(stderr, "get sqe failed\n");
-		goto err;
-	}
-
-	io_uring_prep_nop(sqe);
-	ret = io_uring_submit(&ring);
-	if (ret != -EBUSY) {
-		fprintf(stderr, "expected sqe submit busy: %d\n", ret);
-		goto err;
-	}
-
-	/* reap the events we should have available */
-	ret = reap_events(&ring, pending, 1);
-	if (ret < 0) {
-		fprintf(stderr, "ret=%d\n", ret);
-		goto err;
-	}
-
-	if (*ring.cq.koverflow) {
-		fprintf(stderr, "cq ring overflow %d, expected 0\n",
-				*ring.cq.koverflow);
-		goto err;
-	}
-
-	io_uring_queue_exit(&ring);
-	return 0;
-err:
-	io_uring_queue_exit(&ring);
-	return 1;
-}
-
 /*
  * Submit some NOPs and watch if the overflow is correct
  */
@@ -333,106 +241,6 @@ err:
 	return 1;
 }
 
-/*
- * Test attempted submit with overflown cq ring that can't get flushed
- */
-static int test_overflow_nodrop_submit_ebusy(void)
-{
-	struct __kernel_timespec ts;
-	struct io_uring_sqe *sqe;
-	struct io_uring_params p;
-	struct io_uring ring;
-	unsigned pending;
-	int ret, i, j;
-
-	memset(&p, 0, sizeof(p));
-	ret = io_uring_queue_init_params(4, &ring, &p);
-	if (ret) {
-		fprintf(stderr, "io_uring_queue_init failed %d\n", ret);
-		return 1;
-	}
-	if (!(p.features & IORING_FEAT_NODROP)) {
-		fprintf(stdout, "FEAT_NODROP not supported, skipped\n");
-		return 0;
-	}
-
-	ts.tv_sec = 1;
-	ts.tv_nsec = 0;
-
-	/* submit 4x4 SQEs, should overflow the ring by 8 */
-	pending = 0;
-	for (i = 0; i < 4; i++) {
-		for (j = 0; j < 4; j++) {
-			sqe = io_uring_get_sqe(&ring);
-			if (!sqe) {
-				fprintf(stderr, "get sqe failed\n");
-				goto err;
-			}
-
-			io_uring_prep_timeout(sqe, &ts, -1U, 0);
-			sqe->user_data = (i * 4) + j;
-		}
-
-		ret = io_uring_submit(&ring);
-		if (ret <= 0) {
-			fprintf(stderr, "sqe submit failed: %d, %d\n", ret, pending);
-			goto err;
-		}
-		pending += ret;
-	}
-
-	/* wait for timers to fire */
-	usleep(1100000);
-
-	/*
-	 * We should have 16 pending CQEs now, 8 of them in the overflow list. Any
-	 * attempt to queue more IO should return -EBUSY
-	 */
-	sqe = io_uring_get_sqe(&ring);
-	if (!sqe) {
-		fprintf(stderr, "get sqe failed\n");
-		goto err;
-	}
-
-	io_uring_prep_nop(sqe);
-	ret = io_uring_submit(&ring);
-	if (ret != -EBUSY) {
-		fprintf(stderr, "expected sqe submit busy: %d\n", ret);
-		goto err;
-	}
-
-	/*
-	 * Now peek existing events so the CQ ring is empty, apart from the
-	 * backlog
-	 */
-	ret = reap_events(&ring, pending, 0);
-	if (ret < 0) {
-		fprintf(stderr, "ret=%d\n", ret);
-		goto err;
-	} else if (ret < 8) {
-		fprintf(stderr, "only found %d events, expected 8\n", ret);
-		goto err;
-	}
-
-	/*
-	 * We should now be able to submit our previous nop that's still
-	 * in the sq ring, as the kernel can flush the existing backlog
-	 * to the now empty CQ ring.
-	 */
-	ret = io_uring_submit(&ring);
-	if (ret != 1) {
-		fprintf(stderr, "submit got %d, expected 1\n", ret);
-		goto err;
-	}
-
-	io_uring_queue_exit(&ring);
-	return 0;
-err:
-	io_uring_queue_exit(&ring);
-	return 1;
-}
-
-
 int main(int argc, char *argv[])
 {
 	unsigned iters, drops;
@@ -448,18 +256,6 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	ret = test_overflow_nodrop();
-	if (ret) {
-		printf("test_overflow_nodrop failed\n");
-		return ret;
-	}
-
-	ret = test_overflow_nodrop_submit_ebusy();
-	if (ret) {
-		fprintf(stderr, "test_overflow_npdrop_submit_ebusy failed\n");
-		return ret;
-	}
-
 	t_create_file(".basic-rw", FILE_SIZE);
 
 	vecs = t_create_buffers(BUFFERS, BS);
-- 
2.31.1

