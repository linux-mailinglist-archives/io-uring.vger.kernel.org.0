Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28431E4AE6
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 18:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgE0Qto (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 May 2020 12:49:44 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60931 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728067AbgE0Qto (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 May 2020 12:49:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TzpWxFB_1590598177;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TzpWxFB_1590598177)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 May 2020 00:49:39 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v2 2/2] io_uring: avoid unnecessary io_wq_work copy for fast poll feature
Date:   Thu, 28 May 2020 00:49:16 +0800
Message-Id: <20200527164916.10546-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200527164916.10546-1-xiaoguang.wang@linux.alibaba.com>
References: <20200527164916.10546-1-xiaoguang.wang@linux.alibaba.com>
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
 fs/io_uring.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7ba8590a45a6..a704fc93a81d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -536,6 +536,7 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
+	REQ_F_WORK_NEED_RESTORE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -593,6 +594,8 @@ enum {
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
+	/* need restore io_wq_work */
+	REQ_F_WORK_NEED_RESTORE = BIT(REQ_F_WORK_NEED_RESTORE_BIT),
 };
 
 struct async_poll {
@@ -4411,7 +4414,8 @@ static void io_async_task_func(struct callback_head *cb)
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* restore ->work in case we need to retry again */
-	memcpy(&req->work, &apoll->work, sizeof(req->work));
+	if (req->flags & REQ_F_WORK_NEED_RESTORE)
+		memcpy(&req->work, &apoll->work, sizeof(req->work));
 	kfree(apoll);
 
 	if (!canceled) {
@@ -4508,7 +4512,10 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		return false;
 
 	req->flags |= REQ_F_POLLED;
-	memcpy(&apoll->work, &req->work, sizeof(req->work));
+	if (req->flags & REQ_F_WORK_INITIALIZED) {
+		req->flags |= REQ_F_WORK_NEED_RESTORE;
+		memcpy(&apoll->work, &req->work, sizeof(req->work));
+	}
 	had_io = req->io != NULL;
 
 	get_task_struct(current);
@@ -4533,7 +4540,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		if (!had_io)
 			io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		if (req->flags & REQ_F_WORK_NEED_RESTORE)
+			memcpy(&req->work, &apoll->work, sizeof(req->work));
 		kfree(apoll);
 		return false;
 	}
@@ -4578,7 +4586,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 			 * io_req_work_drop_env below when dropping the
 			 * final reference.
 			 */
-			memcpy(&req->work, &apoll->work, sizeof(req->work));
+			if (req->flags & REQ_F_WORK_NEED_RESTORE)
+				memcpy(&req->work, &apoll->work,
+				       sizeof(req->work));
 			kfree(apoll);
 		}
 	}
-- 
2.17.2

