Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A059756D2F3
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 04:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGKCVI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jul 2022 22:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiGKCU6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jul 2022 22:20:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2699D1839A
        for <io-uring@vger.kernel.org>; Sun, 10 Jul 2022 19:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657506051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yiT1eLlqkfPZrENplLR+NiQCkEFdX9LuuEGtFfnHdws=;
        b=BD8ryoq8vHKfGWF5UsyG19DUxrH0mQJsAeDWzj4G9BeNi+ZuudDnunJMf8uUneBgMgcFju
        zmnyKUqRen22iVm0ApcZBWuXsz+dHeVxZBpleNCo1pk0o9aVD1jJGRD+XJ9yFWD3yDJC33
        p1dQwEQc3BgicCHRKdjE4d8QVqrX1C0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-kPEFzlcjNmGi1amj0h_NnA-1; Sun, 10 Jul 2022 22:20:44 -0400
X-MC-Unique: kPEFzlcjNmGi1amj0h_NnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BF58185A7A4;
        Mon, 11 Jul 2022 02:20:42 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 933C92166B26;
        Mon, 11 Jul 2022 02:20:40 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 2/2] ublk_drv: add UBLK_IO_REFETCH_REQ for supporting to build as module
Date:   Mon, 11 Jul 2022 10:20:24 +0800
Message-Id: <20220711022024.217163-3-ming.lei@redhat.com>
In-Reply-To: <20220711022024.217163-1-ming.lei@redhat.com>
References: <20220711022024.217163-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add UBLK_IO_REFETCH_REQ command to fetch the incoming io request in
ubq daemon context, so we can avoid to call task_work_add(), then
it is fine to build ublk driver as module.

In this way, iops is affected a bit, but just by ~5% on ublk/null,
given io_uring provides pretty good batching issuing & completing.

One thing to be careful is race between ->queue_rq() and handling
abort, which is avoided by quiescing queue when aborting queue.
Except for that, handling abort becomes much easier with
UBLK_IO_REFETCH_REQ since aborting handler is strictly exclusive with
anything done in ubq daemon kernel context.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/Kconfig         |   2 +-
 drivers/block/ublk_drv.c      | 121 ++++++++++++++++++++++++++--------
 include/uapi/linux/ublk_cmd.h |  17 +++++
 3 files changed, 113 insertions(+), 27 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index d218089cdbec..2ba77fd960c2 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -409,7 +409,7 @@ config BLK_DEV_RBD
 	  If unsure, say N.
 
 config BLK_DEV_UBLK
-	bool "Userspace block driver"
+	tristate "Userspace block driver"
 	select IO_URING
 	help
           io uring based userspace block driver.
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0076418e6fad..98482f8d1a77 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -92,6 +92,7 @@ struct ublk_queue {
 	int q_id;
 	int q_depth;
 
+	unsigned long flags;
 	struct task_struct	*ubq_daemon;
 	char *io_cmd_buf;
 
@@ -141,6 +142,15 @@ struct ublk_device {
 	struct work_struct	stop_work;
 };
 
+#define ublk_use_task_work(ubq)						\
+({                                                                      \
+	bool ret = false;						\
+	if (IS_BUILTIN(CONFIG_BLK_DEV_UBLK) &&                          \
+			!((ubq)->flags & UBLK_F_NEED_REFETCH))		\
+		ret = true;						\
+	ret;								\
+})
+
 static dev_t ublk_chr_devt;
 static struct class *ublk_chr_class;
 
@@ -429,6 +439,26 @@ static int ublk_setup_iod(struct ublk_queue *ubq, struct request *req)
 	return BLK_STS_OK;
 }
 
