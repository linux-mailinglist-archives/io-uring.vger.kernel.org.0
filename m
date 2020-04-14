Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED11C1A8DDB
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 23:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634002AbgDNVlY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Apr 2020 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2633997AbgDNVlJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Apr 2020 17:41:09 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E83C0610D5;
        Tue, 14 Apr 2020 14:41:07 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so16348907wrv.10;
        Tue, 14 Apr 2020 14:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peFnectV7CQMQTQjPy9Ic5Q5be55eQtV7o6WJhX0Bcg=;
        b=qXOIKNBiIAgJ5yKDsclOkUtoCJF4lZE4/3r1Pv/vg8bAE1UpNuBQQo1TGyiOGu9DM7
         iw4Gcfb/LbOrRlnYntIBbEFZccMt9koLYOzWNZ1ns0HYmjgaPUP9EbzsBcYUyUgKtR0P
         w1Rpak/HdHsMYwLsqykhfP0SQNyqdGyypwV3ogXWhMEIMyqek9tQKq1+FeLLV5HWN4TE
         T4j3YtVSyYVHkOggcz4SnDldKB6Ycjhqw1QEoDyt8jF0KIT/tqET7qGxeP3l5hVOheHq
         U18cNGmZSeAPvjrAwSV8qVraNFrC3wtLxfCxTgep3JrLSlmzCDuLBSMaI5Wr+YUGjgKO
         dJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peFnectV7CQMQTQjPy9Ic5Q5be55eQtV7o6WJhX0Bcg=;
        b=jdc1gBEe6n7Ci/JeVUVB64KfYME4UB0cBnzFA6yAjnBwpwKFWKqpHAzS8O1PLbIY6a
         wtT6yDQji7HTsOl5bbKEaI1aJ2Hyz3utDiTAe8kXgAikOQ6AoL1m0JhmH9DQQ3Bgk9dR
         Hb2aRxHH3TC4EOj+mH7JlN+tzw65oHLvuI/AiAJQD4hjKgD7rCEs7CsBciAyTHikNGKc
         0wGrNyFhRmE+xhLX5ah2GH0PUjhNUZ0QBGKu/t0tnwn9scOs2tHWBCXYZE10bVwyzAP1
         /5JQCukklJES5RwAhnGw/9HgwaZ8smz46iXcr8feJMeV6U75BJ6DWfZ9qR1vxxlohjOf
         +ySQ==
X-Gm-Message-State: AGi0PuZ7dS6xW4ePbD6VnXFNsugEeESKtZgPfNmxgF9FXVs3Co21lUd6
        LcSvuGemOsRJCqmNKHMdu5fr6QjV
X-Google-Smtp-Source: APiQypKotcqnc/emPpapYy4p/ZIzCiPFH15DgpowdaQovbQTf3pehycbQTMB2FKLVqSoKuoztToGWQ==
X-Received: by 2002:a5d:51c6:: with SMTP id n6mr19541810wrv.314.1586900465979;
        Tue, 14 Apr 2020 14:41:05 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id l185sm20320540wml.44.2020.04.14.14.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 14:41:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Hrvoje Zeba <zeba.hrvoje@gmail.com>
Subject: [PATCH 4/4] io_uring: fix timeout's seq catching old requests
Date:   Wed, 15 Apr 2020 00:39:51 +0300
Message-Id: <8ff46482b028a4ca69a41193f0ce951dfccc9da6.1586899625.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586899625.git.asml.silence@gmail.com>
References: <cover.1586899625.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As sequence logic use u32 for both req->sequence and sqe->off,
req->sequence + sqe->off can alias to a previously submtitted and
still inflight request, so triggering a timeout on it instead of waiting
for completion of requests submitted after the timeout.

Use u64 for sequences leaving sqe->off to be u32, so the issue will
happen only when there are more than 2^64 - 2^32 inflight requests, that
just won't fit in memory.

note 1: can't modify __req_need_defer() as well, because it's used
without synchronisation for draining, and reading ctx->cached_cq_tail
in 32bit arch won't be atomic.

note 2: io_timeout() overflow magic is left in u32.

Reported-by: Hrvoje Zeba <zeba.hrvoje@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ee7b4f72b8f..1961562edf77 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -251,6 +251,7 @@ struct io_ring_ctx {
 
 		wait_queue_head_t	inflight_wait;
 		struct io_uring_sqe	*sq_sqes;
+		u64			sq_submitted;
 	} ____cacheline_aligned_in_smp;
 
 	struct io_rings	*rings;
@@ -302,6 +303,7 @@ struct io_ring_ctx {
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
 		struct eventfd_ctx	*cq_ev_fd;
+		u64			cq_total;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -624,7 +626,7 @@ struct io_kiocb {
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
-	u32			sequence;
+	u64			sequence;
 
 	struct list_head	link_list;
 
@@ -957,8 +959,8 @@ static inline bool __req_need_defer(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	return req->sequence != ctx->cached_cq_tail
-				+ atomic_read(&ctx->cached_cq_overflow);
+	return (u32)req->sequence != ctx->cached_cq_tail
+			+ atomic_read(&ctx->cached_cq_overflow);
 }
 
 static inline bool req_need_defer(struct io_kiocb *req)
@@ -990,7 +992,7 @@ static struct io_kiocb *io_get_timeout_req(struct io_ring_ctx *ctx)
 	if (req) {
 		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
 			return NULL;
-		if (!__req_need_defer(req)) {
+		if (req->sequence == ctx->cq_total) {
 			list_del_init(&req->list);
 			return req;
 		}
@@ -1141,6 +1143,7 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 	if (tail - READ_ONCE(rings->cq.head) == rings->cq_ring_entries)
 		return NULL;
 
+	ctx->cq_total++;
 	ctx->cached_cq_tail++;
 	return &rings->cqes[tail & ctx->cq_mask];
 }
@@ -1204,6 +1207,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		} else {
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
+			ctx->cq_total++;
 		}
 	}
 
@@ -1244,6 +1248,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 	} else if (ctx->cq_overflow_flushed) {
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
+		ctx->cq_total++;
 	} else {
 		if (list_empty(&ctx->cq_overflow_list)) {
 			set_bit(0, &ctx->sq_check_overflow);
@@ -4672,7 +4677,7 @@ static int io_timeout(struct io_kiocb *req)
 	struct list_head *entry;
 	unsigned span = 0;
 	u32 count = req->timeout.count;
-	u32 seq = req->sequence;
+	u32 seq = (u32)req->sequence;
 
 	data = &req->io->timeout;
 
@@ -5730,8 +5735,10 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	 *    though the application is the one updating it.
 	 */
 	head = READ_ONCE(sq_array[ctx->cached_sq_head & ctx->sq_mask]);
-	if (likely(head < ctx->sq_entries))
+	if (likely(head < ctx->sq_entries)) {
+		ctx->sq_submitted++;
 		return &ctx->sq_sqes[head];
+	}
 
 	/* drop invalid entries */
 	ctx->cached_sq_dropped++;
@@ -5760,7 +5767,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * it can be used to mark the position of the first IO in the
 	 * link list.
 	 */
-	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
+	req->sequence = ctx->sq_submitted - 1;
 	req->opcode = READ_ONCE(sqe->opcode);
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->io = NULL;
-- 
2.24.0

