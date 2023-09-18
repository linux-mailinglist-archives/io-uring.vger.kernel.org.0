Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B76F7A3FEF
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbjIRENb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239498AbjIRENE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:13:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A45133
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YRG0DD08DVTXjsynnmBGtcrnrZop7rwgneNtLdOiHFs=;
        b=Gv1U4Gw2Iwbi0gXXrYCqrp1Po59w0PreZirarpS6epKqOdZpgDhkQxqcdJ+bscuNZSQ1sY
        VyUhsYqfZJ3jCLQpejdcon8foBABrRNq3LyaiLa64tgflgOEtlOKrmKX/s5QuN/itV80JS
        H1/bu1qGy6uzjFm3GByBW7WxHqRH7gc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-rwabaOyeOm-jyuK2eAP3KQ-1; Mon, 18 Sep 2023 00:11:57 -0400
X-MC-Unique: rwabaOyeOm-jyuK2eAP3KQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C90A51875054;
        Mon, 18 Sep 2023 04:11:56 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA9BB10F1BE9;
        Mon, 18 Sep 2023 04:11:55 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 09/10] ublk: replace monitor work with uring_cmd exit notifier
Date:   Mon, 18 Sep 2023 12:11:05 +0800
Message-Id: <20230918041106.2134250-10-ming.lei@redhat.com>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Monitor work actually introduces one extra context for handling abort, this
way is easy to cause race, and also introduce extra delay when handling
aborting.

Now uring_cmd introduces exit notifier, so use it instead:

1) this notifier callback is either run from the uring cmd submission task
context or called after the io_uring context is exit, so the callback is
run exclusively with ublk_ch_uring_cmd() and __ublk_rq_task_work().

2) the previous patch freezes request queue when calling ublk_abort_queue(),
which is now completely exclusive with ublk_queue_rq() and
ublk_ch_uring_cmd()/__ublk_rq_task_work().

This way simplifies aborting queue, and is helpful for adding new feature,
such as, relax the limit of using single task for handling one queue.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 89 +++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 3b691bf3d9ef..90e0137ff784 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -144,8 +144,6 @@ struct ublk_queue {
 	struct ublk_io ios[];
 };
 