+static bool ubq_daemon_is_dying(struct ublk_queue *ubq)
+{
+	return ubq->ubq_daemon->flags & PF_EXITING;
+}
+
+static void ubq_complete_io_cmd(struct ublk_io *io, int res)
+{
+	/* mark this cmd owned by ublksrv */
+	io->flags |= UBLK_IO_FLAG_OWNED_BY_SRV;
+
+	/*
+	 * clear ACTIVE since we are done with this sqe/cmd slot
+	 * We can only accept io cmd in case of being not active.
+	 */
+	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
+
+	/* tell ublksrv one io request is coming */
+	io_uring_cmd_done(io->cmd, res, 0);
+}
+
 static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 		const struct blk_mq_queue_data *bd)
 {
@@ -456,30 +486,38 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * If we can't add the task work, something must be wrong, schedule
 	 * monitor work immediately.
 	 */
-	if (task_work_add(ubq->ubq_daemon, &data->work, notify_mode)) {
-		struct ublk_device *ub = rq->q->queuedata;
+	if (ublk_use_task_work(ubq)) {
+		if (task_work_add(ubq->ubq_daemon, &data->work, notify_mode)) {
+			struct ublk_device *ub = rq->q->queuedata;
 
-		mod_delayed_work(system_wq, &ub->monitor_work, 0);
-		return BLK_STS_IOERR;
+			mod_delayed_work(system_wq, &ub->monitor_work, 0);
+			return BLK_STS_IOERR;
+		}
+	} else {
+		if (ubq_daemon_is_dying(ubq)) {
+			struct ublk_device *ub = rq->q->queuedata;
+
+			mod_delayed_work(system_wq, &ub->monitor_work, 0);
+			return BLK_STS_IOERR;
+		}
+
+		ubq_complete_io_cmd(&ubq->ios[rq->tag], UBLK_IO_RES_REFETCH);
 	}
 
 	return BLK_STS_OK;
 }
 
-static bool ubq_daemon_is_dying(struct ublk_queue *ubq)
-{
-	return ubq->ubq_daemon->flags & PF_EXITING;
-}
-
 static void ublk_commit_rqs(struct blk_mq_hw_ctx *hctx)
 {
 	struct ublk_queue *ubq = hctx->driver_data;
 
-	__set_notify_signal(ubq->ubq_daemon);
-	if (ubq_daemon_is_dying(ubq)) {
-		struct ublk_device *ub = hctx->queue->queuedata;
+	if (ublk_use_task_work(ubq)) {
+		__set_notify_signal(ubq->ubq_daemon);
+		if (ubq_daemon_is_dying(ubq)) {
+			struct ublk_device *ub = hctx->queue->queuedata;
 
-		mod_delayed_work(system_wq, &ub->monitor_work, 0);
+			mod_delayed_work(system_wq, &ub->monitor_work, 0);
+		}
 	}
 }
 
@@ -604,17 +642,7 @@ static void ublk_rq_task_work_fn(struct callback_head *work)
 		return;
 	}
 
-	/* mark this cmd owned by ublksrv */
-	io->flags |= UBLK_IO_FLAG_OWNED_BY_SRV;
-
-	/*
-	 * clear ACTIVE since we are done with this sqe/cmd slot
-	 * We can only accept io cmd in case of being not active.
-	 */
-	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
-
-	/* tell ublksrv one io request is coming */
-	io_uring_cmd_done(io->cmd, ret, 0);
+	ubq_complete_io_cmd(io, ret);
 
 	/*
 	 * in case task is exiting, our partner has gone, so schedule monitor
@@ -737,13 +765,26 @@ static void ublk_commit_completion(struct ublk_device *ub,
  * Focus on aborting any in-flight request scheduled to run via task work
  */
 static void __ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
+	__releases(&ubq->abort_lock)
 {
 	bool task_exiting = !!(ubq->ubq_daemon->flags & PF_EXITING);
 	int i;
+	bool quiesced = false;
 
 	if (!task_exiting)
 		goto out;
 
+	/*
+	 * quiesce queue so that we can avoid to race with ublk_queue_rq()
+	 * wrt. dealing with io flags
+	 */
+	if (ubq->flags & UBLK_F_NEED_REFETCH) {
+		spin_unlock(&ubq->abort_lock);
+		blk_mq_quiesce_queue(ub->ub_queue);
+		spin_lock(&ubq->abort_lock);
+		quiesced = true;
+	}
+
 	for (i = 0; i < ubq->q_depth; i++) {
 		struct ublk_io *io = &ubq->ios[i];
 
@@ -759,6 +800,8 @@ static void __ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 				__ublk_fail_req(io, rq);
 		}
 	}
+	if (quiesced)
+		blk_mq_unquiesce_queue(ub->ub_queue);
  out:
 	ubq->abort_work_pending = false;
 	ublk_put_device(ub);
@@ -792,8 +835,12 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 	if (!ubq->abort_work_pending) {
 		ubq->abort_work_pending = true;
 		put_dev = false;
-		if (task_work_add(ubq->ubq_daemon, &ubq->abort_work,
-					TWA_SIGNAL)) {
+		if (ublk_use_task_work(ubq)) {
+			if (task_work_add(ubq->ubq_daemon,
+					  &ubq->abort_work, TWA_SIGNAL)) {
+				__ublk_abort_queue(ub, ubq);
+			}
+		} else {
 			__ublk_abort_queue(ub, ubq);
 		}
 	} else {
@@ -872,6 +919,16 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
 	mutex_unlock(&ub->mutex);
 }
 
+static void ublk_handle_refetch(struct ublk_device *ub,
+		struct ublk_queue *ubq, int tag)
+{
+	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id],
+			tag);
+	struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+
+	ublk_rq_task_work_fn(&data->work);
+}
+
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
@@ -943,6 +1000,15 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		io->cmd = cmd;
 		ublk_commit_completion(ub, ub_cmd);
 		break;
