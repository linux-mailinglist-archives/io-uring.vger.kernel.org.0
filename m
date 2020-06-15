Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0641F9F05
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 20:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgFOSGu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 14:06:50 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:53991 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728585AbgFOSGu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 14:06:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U.iIt8V_1592244406;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.iIt8V_1592244406)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Jun 2020 02:06:46 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v2 2/2] io_uring: add memory barrier to synchronize io_kiocb's result and iopoll_completed
Date:   Tue, 16 Jun 2020 02:06:38 +0800
Message-Id: <20200615180638.19905-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200615180638.19905-1-xiaoguang.wang@linux.alibaba.com>
References: <20200615180638.19905-1-xiaoguang.wang@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
completed are two independent store operations, to ensure that once
iopoll_completed is ture and then req->result must been perceived by
the cpu executing io_do_iopoll(), proper memory barrier should be used.

And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
we'll need to issue this io request using io-wq again. In order to just
issue a single smp_rmb() on the completion side, move the re-submit work
to io_iopoll_complete().

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 53 +++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a3119fecfe40..13e24a6137d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1728,6 +1728,18 @@ static int io_put_kbuf(struct io_kiocb *req)
 	return cflags;
 }
 
+static void io_iopoll_queue(struct list_head *again)
+{
+	struct io_kiocb *req;
+
+	do {
+		req = list_first_entry(again, struct io_kiocb, list);
+		list_del(&req->list);
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
+	} while (!list_empty(again));
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -1736,12 +1748,21 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
+	LIST_HEAD(again);
+
+	/* order with ->result store in io_complete_rw_iopoll() */
+	smp_rmb();
 
 	rb.to_free = rb.need_iter = 0;
 	while (!list_empty(done)) {
 		int cflags = 0;
 
 		req = list_first_entry(done, struct io_kiocb, list);
+		if (READ_ONCE(req->result) == -EAGAIN) {
+			req->iopoll_completed = 0;
+			list_move_tail(&req->list, &again);
+			continue;
+		}
 		list_del(&req->list);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
@@ -1759,18 +1780,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_ev_posted(ctx);
 	io_free_req_many(ctx, &rb);
-}
 
-static void io_iopoll_queue(struct list_head *again)
-{
-	struct io_kiocb *req;
-
-	do {
-		req = list_first_entry(again, struct io_kiocb, list);
-		list_del(&req->list);
-		refcount_inc(&req->refs);
-		io_queue_async_work(req);
-	} while (!list_empty(again));
+	if (!list_empty(&again))
+		io_iopoll_queue(&again);
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
@@ -1778,7 +1790,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
-	LIST_HEAD(again);
 	bool spin;
 	int ret;
 
@@ -1804,13 +1815,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (!list_empty(&done))
 			break;
 
-		if (req->result == -EAGAIN) {
-			list_move_tail(&req->list, &again);
-			continue;
-		}
-		if (!list_empty(&again))
-			break;
-
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
 		if (ret < 0)
 			break;
@@ -1823,9 +1827,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	if (!list_empty(&done))
 		io_iopoll_complete(ctx, nr_events, &done);
 
-	if (!list_empty(&again))
-		io_iopoll_queue(&again);
-
 	return ret;
 }
 
@@ -1976,9 +1977,11 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
-	req->result = res;
-	if (res != -EAGAIN)
-		WRITE_ONCE(req->iopoll_completed, 1);
+
+	WRITE_ONCE(req->result, res);
+	/* order with io_poll_complete() checking ->result */
+	smp_wmb();
+	WRITE_ONCE(req->iopoll_completed, 1);
 }
 
 /*
-- 
2.17.2