-#define UBLK_DAEMON_MONITOR_PERIOD	(5 * HZ)
-
 struct ublk_device {
 	struct gendisk		*ub_disk;
 
@@ -176,11 +174,7 @@ struct ublk_device {
 	unsigned int		nr_queues_ready;
 	unsigned int		nr_privileged_daemon;
 
-	/*
-	 * Our ubq->daemon may be killed without any notification, so
-	 * monitor each queue's daemon periodically
-	 */
-	struct delayed_work	monitor_work;
+	struct notifier_block	notif;
 	struct work_struct	quiesce_work;
 	struct work_struct	stop_work;
 };
@@ -194,7 +188,6 @@ struct ublk_params_header {
 static inline unsigned int ublk_req_build_flags(struct request *req);
 static inline struct ublksrv_io_desc *ublk_get_iod(struct ublk_queue *ubq,
 						   int tag);
-
 static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
 {
 	return ub->dev_info.flags & UBLK_F_USER_COPY;
@@ -1119,8 +1112,6 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 		blk_mq_requeue_request(rq, false);
 	else
 		blk_mq_end_request(rq, BLK_STS_IOERR);
-
-	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }
 
 static inline void __ublk_rq_task_work(struct request *req,
@@ -1241,12 +1232,12 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 	io = &ubq->ios[rq->tag];
 	/*
 	 * If the check pass, we know that this is a re-issued request aborted
-	 * previously in monitor_work because the ubq_daemon(cmd's task) is
+	 * previously in exit notifier because the ubq_daemon(cmd's task) is
 	 * PF_EXITING. We cannot call io_uring_cmd_complete_in_task() anymore
 	 * because this ioucmd's io_uring context may be freed now if no inflight
 	 * ioucmd exists. Otherwise we may cause null-deref in ctx->fallback_work.
 	 *
-	 * Note: monitor_work sets UBLK_IO_FLAG_ABORTED and ends this request(releasing
+	 * Note: exit notifier sets UBLK_IO_FLAG_ABORTED and ends this request(releasing
 	 * the tag). Then the request is re-started(allocating the tag) and we are here.
 	 * Since releasing/allocating a tag implies smp_mb(), finding UBLK_IO_FLAG_ABORTED
 	 * guarantees that here is a re-issued request aborted previously.
@@ -1334,9 +1325,17 @@ static int ublk_ch_open(struct inode *inode, struct file *filp)
 {
 	struct ublk_device *ub = container_of(inode->i_cdev,
 			struct ublk_device, cdev);
+	int ret;
 
 	if (test_and_set_bit(UB_STATE_OPEN, &ub->state))
 		return -EBUSY;
+
+	ret = io_uring_cmd_register_notifier(&ub->notif);
+	if (ret) {
+		clear_bit(UB_STATE_OPEN, &ub->state);
+		return ret;
+	}
+
 	filp->private_data = ub;
 	return 0;
 }
@@ -1346,6 +1345,8 @@ static int ublk_ch_release(struct inode *inode, struct file *filp)
 	struct ublk_device *ub = filp->private_data;
 
 	clear_bit(UB_STATE_OPEN, &ub->state);
+	io_uring_cmd_unregister_notifier(&ub->notif);
+
 	return 0;
 }
 
@@ -1417,9 +1418,9 @@ static inline bool ublk_ctx_id_is_valid(unsigned int ctx_id)
 }
 
 /*
- * When ->ubq_daemon is exiting, either new request is ended immediately,
- * or any queued io command is drained, so it is safe to abort queue
- * lockless
+ * Called from ubq_daemon context via the notifier, meantime quiesce ublk
+ * blk-mq queue, so we are called exclusively with blk-mq and ubq_daemon
+ * context, so everything is serialized.
  */
 static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 {
@@ -1442,20 +1443,34 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 	}
 }
 
-static void ublk_daemon_monitor_work(struct work_struct *work)
+static inline bool ubq_daemon_is_exiting(const struct ublk_queue *ubq,
+		const struct io_uring_notifier_data *data)
 {
-	struct ublk_device *ub =
-		container_of(work, struct ublk_device, monitor_work.work);
+	return data->ctx_id == ubq->ctx_id && (!data->task ||
+			data->task == ubq->ubq_daemon);
+}
+
+static int ublk_notifier_cb(struct notifier_block *nb,
+		unsigned long event, void *val)
+{
+	struct ublk_device *ub = container_of(nb, struct ublk_device, notif);
+	struct io_uring_notifier_data *data = val;
 	struct gendisk *disk;
 	int i;
 
+	pr_devel("%s: event %lu ctx_id %u task %p\n", __func__, event,
+			data->ctx_id, data->task);
+
+	if (!ublk_ctx_id_is_valid(data->ctx_id))
+		return 0;
+
 	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
 		struct ublk_queue *ubq = ublk_get_queue(ub, i);
 
-		if (ubq_daemon_is_dying(ubq))
+		if (ubq_daemon_is_exiting(ubq, data))
 			goto found;
 	}
-	return;
+	return 0;
 
 found:
 	spin_lock(&ub->lock);
@@ -1466,14 +1481,14 @@ static void ublk_daemon_monitor_work(struct work_struct *work)
 
 	/* Our disk has been dead */
 	if (!disk)
-		return;
+		return 0;
 
 	/* Now we are serialized with ublk_queue_rq() */
 	blk_mq_quiesce_queue(disk->queue);
 	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
 		struct ublk_queue *ubq = ublk_get_queue(ub, i);
 
-		if (ubq_daemon_is_dying(ubq)) {
+		if (ubq_daemon_is_exiting(ubq, data)) {
 			/* abort queue is for making forward progress */
 			ublk_abort_queue(ub, ubq);
 		}
@@ -1485,17 +1500,7 @@ static void ublk_daemon_monitor_work(struct work_struct *work)
 		schedule_work(&ub->quiesce_work);
 	else
 		schedule_work(&ub->stop_work);
-
-	/*
-	 * We can't schedule monitor work after ub's state is not UBLK_S_DEV_LIVE.
-	 * after ublk_remove() or __ublk_quiesce_dev() is started.
-	 *
-	 * No need ub->mutex, monitor work are canceled after state is marked
-	 * as not LIVE, so new state is observed reliably.
-	 */
-	if (ub->dev_info.state == UBLK_S_DEV_LIVE)
-		schedule_delayed_work(&ub->monitor_work,
-				UBLK_DAEMON_MONITOR_PERIOD);
+	return 0;
 }
 
 static inline bool ublk_queue_ready(struct ublk_queue *ubq)
@@ -1512,6 +1517,9 @@ static void ublk_cancel_queue(struct ublk_queue *ubq)
 {
 	int i;
 
+	if (ublk_ctx_id_is_valid(ubq->ctx_id))
+		ubq->ctx_id = IO_URING_INVALID_CTX_ID;
+
 	if (!ublk_queue_ready(ubq))
 		return;
 
@@ -1572,15 +1580,6 @@ static void __ublk_quiesce_dev(struct ublk_device *ub)
 	ublk_wait_tagset_rqs_idle(ub);
 	ub->dev_info.state = UBLK_S_DEV_QUIESCED;
 	ublk_cancel_dev(ub);
-	/* we are going to release task_struct of ubq_daemon and resets
-	 * ->ubq_daemon to NULL. So in monitor_work, check on ubq_daemon causes UAF.
-	 * Besides, monitor_work is not necessary in QUIESCED state since we have
-	 * already scheduled quiesce_work and quiesced all ubqs.
-	 *
-	 * Do not let monitor_work schedule itself if state it QUIESCED. And we cancel
-	 * it here and re-schedule it in END_USER_RECOVERY to avoid UAF.
-	 */
-	cancel_delayed_work_sync(&ub->monitor_work);
 }
 
 static void ublk_quiesce_work_fn(struct work_struct *work)
@@ -1642,7 +1641,6 @@ static void ublk_stop_dev(struct ublk_device *ub)
  unlock:
 	ublk_cancel_dev(ub);
 	mutex_unlock(&ub->mutex);
-	cancel_delayed_work_sync(&ub->monitor_work);
 }
 
 /* device can only be started after all IOs are ready */
@@ -2210,8 +2208,6 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 	if (wait_for_completion_interruptible(&ub->completion) != 0)
 		return -EINTR;
 
-	schedule_delayed_work(&ub->monitor_work, UBLK_DAEMON_MONITOR_PERIOD);
-
 	mutex_lock(&ub->mutex);
 	if (ub->dev_info.state == UBLK_S_DEV_LIVE ||
 	    test_bit(UB_STATE_USED, &ub->state)) {
@@ -2382,7 +2378,7 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	spin_lock_init(&ub->lock);
 	INIT_WORK(&ub->quiesce_work, ublk_quiesce_work_fn);
 	INIT_WORK(&ub->stop_work, ublk_stop_work_fn);
-	INIT_DELAYED_WORK(&ub->monitor_work, ublk_daemon_monitor_work);
+	ub->notif.notifier_call = ublk_notifier_cb;
 
 	ret = ublk_alloc_dev_number(ub, header->dev_id);
 	if (ret < 0)
@@ -2722,7 +2718,6 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 			__func__, header->dev_id);
 	blk_mq_kick_requeue_list(ub->ub_disk->queue);
 	ub->dev_info.state = UBLK_S_DEV_LIVE;
-	schedule_delayed_work(&ub->monitor_work, UBLK_DAEMON_MONITOR_PERIOD);
 	ret = 0;
  out_unlock:
 	mutex_unlock(&ub->mutex);
-- 
2.40.1

