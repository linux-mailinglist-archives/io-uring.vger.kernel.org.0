Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23961E1B83
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 08:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgEZGnw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 02:43:52 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45369 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726756AbgEZGnw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 02:43:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TzhLNGl_1590475427;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzhLNGl_1590475427)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 May 2020 14:43:49 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH 3/3] io_uring: avoid unnecessary io_wq_work copy for fast poll feature
Date:   Tue, 26 May 2020 14:43:30 +0800
Message-Id: <20200526064330.9322-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
References: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Basically IORING_OP_POLL_ADD command and async armed poll handlers
for regular commands don't touch io_wq_work, so there is no need to
always do io_wq_work copy. Here add a new flag 'REQ_F_WORK_NEED_RESTORE'
to control whether to do io_wq_work copy.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a54b21e6d921..6b9c79048962 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -535,6 +535,7 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
+	REQ_F_WORK_NEED_RESTORE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -590,6 +591,8 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
+	/* need restore io_wq_work */
+	REQ_F_WORK_NEED_RESTORE = BIT(REQ_F_WORK_NEED_RESTORE_BIT),
 };
 
 struct async_poll {
@@ -4390,7 +4393,10 @@ static void io_async_task_func(struct callback_head *cb)
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* restore ->work in case we need to retry again */
-	memcpy(&req->work, &apoll->work, sizeof(req->work));
+	if (req->flags & REQ_F_WORK_NEED_RESTORE)
+		memcpy(&req->work, &apoll->work, sizeof(req->work));
+	else
+		req->work.func = NULL;
 	kfree(apoll);
 
 	if (!canceled) {
@@ -4487,7 +4493,10 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		return false;
 
 	req->flags |= REQ_F_POLLED;
-	memcpy(&apoll->work, &req->work, sizeof(req->work));
+	if (req->work.func) {
+		req->flags |= REQ_F_WORK_NEED_RESTORE;
+		memcpy(&apoll->work, &req->work, sizeof(req->work));
+	}
 	had_io = req->io != NULL;
 
 	get_task_struct(current);
@@ -4512,7 +4521,10 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		if (!had_io)
 			io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		if (req->flags & REQ_F_WORK_NEED_RESTORE)
+			memcpy(&req->work, &apoll->work, sizeof(req->work));
+		else
+			req->work.func = NULL;
 		kfree(apoll);
 		return false;
 	}
@@ -4557,7 +4569,11 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 			 * io_req_work_drop_env below when dropping the
 			 * final reference.
 			 */
-			memcpy(&req->work, &apoll->work, sizeof(req->work));
+			if (req->flags & REQ_F_WORK_NEED_RESTORE)
+				memcpy(&req->work, &apoll->work,
+				       sizeof(req->work));
+			else
+				req->work.func = NULL;
 			kfree(apoll);
 		}
 	}
-- 
2.17.2

