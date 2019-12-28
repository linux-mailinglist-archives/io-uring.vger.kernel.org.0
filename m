Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D15312BEAB
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfL1TVY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:24 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37326 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfL1TVY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:24 -0500
Received: by mail-pl1-f193.google.com with SMTP id c23so13066065plz.4
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eKfuu+pGpkCm+cpmDM8cuVjkBXMq3O/5Fp03EOWKos8=;
        b=BGY7jL7DnHIztTYZ8HeP4lQUJPKZt+hhPuNEnzwZrbzIKe8reTqW1NTbL/Rc5kN+5r
         ozaoG2WlAnBe7vMixYoiZ/8IM4Uo7xcrk3PetijN1N5aaaklTF+nw6U9VAM511S3Tejl
         gWeJdWe8tsKm3ev28H6W0N0qsBtPXjaSWq8F+Y8Koi9amZQhbpIBeSaFw0wcp26W05VB
         VppSI/9L12j9Ng4WRfc18kifnHcV+RTXjMmaoYdAcgcNhKga2bBymtIb4MmzhuYix+8/
         3GFGp+gXc3NVYvWtp9rK1bNrN33SXxWkH7kNvu/wUbCwGmGeZHn31knaNE27FWnrE1+5
         rsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eKfuu+pGpkCm+cpmDM8cuVjkBXMq3O/5Fp03EOWKos8=;
        b=JE2Xr/wvnjDUfpX6g1csaqC6arSZI8Snqyr82cA1M9OEnQmCCy/nhKCQCGbDBCcoAo
         eTs+PXaUO5vpXCRCMUiJtr79Gf+YBc2Yc6uMG5BqszDABMvnHkZZrX3Xg6FrH8Lsf5Mo
         Z6p/0lckBibISsBC5C9XL+HTEDuVjSp1KuvDQZ//C9OBvJfqvu+DgjrA/hIoCWBvZiA/
         x0tawtty3sFLqoWiLXgErYfjkf3kelmkCvDVLM7ufZc0xk/+0j3DaqX+RED4s4PXJIfw
         UzI47gwSxU8Owgq665E0ZT+dv0DIQmWHKtpqL6TZZbhJi3DtB1knSvRT02YqCq8ijRoH
         +3Kw==
X-Gm-Message-State: APjAAAUlWLf6Sj0VNgBvVuMgeDDwU1NIOqCaPX81hbHo/QmjBrBOQwns
        egpjsTpB8nXZj76aWuVRLrkFEOH0wAVEUQ==
X-Google-Smtp-Source: APXvYqx3JNYdlZ3S1DbPRzJy93lkngp/siesm2vMBAlBe27NxVXuvDzanPFu/E6VlujMZ167zrH9VQ==
X-Received: by 2002:a17:90a:c697:: with SMTP id n23mr33471952pjt.37.1577560883572;
        Sat, 28 Dec 2019 11:21:23 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/9] io_uring: split overflow state into SQ and CQ side
Date:   Sat, 28 Dec 2019 12:21:12 -0700
Message-Id: <20191228192118.4005-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently check ->cq_overflow_list from both SQ and CQ context, which
causes some bouncing of that cache line. Add separate bits of state for
this instead, so that the SQ side can check using its own state, and
likewise for the CQ side.

This adds ->sq_check_overflow with the SQ state, and ->cq_check_overflow
with the CQ state. If we hit an overflow condition, both of these bits
are set. Likewise for overflow flush clear, we clear both bits. For the
fast path of just checking if there's an overflow condition on either
the SQ or CQ side, we can use our own private bit for this.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0ee6b3057895..6f99a52c350c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -224,13 +224,14 @@ struct io_ring_ctx {
 		unsigned		sq_thread_idle;
 		unsigned		cached_sq_dropped;
 		atomic_t		cached_cq_overflow;
-		struct io_uring_sqe	*sq_sqes;
+		unsigned long		sq_check_overflow;
 
 		struct list_head	defer_list;
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
 
 		wait_queue_head_t	inflight_wait;
+		struct io_uring_sqe	*sq_sqes;
 	} ____cacheline_aligned_in_smp;
 
 	struct io_rings	*rings;
@@ -272,6 +273,7 @@ struct io_ring_ctx {
 		unsigned		cq_entries;
 		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
+		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
 		struct eventfd_ctx	*cq_ev_fd;
@@ -952,6 +954,10 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	}
 
 	io_commit_cqring(ctx);
+	if (cqe) {
+		clear_bit(0, &ctx->sq_check_overflow);
+		clear_bit(0, &ctx->cq_check_overflow);
+	}
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
 
@@ -985,6 +991,10 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
 	} else {
+		if (list_empty(&ctx->cq_overflow_list)) {
+			set_bit(0, &ctx->sq_check_overflow);
+			set_bit(0, &ctx->cq_check_overflow);
+		}
 		refcount_inc(&req->refs);
 		req->result = res;
 		list_add_tail(&req->list, &ctx->cq_overflow_list);
@@ -1287,19 +1297,21 @@ static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
 {
 	struct io_rings *rings = ctx->rings;
 
-	/*
-	 * noflush == true is from the waitqueue handler, just ensure we wake
-	 * up the task, and the next invocation will flush the entries. We
-	 * cannot safely to it from here.
-	 */
-	if (noflush && !list_empty(&ctx->cq_overflow_list))
-		return -1U;
+	if (test_bit(0, &ctx->cq_check_overflow)) {
+		/*
+		 * noflush == true is from the waitqueue handler, just ensure
+		 * we wake up the task, and the next invocation will flush the
+		 * entries. We cannot safely to it from here.
+		 */
+		if (noflush && !list_empty(&ctx->cq_overflow_list))
+			return -1U;
 
-	io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx, false);
+	}
 
 	/* See comment at the top of this file */
 	smp_rmb();
-	return READ_ONCE(rings->cq.tail) - READ_ONCE(rings->cq.head);
+	return ctx->cached_cq_tail - READ_ONCE(rings->cq.head);
 }
 
 static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
@@ -4319,9 +4331,11 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	bool mm_fault = false;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
-	if (!list_empty(&ctx->cq_overflow_list) &&
-	    !io_cqring_overflow_flush(ctx, false))
-		return -EBUSY;
+	if (test_bit(0, &ctx->sq_check_overflow)) {
+		if (!list_empty(&ctx->cq_overflow_list) &&
+		    !io_cqring_overflow_flush(ctx, false))
+			return -EBUSY;
+	}
 
 	if (nr > IO_PLUG_THRESHOLD) {
 		io_submit_state_start(&state, nr);
-- 
2.24.1

