Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7192257385B
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiGMOHd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 10:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbiGMOHb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 10:07:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98BB73247D
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 07:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657721248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VlxBh0eWzwPuhW8SmhdFQ+cC0txRQjD8/hmG+KuMxZk=;
        b=DnGU0kbctIml4w/qoJPHYftXdz188hFNowJ8i1+DUUMuNBcs8eeT06UZPzTDE3d+er24Vp
        Hzw9fhJWPBznqRKPEzqygzOyPPjYxX6HDODdSm/wOeJ3OfKQ6N483QwW+I/4x5qgqoflGO
        0/vL3D0Z/0z91Pmazlm0iJqMbu/HLhg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-byureFMnPOi2WDZmq6Itug-1; Wed, 13 Jul 2022 10:07:27 -0400
X-MC-Unique: byureFMnPOi2WDZmq6Itug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFD0C802D2C;
        Wed, 13 Jul 2022 14:07:26 +0000 (UTC)
Received: from localhost (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDC2B1121314;
        Wed, 13 Jul 2022 14:07:25 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 2/2] ublk_drv: support to complete io command via task_work_add
Date:   Wed, 13 Jul 2022 22:07:11 +0800
Message-Id: <20220713140711.97356-3-ming.lei@redhat.com>
In-Reply-To: <20220713140711.97356-1-ming.lei@redhat.com>
References: <20220713140711.97356-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use task_work_add if it is available, since task_work_add can bring
up better performance, especially batching signaling ->ubq_daemon can
be done.

It is observed that task_work_add() can boost iops by +4% on random
4k io test. Also except for completing io command, all other code
paths are same with completing io command via
io_uring_cmd_complete_in_task.

Meantime add one flag of UBLK_F_URING_CMD_COMP_IN_TASK for comparing
the mode easily.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c      | 75 +++++++++++++++++++++++++++++++----
 include/uapi/linux/ublk_cmd.h |  6 +++
 2 files changed, 73 insertions(+), 8 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 922a84c86fc6..35fa06ee70ff 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -41,10 +41,15 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <asm/page.h>
+#include <linux/task_work.h>
 #include <uapi/linux/ublk_cmd.h>
 
 #define UBLK_MINORS		(1U << MINORBITS)
 
+struct ublk_rq_data {
+	struct callback_head work;
+};
+
 struct ublk_uring_cmd_pdu {
 	struct request *req;
 };
@@ -91,6 +96,7 @@ struct ublk_queue {
 	int q_id;
 	int q_depth;
 
+	unsigned long flags;
 	struct task_struct	*ubq_daemon;
 	char *io_cmd_buf;
 
@@ -149,6 +155,14 @@ static DEFINE_MUTEX(ublk_ctl_mutex);
 
 static struct miscdevice ublk_misc;
 
+static inline bool ublk_can_use_task_work(const struct ublk_queue *ubq)
+{
+	if (IS_BUILTIN(CONFIG_BLK_DEV_UBLK) &&
+			!(ubq->flags & UBLK_F_URING_CMD_COMP_IN_TASK))
+		return true;
+	return false;
+}
+
 static struct ublk_device *ublk_get_device(struct ublk_device *ub)
 {
 	if (kobject_get_unless_zero(&ub->cdev_dev.kobj))
@@ -500,12 +514,10 @@ static void __ublk_fail_req(struct ublk_io *io, struct request *req)
 
 #define UBLK_REQUEUE_DELAY_MS	3
 
-static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd)
+static inline void __ublk_rq_task_work(struct request *req)
 {
-	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
-	struct ublk_device *ub = cmd->file->private_data;
-	struct request *req = pdu->req;
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+	struct ublk_device *ub = ubq->dev;
 	int tag = req->tag;
 	struct ublk_io *io = &ubq->ios[tag];
 	bool task_exiting = current != ubq->ubq_daemon ||
@@ -557,13 +569,27 @@ static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd)
 	io_uring_cmd_done(io->cmd, UBLK_IO_RES_OK, 0);
 }
 
