Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739951AF2C8
	for <lists+io-uring@lfdr.de>; Sat, 18 Apr 2020 19:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgDRRV0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Apr 2020 13:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgDRRVZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Apr 2020 13:21:25 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D380C061A0C;
        Sat, 18 Apr 2020 10:21:25 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u127so5277101wmg.1;
        Sat, 18 Apr 2020 10:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2qln2BrWKe8omgaN13hNRjkAUAOmpf7mNlE4/eWuU6Y=;
        b=DhqbnYVAUZUKc9v2CE7vfq//B4GKa6Qupn5d0rus0xYHK/7OTJ7WDcov9aB+Ipebo3
         ydRuBM/Jap5fqsrH/ezbZ9oUnB7dSrMIeCTuBlCVTIs1rSRU0k70tsdZUDAQgPSpaiq1
         l2ZPUVpNvXqGZdn/4wGNgRuhLMvXepSrdgFgxm7KHL8FdiWLm3v5+ZZm+lyW6Cb2k60I
         bBfER8nt2YMQt5/67Q8zKw2KBuao53lPysHjwB2Q4/DYuD/6U0AOg3nrG4Wyt/N0j8PZ
         0e/deWIQT1L7M+Tot4IVsnUeVH6oEBvdP+TWtgwlL1H6vaZZb0TFvy4IKh1ckcIR8FO9
         hdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qln2BrWKe8omgaN13hNRjkAUAOmpf7mNlE4/eWuU6Y=;
        b=aQwbMuJ4rnDna6UmUhis1bO/18RHKVhMygVIKi6blmabwvt3JDBg4f6eiHWKTFD3Ug
         38JR9DBtaBK65GE6KynO/SFF3GUF7rvxdLcWWFoOmilDXn7U/jbr8PJ8XgYWAkD7rb75
         /akuFQark+o/Gfdr03ROpc24odlyLBJI6D/q0+nddCGHipmh3r45cAEzqBSxsan17GdU
         qsNyQFaq8xaMkMmzlbDoA4NSEK/jZjh4CHhRsiQpYb7pC12xADHQD3dfhdPRdu4ah5Gv
         OQST5CnHjCnLAOwE2W1VBcOaMEKF5H/E7sp5FgY5a6wyrYBcx1FHsWU7z3xWnRVidyFp
         lLmQ==
X-Gm-Message-State: AGi0PuYwPqeYiA+oOrgaKHyRlg0AmDfzSeC/GlA1cyt1/hB5r72+k/Dm
        JY0mB5s9+pJjqCx9gcEkZ6U=
X-Google-Smtp-Source: APiQypLzJcnSVlfLgNK8ib4jKI7WBrE2VctjUK7WSiAhl4oDee5Y/ENoqJp7vADh3LMmuL0KelDONQ==
X-Received: by 2002:a1c:2e07:: with SMTP id u7mr8918307wmu.74.1587230483728;
        Sat, 18 Apr 2020 10:21:23 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id b85sm12538247wmb.21.2020.04.18.10.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 10:21:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring: trigger timeout after any sqe->off CQEs
