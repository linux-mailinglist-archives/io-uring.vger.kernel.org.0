Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AECE2D9B72
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 16:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbgLNPug (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 10:50:36 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:39114 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727458AbgLNPu0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 10:50:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UIe5xmz_1607960981;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UIe5xmz_1607960981)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Dec 2020 23:49:41 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: hold uring_lock to complete faild polled io in io_wq_submit_work()
Date:   Mon, 14 Dec 2020 23:49:41 +0800
Message-Id: <20201214154941.10907-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_iopoll_complete() does not hold completion_lock to complete polled
io, so in io_wq_submit_work(), we can not call io_req_complete() directly,
to complete polled io, otherwise there maybe concurrent access to cqring,
defer_list, etc, which is not safe. Commit dad1b1242fd5 ("io_uring: always
let io_iopoll_complete() complete polled io") has fixed this issue, but
Pavel reported that IOPOLL apart from rw can do buf reg/unreg requests(
IORING_OP_PROVIDE_BUFFERS or IORING_OP_REMOVE_BUFFERS), so the fix is
not good.

Given that io_iopoll_complete() is always called under uring_lock, so here
for polled io, we can also get uring_lock to fix this issue.

Fixes: dad1b1242fd5 ("io_uring: always let io_iopoll_complete() complete polled io")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f53356ced5ab..eab3d2b7d232 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6354,19 +6354,24 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 	}
 
 	if (ret) {
+		bool iopoll_enabled = req->ctx->flags & IORING_SETUP_IOPOLL;
+
 		/*
-		 * io_iopoll_complete() does not hold completion_lock to complete
-		 * polled io, so here for polled io, just mark it done and still let
-		 * io_iopoll_complete() complete it.
+		 * io_iopoll_complete() does not hold completion_lock to complete polled
+		 * io, so here for polled io, we can not call io_req_complete() directly,
+		 * otherwise there maybe concurrent access to cqring, defer_list, etc,
+		 * which is not safe. Given that io_iopoll_complete() is always called
+		 * under uring_lock, so here for polled io, we also get uring_lock to
+		 * complete it.
 		 */
-		if (req->ctx->flags & IORING_SETUP_IOPOLL) {
-			struct kiocb *kiocb = &req->rw.kiocb;
+		if (iopoll_enabled)
+			mutex_lock(&req->ctx->uring_lock);
 
-			kiocb_done(kiocb, ret, NULL);
-		} else {
-			req_set_fail_links(req);
-			io_req_complete(req, ret);
-		}
+		req_set_fail_links(req);
+		io_req_complete(req, ret);
+
+		if (iopoll_enabled)
+			mutex_unlock(&req->ctx->uring_lock);
 	}
 
 	return io_steal_work(req);
-- 
2.17.2

