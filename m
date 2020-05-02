Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556001C250B
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgEBMI7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgEBMI6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:08:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1C4C061A0E;
        Sat,  2 May 2020 05:08:56 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s8so4708048wrt.9;
        Sat, 02 May 2020 05:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yMQ9IOKo1KnSPaT8dJBt+GNOkq+ATkfGATkYQUM0uaY=;
        b=a5QRuowUXnxFNad0UjHTUZXtLb3VVnuV64ZA+BeZMSDGbPhvKc2fkfyCqKeaPIwJcG
         phNz/NSHjt4+Bio46m1JEWVFfwcUB7fndky1p5kKvcqe95uu4y6c14mQkkWaVQ6rIpIP
         qpLBZvw9W6lsxmXt9V0eAVJnKQLL3SSyq7R/K0ozC6QNe4/nDgWRbu3kY0G1/Vq8VlKp
         +7ae0zzBow6HrC5ma/I5c0ZsJ3a5HySXJ+zHXT/L0e5pXQMnYqa5IRFeF7ZRZQcbeQ4k
         +y5v+ZZyfSBY5BihqZc2hSG6f7VKw+wP9rIEKPRoSZgaJhv8gMDt+JFwI06cl072h6ae
         9m8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yMQ9IOKo1KnSPaT8dJBt+GNOkq+ATkfGATkYQUM0uaY=;
        b=JSnI6fxJb3cKyXprHn/zmIwx4KqTWhOeqcvsXT3jJRIh7TASm6o4fdf87ol1YK8n4H
         5BC6bkz8ZFimAMnrOPH8aavlQJug2B9KOXbl6+ESZz4HyAUoorvu5tMxM7zEIYjE/vi/
         cl8TK6LL6Pkv4sWKc0kE90DkOlGjLYFvwZUlLEsfHET7OdhR7GoUpqvJI+U9OVzC0Cgx
         zi5ibaAPRZnanj3SBjmKtBGCuPqYW9oGPhxwh4HVwxGlNMDHydxU9p9ijPx/UPwd5oTZ
         77Eq/BJ3VZWKaRObOokWAHyo5Dg8kp3iSSs4lh4qFGlskCipwjUdRasYY6lXcfXYbaKI
         zGVw==
X-Gm-Message-State: AGi0Pua6v1D+4hvMmMh1MUKqE/sTGh4ZkE24qKExXZZCIPUUEYaL9b1W
        7gIGFYNY6JVB8M0IIOk3TarUYAFI
X-Google-Smtp-Source: APiQypIsCUqxVo8E9fM1Awgjzo/Iy+N+WbYGovM4VNoESyZCmE3+0VRYXQJnLdQhW1I4JQjd19xW4w==
X-Received: by 2002:adf:e702:: with SMTP id c2mr9332522wrm.252.1588421335279;
        Sat, 02 May 2020 05:08:55 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j13sm8930716wrx.5.2020.05.02.05.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:08:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io_uring: fix timeout offset with batch CQ commit
Date:   Sat,  2 May 2020 15:07:15 +0300
Message-Id: <bb2c05f271ceda09fc69327440905d87a6d796fa.1588420906.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588420906.git.asml.silence@gmail.com>
References: <cover.1588420906.git.asml.silence@gmail.com>
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
index 827b0b967dc7..4ed82d39540b 100644
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
@@ -1085,6 +1086,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
 	if (ret != -1) {
 		atomic_inc(&req->ctx->cq_timeouts);
+		req->ctx->cq_seq--;
 		list_del_init(&req->list);
 		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
@@ -1102,16 +1104,31 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
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
@@ -1147,6 +1164,7 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ctx->cached_cq_tail++;
+	ctx->cq_seq++;
 	return &rings->cqes[tail & ctx->cq_mask];
 }
 
@@ -4579,6 +4597,8 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	atomic_inc(&ctx->cq_timeouts);
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	ctx->cq_seq--;
+
 	/*
 	 * We could be racing with timeout deletion. If the list is empty,
 	 * then timeout lookup already found it and will be handling it.
@@ -4702,7 +4722,7 @@ static int io_timeout(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data = &req->io->timeout;
 	struct list_head *entry;
-	u32 tail, off = req->timeout.off;
+	u32 off = req->timeout.off;
 
 	spin_lock_irq(&ctx->completion_lock);
 
@@ -4717,8 +4737,7 @@ static int io_timeout(struct io_kiocb *req)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
-	req->timeout.target_seq = tail + off;
+	req->timeout.target_seq = ctx->cq_seq + off;
 
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
@@ -4726,7 +4745,7 @@ static int io_timeout(struct io_kiocb *req)
 	 */
 	list_for_each_prev(entry, &ctx->timeout_list) {
 		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
-		u32 nxt_off = nxt->timeout.target_seq - tail;
+		u32 nxt_off = (u32)(nxt->timeout.target_seq - ctx->cq_seq);
 
 		if (!(nxt->flags & REQ_F_TIMEOUT_NOSEQ) && (off >= nxt_off))
 			break;
-- 
2.24.0