Date:   Sat, 18 Apr 2020 20:20:10 +0300
Message-Id: <28005ea0de63e15dbffd87a49fe9b671f1afa87e.1587229607.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1587229607.git.asml.silence@gmail.com>
References: <cover.1587229607.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sequence mode timeouts wait not for sqe->off CQEs, but rather
sqe->off + number of prior inflight requests with a quirk ignoring other
timeouts completions. Wait exactly for sqe->off using completion count
(tail) for accounting.

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 120 +++++++++++++++++++-------------------------------
 1 file changed, 46 insertions(+), 74 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ee7b4f72b8f..c34c5dcc90fc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -384,7 +384,8 @@ struct io_timeout {
 	struct file			*file;
 	u64				addr;
 	int				flags;
-	u32				count;
+	u32				off;
+	u32				target_cq;
 };
 
 struct io_rw {
@@ -982,23 +983,6 @@ static struct io_kiocb *io_get_deferred_req(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-static struct io_kiocb *io_get_timeout_req(struct io_ring_ctx *ctx)
-{
-	struct io_kiocb *req;
-
-	req = list_first_entry_or_null(&ctx->timeout_list, struct io_kiocb, list);
-	if (req) {
-		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
-			return NULL;
-		if (!__req_need_defer(req)) {
-			list_del_init(&req->list);
-			return req;
-		}
-	}
-
-	return NULL;
-}
-
 static void __io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
@@ -1114,12 +1098,42 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
+static inline bool io_check_in_range(u32 pos, u32 start, u32 end)
+{
+	/* if @end < @start, check for [end, MAX_UINT] + [MAX_UINT, start] */
+	return (pos - start) <= (end - start);
+}
+
+static void __io_flush_timeouts(struct io_ring_ctx *ctx)
+{
+	u32 end, start;
+
+	start = end = ctx->cached_cq_tail;
+	do {
+		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
+							struct io_kiocb, list);
+
+		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
+			break;
+		/*
+		 * multiple timeouts may have the same target,
+		 * check that @req is in [first_tail, cur_tail]
+		 */
+		if (!io_check_in_range(req->timeout.target_cq, start, end))
+			break;
+
+		list_del_init(&req->list);
+		io_kill_timeout(req);
+		end = ctx->cached_cq_tail;
+	} while (!list_empty(&ctx->timeout_list));
+}
+
 static void io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_kiocb *req;
 
-	while ((req = io_get_timeout_req(ctx)) != NULL)
-		io_kill_timeout(req);
+	if (!list_empty(&ctx->timeout_list))
+		__io_flush_timeouts(ctx);
 
 	__io_commit_cqring(ctx);
 
@@ -4540,20 +4554,8 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	 * We could be racing with timeout deletion. If the list is empty,
 	 * then timeout lookup already found it and will be handling it.
 	 */
-	if (!list_empty(&req->list)) {
-		struct io_kiocb *prev;
-
-		/*
-		 * Adjust the reqs sequence before the current one because it
-		 * will consume a slot in the cq_ring and the cq_tail
-		 * pointer will be increased, otherwise other timeout reqs may
-		 * return in advance without waiting for enough wait_nr.
-		 */
-		prev = req;
-		list_for_each_entry_continue_reverse(prev, &ctx->timeout_list, list)
-			prev->sequence++;
+	if (!list_empty(&req->list))
 		list_del_init(&req->list);
-	}
 
 	io_cqring_fill_event(req, -ETIME);
 	io_commit_cqring(ctx);
@@ -4633,18 +4635,19 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 {
 	struct io_timeout_data *data;
 	unsigned flags;
+	u32 off = READ_ONCE(sqe->off);
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
 		return -EINVAL;
-	if (sqe->off && is_timeout_link)
+	if (off && is_timeout_link)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->timeout_flags);
 	if (flags & ~IORING_TIMEOUT_ABS)
 		return -EINVAL;
 
-	req->timeout.count = READ_ONCE(sqe->off);
+	req->timeout.off = off;
 
 	if (!req->io && io_alloc_async_ctx(req))
 		return -ENOMEM;
@@ -4668,68 +4671,37 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 static int io_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_timeout_data *data;
+	struct io_timeout_data *data = &req->io->timeout;
 	struct list_head *entry;
-	unsigned span = 0;
-	u32 count = req->timeout.count;
-	u32 seq = req->sequence;
+	u32 tail, off = req->timeout.off;
 
-	data = &req->io->timeout;
+	spin_lock_irq(&ctx->completion_lock);
 
 	/*
 	 * sqe->off holds how many events that need to occur for this
 	 * timeout event to be satisfied. If it isn't set, then this is
 	 * a pure timeout request, sequence isn't used.
 	 */
-	if (!count) {
+	if (!off) {
 		req->flags |= REQ_F_TIMEOUT_NOSEQ;
-		spin_lock_irq(&ctx->completion_lock);
 		entry = ctx->timeout_list.prev;
 		goto add;
 	}
 
-	req->sequence = seq + count;
+	tail = ctx->cached_cq_tail;
+	req->timeout.target_cq = tail + off;
 
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
 	 */
-	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_prev(entry, &ctx->timeout_list) {
 		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
-		unsigned nxt_seq;
-		long long tmp, tmp_nxt;
-		u32 nxt_offset = nxt->timeout.count;
-
-		if (nxt->flags & REQ_F_TIMEOUT_NOSEQ)
-			continue;
-
-		/*
-		 * Since seq + count can overflow, use type long
-		 * long to store it.
-		 */
-		tmp = (long long)seq + count;
-		nxt_seq = nxt->sequence - nxt_offset;
-		tmp_nxt = (long long)nxt_seq + nxt_offset;
+		u32 nxt_off = nxt->timeout.target_cq - tail;
 
-		/*
-		 * cached_sq_head may overflow, and it will never overflow twice
-		 * once there is some timeout req still be valid.
-		 */
-		if (seq < nxt_seq)
-			tmp += UINT_MAX;
-
-		if (tmp > tmp_nxt)
+		if (!(nxt->flags & REQ_F_TIMEOUT_NOSEQ) && (off >= nxt_off))
 			break;
-
-		/*
-		 * Sequence of reqs after the insert one and itself should
-		 * be adjusted because each timeout req consumes a slot.
-		 */
-		span++;
-		nxt->sequence++;
 	}
-	req->sequence -= span;
 add:
 	list_add(&req->list, entry);
 	data->timer.function = io_timeout_fn;
-- 
2.24.0

