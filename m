Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFF42B0A71
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 17:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgKLQoM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 11:44:12 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:46146 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729167AbgKLQoM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 11:44:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UF6HVFi_1605199448;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UF6HVFi_1605199448)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 13 Nov 2020 00:44:08 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v2] io_uring: only wake up sq thread while current task is in io worker context
Date:   Fri, 13 Nov 2020 00:44:08 +0800
Message-Id: <20201112164408.18766-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If IORING_SETUP_SQPOLL is enabled, sqes are either handled in sq thread
task context or in io worker task context. If current task context is sq
thread, we don't need to check whether should wake up sq thread.

io_iopoll_req_issued() calls wq_has_sleeper(), which has smp_mb() memory
barrier, before this patch, perf shows obvious overhead:
  Samples: 481K of event 'cycles', Event count (approx.): 299807382878
  Overhead  Comma  Shared Object     Symbol
     3.69%  :9630  [kernel.vmlinux]  [k] io_issue_sqe

With this patch, perf shows:
  Samples: 482K of event 'cycles', Event count (approx.): 299929547283
  Overhead  Comma  Shared Object     Symbol
     0.70%  :4015  [kernel.vmlinux]  [k] io_issue_sqe

It shows some obvious improvements.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f594c72de777..287efc53f23a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2732,7 +2732,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
  * find it from a io_iopoll_getevents() thread before the issuer is done
  * accessing the kiocb cookie.
  */
-static void io_iopoll_req_issued(struct io_kiocb *req)
+static void io_iopoll_req_issued(struct io_kiocb *req, bool in_async)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -2761,7 +2761,12 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	else
 		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
 
-	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
+	/*
+	 * If IORING_SETUP_SQPOLL is enabled, sqes are either handled in sq thread
+	 * task context or in io worker task context. If current task context is
+	 * sq thread, we don't need to check whether should wake up sq thread.
+	 */
+	if (in_async && (ctx->flags & IORING_SETUP_SQPOLL) &&
 	    wq_has_sleeper(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 }
@@ -6245,7 +6250,7 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 		if (in_async)
 			mutex_lock(&ctx->uring_lock);
 
-		io_iopoll_req_issued(req);
+		io_iopoll_req_issued(req, in_async);
 
 		if (in_async)
 			mutex_unlock(&ctx->uring_lock);
-- 
2.17.2