+static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
+
+	__ublk_rq_task_work(pdu->req);
+}
+
+static void ublk_rq_task_work_fn(struct callback_head *work)
+{
+	struct ublk_rq_data *data = container_of(work,
+			struct ublk_rq_data, work);
+	struct request *req = blk_mq_rq_from_pdu(data);
+
+	__ublk_rq_task_work(req);
+}
+
 static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
 	struct ublk_queue *ubq = hctx->driver_data;
 	struct request *rq = bd->rq;
-	struct io_uring_cmd *cmd = ubq->ios[rq->tag].cmd;
-	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	blk_status_t res;
 
 	/* fill iod to slot in io cmd buffer */
@@ -574,16 +600,36 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 	blk_mq_start_request(bd->rq);
 
 	if (unlikely(ubq_daemon_is_dying(ubq))) {
+ fail:
 		mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 		return BLK_STS_IOERR;
 	}
 
-	pdu->req = rq;
-	io_uring_cmd_complete_in_task(cmd, ublk_rq_task_work_cb);
+	if (ublk_can_use_task_work(ubq)) {
+		struct ublk_rq_data *data = blk_mq_rq_to_pdu(rq);
+		enum task_work_notify_mode notify_mode = bd->last ?
+			TWA_SIGNAL_NO_IPI : TWA_NONE;
+
+		if (task_work_add(ubq->ubq_daemon, &data->work, notify_mode))
+			goto fail;
+	} else {
+		struct io_uring_cmd *cmd = ubq->ios[rq->tag].cmd;
+		struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
+
+		pdu->req = rq;
+		io_uring_cmd_complete_in_task(cmd, ublk_rq_task_work_cb);
+	}
 
 	return BLK_STS_OK;
 }
 
+static void ublk_commit_rqs(struct blk_mq_hw_ctx *hctx)
+{
+	struct ublk_queue *ubq = hctx->driver_data;
+
+	if (ublk_can_use_task_work(ubq))
+		__set_notify_signal(ubq->ubq_daemon);
+}
 
 static int ublk_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
 		unsigned int hctx_idx)
@@ -595,9 +641,20 @@ static int ublk_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
 	return 0;
 }
 
+static int ublk_init_rq(struct blk_mq_tag_set *set, struct request *req,
+		unsigned int hctx_idx, unsigned int numa_node)
+{
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+
+	init_task_work(&data->work, ublk_rq_task_work_fn);
+	return 0;
+}
+
 static const struct blk_mq_ops ublk_mq_ops = {
 	.queue_rq       = ublk_queue_rq,
+	.commit_rqs     = ublk_commit_rqs,
 	.init_hctx	= ublk_init_hctx,
+	.init_request   = ublk_init_rq,
 };
 
 static int ublk_ch_open(struct inode *inode, struct file *filp)
@@ -912,6 +969,7 @@ static int ublk_init_queue(struct ublk_device *ub, int q_id)
 	void *ptr;
 	int size;
 
+	ubq->flags = ub->dev_info.flags[0];
 	ubq->q_id = q_id;
 	ubq->q_depth = ub->dev_info.queue_depth;
 	size = ublk_queue_cmd_buf_size(ub, q_id);
@@ -1099,6 +1157,7 @@ static int ublk_add_dev(struct ublk_device *ub)
 	ub->tag_set.nr_hw_queues = ub->dev_info.nr_hw_queues;
 	ub->tag_set.queue_depth = ub->dev_info.queue_depth;
 	ub->tag_set.numa_node = NUMA_NO_NODE;
+	ub->tag_set.cmd_size = sizeof(struct ublk_rq_data);
 	ub->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 	ub->tag_set.driver_data = ub;
 
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index 4f0c16ec875e..a3f5e7c21807 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -48,6 +48,12 @@
  */
 #define UBLK_F_SUPPORT_ZERO_COPY	(1UL << 0)
 
+/*
+ * Force to complete io cmd via io_uring_cmd_complete_in_task so that
+ * performance comparison is done easily with using task_work_add
+ */
+#define UBLK_F_URING_CMD_COMP_IN_TASK	(1UL << 1)
+
 /* device state */
 #define UBLK_S_DEV_DEAD	0
 #define UBLK_S_DEV_LIVE	1
-- 
2.31.1

