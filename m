Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A022B0468
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 12:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgKLLxo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 06:53:44 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:49504 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726969AbgKLLxb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 06:53:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UF4n0Z._1605182008;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UF4n0Z._1605182008)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 12 Nov 2020 19:53:29 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: only wake up sq thread while current task is in io worker context
Date:   Thu, 12 Nov 2020 19:53:28 +0800
Message-Id: <20201112115328.17185-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When IORING_SETUP_SQPOLL is enabled, io_uring will always handle sqes
in sq thread task context, so in io_iopoll_req_issued(), if we're not
in io worker context, we don't need to check whether should wake up
sq thread. io_iopoll_req_issued() calls wq_has_sleeper(), which has
smp_mb() memory barrier, perf shows obvious overhead:
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
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f594c72de777..c7e035433c59 100644
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
 
@@ -2761,7 +2761,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	else
 		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
 
-	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
+	if (in_async && (ctx->flags & IORING_SETUP_SQPOLL) &&
 	    wq_has_sleeper(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 }
@@ -6245,7 +6245,7 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 		if (in_async)
 			mutex_lock(&ctx->uring_lock);
 
-		io_iopoll_req_issued(req);
+		io_iopoll_req_issued(req, in_async);
 
 		if (in_async)
 			mutex_unlock(&ctx->uring_lock);
-- 
2.17.2

