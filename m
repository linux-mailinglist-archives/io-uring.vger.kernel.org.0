Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5DF1C2505
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEBMIx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgEBMIx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:08:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF07AC061A0C;
        Sat,  2 May 2020 05:08:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so2909180wmb.4;
        Sat, 02 May 2020 05:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MFel+B1Mszkv0q0F6DOoaPx9e8pe6F+6s+41BVofzQo=;
        b=DDbNb2OnFwJQyv17QszDvo8DLvYLurjxvGfwqvFPdY8SZyWKL0yrTcmc5o+TPaVEpX
         l6Gxg3L3faoY/MpX1c2yR90TzrwUJZLzI+Ts3iYUqkquedgE1ZI/c+PIwApBsrACbWwp
         qdyWJ4J2s8xUU47FwWR9fIJW2A7spGAzj8TuIiQ5Vd/8asJBlIA6k3ly3uo2bxdnqThY
         qhmJbgQuOHXbLGh0BjWhJbz+LY8qgbwGHu2YIQ7WPMLT8KozADBOCP48++I54e0OnKCc
         vWJs8b+9VMViWHpDIikQDNp9Gwnp21l6SHRQot7JitDg+0KZ7FQ7+Fc6G+xjfq8PfHvl
         Opcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFel+B1Mszkv0q0F6DOoaPx9e8pe6F+6s+41BVofzQo=;
        b=Hugc/cWLbBPHT/4ie6gMd2rewnH7VU5Jb7FR18pPucks956INaTz7I3mubOF9yRCQr
         USOaeSTa32Iv1Uk2ZTKMo68e3nj+XNbcs9Ap/9W3/zTyx5M6yTLAwx7i54QzOXLR2dEu
         GeqoRJ/QLUOw5TJ1qu9v6xcgid/mNN/h+cCG9UjRK4o+X9oYhUIe+RL2JSo6E/qZPS65
         QvdX+m6G5esI6FsFZ7yz/eV+6HCwTE4sQflScY9aRVc1ZegaWYwSKygGZK7fmsX11ijZ
         xKakk2+/oibTV7eBcr1H6L/Nm7l+GBUMJbKbWYa947uVjrwOu5A71kHGwq7nnakz8Oii
         ylYQ==
X-Gm-Message-State: AGi0PuaMsvyVkW++FHqK8kNWWuBMlsXvKgpL3OZA/JwxXHjdoLmHaW5z
        Jf15q5kqm5acTieGRbcSZJNA0Pjr
X-Google-Smtp-Source: APiQypLchfulrE5nOQr125fB12+5MRn+vREc173epFroqJqKv290rFoJX0bfqwRvSdS2s/NZq7N3GQ==
X-Received: by 2002:a1c:1fcf:: with SMTP id f198mr4493914wmf.16.1588421331513;
        Sat, 02 May 2020 05:08:51 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j13sm8930716wrx.5.2020.05.02.05.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:08:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io_uring: trigger timeout after any sqe->off CQEs
Date:   Sat,  2 May 2020 15:07:13 +0300
Message-Id: <38fddf1e89d20ef9f08c22bead592af08051b2cc.1588420906.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588420906.git.asml.silence@gmail.com>
References: <cover.1588420906.git.asml.silence@gmail.com>
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
index 65458eda2127..148f61734572 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -384,7 +384,8 @@ struct io_timeout {
 	struct file			*file;
 	u64				addr;
 	int				flags;
-	u32				count;
+	u32				off;
+	u32				target_seq;
 };
 
 struct io_rw {
@@ -986,23 +987,6 @@ static struct io_kiocb *io_get_deferred_req(struct io_ring_ctx *ctx)
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
@@ -1118,12 +1102,42 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
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
+		if (!io_check_in_range(req->timeout.target_seq, start, end))
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
 
@@ -4582,20 +4596,8 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
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
@@ -4675,18 +4677,19 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4710,68 +4713,37 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	req->timeout.target_seq = tail + off;
 
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
+		u32 nxt_off = nxt->timeout.target_seq - tail;
 
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

