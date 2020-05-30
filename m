Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D8A1E9223
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 16:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgE3OkG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 10:40:06 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43553 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728927AbgE3OkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 10:40:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U-2j4rl_1590849600;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-2j4rl_1590849600)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 30 May 2020 22:40:02 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v4 2/2] io_uring: avoid unnecessary io_wq_work copy for fast poll feature
Date:   Sat, 30 May 2020 22:39:47 +0800
Message-Id: <20200530143947.21224-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200530143947.21224-1-xiaoguang.wang@linux.alibaba.com>
References: <20200530143947.21224-1-xiaoguang.wang@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Basically IORING_OP_POLL_ADD command and async armed poll handlers
for regular commands don't touch io_wq_work, so only REQ_F_WORK_INITIALIZED
is set, can we do io_wq_work copy and restore.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

---
V3:
  drop the REQ_F_WORK_NEED_RESTORE flag introduced in V2 patch, just
  use REQ_F_WORK_INITIALIZED to control whether to do io_wq_work copy
  and restore.
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12296ce3e8b9..a7d61f3366a5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4513,7 +4513,8 @@ static void io_async_task_func(struct callback_head *cb)
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* restore ->work in case we need to retry again */
-	memcpy(&req->work, &apoll->work, sizeof(req->work));
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		memcpy(&req->work, &apoll->work, sizeof(req->work));
 	kfree(apoll);
 
 	if (!canceled) {
@@ -4610,7 +4611,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		return false;
 
 	req->flags |= REQ_F_POLLED;
-	memcpy(&apoll->work, &req->work, sizeof(req->work));
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		memcpy(&apoll->work, &req->work, sizeof(req->work));
 	had_io = req->io != NULL;
 
 	get_task_struct(current);
@@ -4635,7 +4637,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		if (!had_io)
 			io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		if (req->flags & REQ_F_WORK_INITIALIZED)
+			memcpy(&req->work, &apoll->work, sizeof(req->work));
 		kfree(apoll);
 		return false;
 	}
@@ -4680,7 +4683,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 			 * io_req_work_drop_env below when dropping the
 			 * final reference.
 			 */
-			memcpy(&req->work, &apoll->work, sizeof(req->work));
+			if (req->flags & REQ_F_WORK_INITIALIZED)
+				memcpy(&req->work, &apoll->work,
+				       sizeof(req->work));
 			kfree(apoll);
 		}
 	}
-- 
2.17.2

