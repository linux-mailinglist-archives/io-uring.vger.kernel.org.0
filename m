Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715311C067D
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2020 21:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgD3Tcb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Apr 2020 15:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgD3Tca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Apr 2020 15:32:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CC6C035494;
        Thu, 30 Apr 2020 12:32:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u127so3459283wmg.1;
        Thu, 30 Apr 2020 12:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0z3bz8GHGPa78UwshxZhNUFF/6aFNBbBGeFVwVNQDYY=;
        b=ppGdVqJBXbLSpIrQCY1ozvroDp4TLSqgyQS2NNqnXYHJhb9g4jfrHBqFNAC/XOvRND
         i3kt0M5496nR+kVLiPtrUk3rl+XBQQtbr8jnGb84DS2o4Lg7rxwBgV+GJGHpR9WW5WfA
         dJ6SSns3+SeH2vRW5E5Md6GHM9uQrD9t7VBJF8TqpFR0NKukcGVyTq9RRltyGodKMgMy
         LK1C84brXRB5uJvMzQ/Izr1GsXq1eeCLZtGpqBoamd+GAF/Al84FMfYBbNXParRx+zIc
         RNPUaVWr7p3n8d4q7Uo9OAsoWycIs4PE6N9k4TeWrx0hIWXPqbaaMc5mxfSmh6UlSf27
         FdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0z3bz8GHGPa78UwshxZhNUFF/6aFNBbBGeFVwVNQDYY=;
        b=EqOzkeElmJ2KoKLERURXugGI4UlQHLjtECC0SrBFrXy/j3CokXw4XSTBfsovgomZgL
         bkqnjI0ZE9F8YwDzUOzn2LMJjuUbkgcConH8L5oGWY/Cndid3WZUsm1dTu/dK9HUgpnZ
         fC8OgnOkZNhjDUlyHC55+ONK/8dqbBI7g4aNLVn0T+fj2ztwaL0+Nz2LtwX+xxQj6Ayw
         yofHx+LA7EdOxTHuRQcdnu4q1MSyk4dardvP+m6ZLodm6PySRnqCr02IeifHLdALUlvS
         Dd5+Cpl0djJBtfeg2Xjz+ePzE8o+As8cfYENWAKi0TxjalfgJyF4dCNXj7ClzU0LmXVG
         8m6w==
X-Gm-Message-State: AGi0PuZp3a87D9qd1di45eb+G7/lC11toPTflTZQgz0VmtlO7fryKTUa
        mOb5w2Lluv4vFS7ZEbxefozj1LED
X-Google-Smtp-Source: APiQypK1EufViVhFCNKpk8QsjwkuUSJw9M6vbScfidJsn1IbQ+H9ejtcjMcaMLUmlUYDt8UVWRrDDA==
X-Received: by 2002:a05:600c:2c47:: with SMTP id r7mr181396wmg.50.1588275148619;
        Thu, 30 Apr 2020 12:32:28 -0700 (PDT)
Received: from localhost.localdomain ([109.126.131.64])
        by smtp.gmail.com with ESMTPSA id h188sm917002wme.8.2020.04.30.12.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 12:32:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] io_uring: fix timeout offset with batch CQ commit
Date:   Thu, 30 Apr 2020 22:31:10 +0300
Message-Id: <c0c123dffee3ddf01d120d311cd21fc0271d52d6.1588253029.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588253029.git.asml.silence@gmail.com>
References: <cover.1588253029.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Completions may be done in batches, where io_commit_cqring() is called
only once at the end. It means, that timeout sequence checks are done
only once and don't consider events in between, so potentially failing
to trigger some timeouts.

Do a separate CQ sequence accounting in u64. On timeout sequence
checking look up to UINT_MAX sequence behind, which it could have
missed. It's safe to do, because sqe->off is u32 and so can't wrap
around to used [seq - UINT_MAX, seq] window.

It's also necessary to decouple CQ timeout sequences from
ctx->cq_cached_tail for implementing "single CQE per link" feature and
others.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb8ec4b00375..f09c1d3a7e63 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -298,6 +298,7 @@ struct io_ring_ctx {
 		unsigned		cq_entries;
 		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
+		u64			cq_seq;
 		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
@@ -385,7 +386,7 @@ struct io_timeout {
 	u64				addr;
 	int				flags;
 	u32				off;
-	u32				target_seq;
+	u64				target_seq;
 };
 
 struct io_rw {
@@ -1081,6 +1082,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
 	if (ret != -1) {
 		atomic_inc(&req->ctx->cq_timeouts);
+		req->ctx->cq_seq--;
 		list_del_init(&req->list);
 		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
@@ -1098,16 +1100,31 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
+static inline bool io_check_in_range(u64 pos, u64 start, u64 end)
+{
+	/* if @end < @start, check for [end, MAX_U64] + [MAX_U64, start] */
+	return (pos - start) <= (end - start);
+}
+
 static void __io_flush_timeouts(struct io_ring_ctx *ctx)
 {
+	u64 start_seq = ctx->cq_seq;
+
+
+	/*
+	 * Batched CQ commit may have left some pending timeouts sequences
+	 * behind @cq_sqe. Look back to find them. Note, that sqe->off is u32,
+	 * and it uses u64 to not falsely trigger timeouts with large off.
+	 */
+	start_seq -= UINT_MAX;
 	do {
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 							struct io_kiocb, list);
 
 		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
 			break;
-		if (req->timeout.target_seq != ctx->cached_cq_tail
-					- atomic_read(&ctx->cq_timeouts))
+		if (!io_check_in_range(req->timeout.target_seq, start_seq,
+					ctx->cq_seq))
 			break;
 
 		list_del_init(&req->list);
@@ -1143,6 +1160,7 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ctx->cached_cq_tail++;
+	ctx->cq_seq++;
 	return &rings->cqes[tail & ctx->cq_mask];
 }
 
@@ -4537,6 +4555,8 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	atomic_inc(&ctx->cq_timeouts);
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	ctx->cq_seq--;
+
 	/*
 	 * We could be racing with timeout deletion. If the list is empty,
 	 * then timeout lookup already found it and will be handling it.
@@ -4660,7 +4680,7 @@ static int io_timeout(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data = &req->io->timeout;
 	struct list_head *entry;
-	u32 tail, off = req->timeout.off;
+	u32 off = req->timeout.off;
 
 	spin_lock_irq(&ctx->completion_lock);
 
@@ -4675,8 +4695,7 @@ static int io_timeout(struct io_kiocb *req)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
-	req->timeout.target_seq = tail + off;
+	req->timeout.target_seq = ctx->cq_seq + off;
 
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
@@ -4684,7 +4703,7 @@ static int io_timeout(struct io_kiocb *req)
 	 */
 	list_for_each_prev(entry, &ctx->timeout_list) {
 		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
-		u32 nxt_off = nxt->timeout.target_seq - tail;
+		u32 nxt_off = (u32)(nxt->timeout.target_seq - ctx->cq_seq);
 
 		if (!(nxt->flags & REQ_F_TIMEOUT_NOSEQ) && (off >= nxt_off))
 			break;
-- 
2.24.0