+	case UBLK_IO_REFETCH_REQ:
+		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
+			goto out;
+		io->addr = ub_cmd->addr;
+		io->cmd = cmd;
+		io->flags |= UBLK_IO_FLAG_ACTIVE;
+		io->flags &= ~UBLK_IO_FLAG_OWNED_BY_SRV;
+		ublk_handle_refetch(ub, ubq, tag);
+		break;
 	default:
 		goto out;
 	}
@@ -983,6 +1049,7 @@ static int ublk_init_queue(struct ublk_device *ub, int q_id)
 	void *ptr;
 	int size;
 
+	ubq->flags = ub->dev_info.flags[0];
 	ubq->q_id = q_id;
 	ubq->q_depth = ub->dev_info.queue_depth;
 	size = ublk_queue_cmd_buf_size(ub, q_id);
@@ -1381,6 +1448,8 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_dev_info *info,
 
 		/* update device id */
 		ub->dev_info.dev_id = ub->ub_number;
+		if (IS_MODULE(CONFIG_BLK_DEV_UBLK))
+			ub->dev_info.flags[0] |= UBLK_F_NEED_REFETCH;
 
 		ret = ublk_add_dev(ub);
 		if (!ret) {
diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.h
index 4f0c16ec875e..fe4a2c7c8349 100644
--- a/include/uapi/linux/ublk_cmd.h
+++ b/include/uapi/linux/ublk_cmd.h
@@ -28,12 +28,19 @@
  *      this IO request, request's handling result is committed to ublk
  *      driver, meantime FETCH_REQ is piggyback, and FETCH_REQ has to be
  *      handled before completing io request.
+ *
+ * REFETCH_REQ: issued via sqe(URING_CMD) after ublk driver returns
+ * 	UBLK_IO_REFETCH_REQ, which only purpose is to fetch io request data
+ * 	from the userspace ublk server context in case that task_work_add
+ * 	isn't available because ublk driver is built as module
  */
 #define	UBLK_IO_FETCH_REQ		0x20
 #define	UBLK_IO_COMMIT_AND_FETCH_REQ	0x21
+#define	UBLK_IO_REFETCH_REQ		0x22
 
 /* only ABORT means that no re-fetch */
 #define UBLK_IO_RES_OK			0
+#define UBLK_IO_RES_REFETCH		1
 #define UBLK_IO_RES_ABORT		(-ENODEV)
 
 #define UBLKSRV_CMD_BUF_OFFSET	0
@@ -48,6 +55,16 @@
  */
 #define UBLK_F_SUPPORT_ZERO_COPY	(1UL << 0)
 
+/*
+ * When NEED_REFETCH is set, ublksrv has to issue UBLK_IO_REFETCH_REQ
+ * command after ublk driver returns UBLK_IO_REFETCH_REQ.
+ *
+ * This flag is negotiated during handling UBLK_CMD_ADD_DEV. If ublksrv
+ * sets it, ublk driver can't clear it. But if ublk driver sets it back
+ * to ublksrv, ublksrv has to handle it correctly.
+ */
+#define UBLK_F_NEED_REFETCH		(1UL << 1)
+
 /* device state */
 #define UBLK_S_DEV_DEAD	0
 #define UBLK_S_DEV_LIVE	1
-- 
2.31.1

