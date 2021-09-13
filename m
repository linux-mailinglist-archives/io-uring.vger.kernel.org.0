Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3BE408C18
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 15:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhIMNK1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 09:10:27 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:57095 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhIMNKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 09:10:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoFcs8C_1631538534;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoFcs8C_1631538534)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Sep 2021 21:09:02 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: add more uring info to fdinfo for debug
Date:   Mon, 13 Sep 2021 21:08:54 +0800
Message-Id: <20210913130854.38542-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Developers may need some uring info to help themselves debug and address
issues, these info includes sqring/cqring head/tail and the detail
sqe/cqe info, which is very useful when it stucks.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f795ad281038..ac048592a3e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9950,8 +9950,48 @@ static int io_uring_show_cred(struct seq_file *m, unsigned int id,
 static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 {
 	struct io_sq_data *sq = NULL;
+	struct io_overflow_cqe *ocqe;
+	struct io_rings *r = ctx->rings;
+	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
+	unsigned int cached_sq_head = ctx->cached_sq_head;
+	unsigned int cached_cq_tail = ctx->cached_cq_tail;
+	unsigned int sq_head = READ_ONCE(r->sq.head);
+	unsigned int sq_tail = READ_ONCE(r->sq.tail);
+	unsigned int cq_head = READ_ONCE(r->cq.head);
+	unsigned int cq_tail = READ_ONCE(r->cq.tail);
 	bool has_lock;
-	int i;
+	unsigned int i;
+
+	/*
+	 * we may get imprecise sqe and cqe info if uring is actively running
+	 * since we get cached_sq_head and cached_cq_tail without uring_lock
+	 * and sq_tail and cq_head are changed by userspace. But it's ok since
+	 * we usually use these info when it is stuck.
+	 */
+	seq_printf(m, "SqHead:\t%u\n", sq_head & sq_mask);
+	seq_printf(m, "SqTail:\t%u\n", sq_tail & sq_mask);
+	seq_printf(m, "CachedSqHead:\t%u\n", cached_sq_head & sq_mask);
+	seq_printf(m, "CqHead:\t%u\n", cq_head & cq_mask);
+	seq_printf(m, "CqTail:\t%u\n", cq_tail & cq_mask);
+	seq_printf(m, "CachedCqTail:\t%u\n", cached_cq_tail & cq_mask);
+	seq_printf(m, "SQEs:\t%u\n", sq_tail - cached_sq_head);
+	for (i = cached_sq_head; i < sq_tail; i++) {
+		unsigned int sq_idx = READ_ONCE(ctx->sq_array[i & sq_mask]);
+
+		if (likely(sq_idx <= sq_mask)) {
+			struct io_uring_sqe *sqe = &ctx->sq_sqes[sq_idx];
+
+			seq_printf(m, "%5u: opcode:%d, fd:%d, flags:%x, user_data:%llu\n",
+				   sq_idx, sqe->opcode, sqe->fd, sqe->flags, sqe->user_data);
+		}
+	}
+	seq_printf(m, "CQEs:\t%u\n", cached_cq_tail - cq_head);
+	for (i = cq_head; i < cached_cq_tail; i++) {
+		struct io_uring_cqe *cqe = &r->cqes[i & cq_mask];
+
+		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x\n",
+			   i & cq_mask, cqe->user_data, cqe->res, cqe->flags);
+	}
 
 	/*
 	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
@@ -9993,7 +10033,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		xa_for_each(&ctx->personalities, index, cred)
 			io_uring_show_cred(m, index, cred);
 	}
-	seq_printf(m, "PollList:\n");
+	if (has_lock)
+		mutex_unlock(&ctx->uring_lock);
+
+	seq_puts(m, "PollList:\n");
 	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list = &ctx->cancel_hash[i];
@@ -10003,9 +10046,17 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
 					req->task->task_works != NULL);
 	}
+
+	seq_puts(m, "CqOverflowList:\n");
+	list_for_each_entry(ocqe, &ctx->cq_overflow_list, list) {
+		struct io_uring_cqe *cqe = &ocqe->cqe;
+
+		seq_printf(m, "  user_data=%llu, res=%d, flags=%x\n",
+			   cqe->user_data, cqe->res, cqe->flags);
+
+	}
+
 	spin_unlock(&ctx->completion_lock);
-	if (has_lock)
-		mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
-- 
2.24.4

