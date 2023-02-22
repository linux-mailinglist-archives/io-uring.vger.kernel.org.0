Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435CE69F543
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 14:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjBVN0N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 08:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBVN0M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 08:26:12 -0500
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52983B645;
        Wed, 22 Feb 2023 05:25:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VcGxflu_1677072336;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VcGxflu_1677072336)
          by smtp.aliyun-inc.com;
          Wed, 22 Feb 2023 21:25:37 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
Subject: [RFC v2 3/4] io_uring: introduce IORING_URING_CMD_UNLOCK flag
Date:   Wed, 22 Feb 2023 21:25:33 +0800
Message-Id: <20230222132534.114574-4-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com>
References: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

task_work_cb and its child functions may call io_uring_submit_sqe()
in io_uring_cmd's callback, so to avoid ctx->uring_lock deadlock,
introduce IORING_URING_CMD_UNLOCK to unlock uring_lock temporarily
in io_uring_cmd_work().

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 include/uapi/linux/io_uring.h | 5 +++++
 io_uring/uring_cmd.c          | 6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2780bce62faf..45ea8c35d251 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -232,8 +232,13 @@ enum io_uring_op {
  * sqe->uring_cmd_flags
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ *
+ * IORING_URING_CMD_UNLOCK	Notify io_uring_cmd's task_work_cb to
+ *				unlock uring_lock, some ->uring_cmd()
+ *				implementations need it.
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
+#define IORING_URING_CMD_UNLOCK	(1U << 1)
 
 
 /*
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 446a189b78b0..11488a702832 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -16,7 +16,11 @@ static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
+	if ((req->flags & IORING_URING_CMD_UNLOCK) && *locked)
+		mutex_unlock(&(req->ctx->uring_lock));
 	ioucmd->task_work_cb(ioucmd);
+	if ((req->flags & IORING_URING_CMD_UNLOCK) && *locked)
+		mutex_lock(&(req->ctx->uring_lock));
 }
 
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
@@ -82,7 +86,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
-	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
+	if (ioucmd->flags & ~(IORING_URING_CMD_FIXED | IORING_URING_CMD_UNLOCK))
 		return -EINVAL;
 
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
-- 
2.31.1

