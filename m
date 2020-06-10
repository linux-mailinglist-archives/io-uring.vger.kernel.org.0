Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206461F53A9
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2020 13:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgFJLls (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 07:41:48 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:60242 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbgFJLls (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 07:41:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U.Ajpzn_1591789303;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.Ajpzn_1591789303)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Jun 2020 19:41:45 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v7 2/2] io_uring: avoid unnecessary io_wq_work copy for fast poll feature
Date:   Wed, 10 Jun 2020 19:41:20 +0800
Message-Id: <20200610114120.7518-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200610114120.7518-1-xiaoguang.wang@linux.alibaba.com>
References: <20200610114120.7518-1-xiaoguang.wang@linux.alibaba.com>
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

V6:
  rebase to io_uring-5.8.
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e906914f573..a252aa1804ed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4258,7 +4258,8 @@ static void io_async_task_func(struct callback_head *cb)
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* restore ->work in case we need to retry again */
-	memcpy(&req->work, &apoll->work, sizeof(req->work));
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		memcpy(&req->work, &apoll->work, sizeof(req->work));
 	kfree(apoll);
 
 	if (!canceled) {
@@ -4355,7 +4356,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		return false;
 
 	req->flags |= REQ_F_POLLED;
-	memcpy(&apoll->work, &req->work, sizeof(req->work));
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		memcpy(&apoll->work, &req->work, sizeof(req->work));
 	had_io = req->io != NULL;
 
 	get_task_struct(current);
@@ -4380,7 +4382,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		if (!had_io)
 			io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
-		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		if (req->flags & REQ_F_WORK_INITIALIZED)
+			memcpy(&req->work, &apoll->work, sizeof(req->work));
 		kfree(apoll);
 		return false;
 	}
@@ -4425,7 +4428,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
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

