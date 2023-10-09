Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187D67BD72F
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 11:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345833AbjJIJgI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 05:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345819AbjJIJgF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 05:36:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F2EE4
        for <io-uring@vger.kernel.org>; Mon,  9 Oct 2023 02:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696844103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JkG471HQUGQOgXNjt7eXYoAUHBPwXZNOYbJ0zPaw2ok=;
        b=K4pnjF43yJCHHVXe/LefbiNMzeFAm4JoWu6A8XA78cYz2rABB8LIzWXxvfYp/HPOmWNJ6z
        tCrR32+TdDTkR0A8IHTNWt9lPisaevnmLHjMyebPZrbzpDFMzTHmc+QFYeN4UwXek6Te9o
        QC8SW+64pUFfa7Ws1/j/SVPVFsjtEVQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-ecvjAjjhPJabhCiZqIT8gA-1; Mon, 09 Oct 2023 05:34:48 -0400
X-MC-Unique: ecvjAjjhPJabhCiZqIT8gA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D8A4381CC10;
        Mon,  9 Oct 2023 09:34:47 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32EE0167F8;
        Mon,  9 Oct 2023 09:34:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-6.7/io_uring 6/7] ublk: replace monitor with cancelable uring_cmd
Date:   Mon,  9 Oct 2023 17:33:21 +0800
Message-ID: <20231009093324.957829-7-ming.lei@redhat.com>
In-Reply-To: <20231009093324.957829-1-ming.lei@redhat.com>
References: <20231009093324.957829-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Monitor work actually introduces one extra context for handling abort, this
way is easy to cause race, and also introduce extra delay when handling
aborting.

Now we start to support cancelable uring_cmd, so use it instead:

1) this cancel callback is either run from the uring cmd submission task
context or called after the io_uring context is exit, so the callback is
run exclusively with ublk_ch_uring_cmd() and __ublk_rq_task_work().

2) the previous patch freezes request queue when calling ublk_abort_queue(),
which is now completely exclusive with ublk_queue_rq() and
ublk_ch_uring_cmd()/__ublk_rq_task_work().

3) in timeout handler, if all IOs are in-flight, then all uring commands
are completed, uring command canceling can't help us to provide forward
progress any more, so call ublk_abort_requests() in timeout handler.

This way simplifies aborting queue, and is helpful for adding new feature,
such as, relax the limit of using single task for handling one queue.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 208 ++++++++++++++++++++++-----------------
 1 file changed, 119 insertions(+), 89 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index e8d52cd7b226..75ed7b87a844 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -75,6 +75,7 @@ struct ublk_rq_data {
 
 struct ublk_uring_cmd_pdu {
 	struct ublk_queue *ubq;
+	u16 tag;
 };
 
 /*
@@ -141,14 +142,13 @@ struct ublk_queue {
 	unsigned int max_io_sz;
 	bool force_abort;
 	bool timeout;
+	bool canceling;
 	unsigned short nr_io_ready;	/* how many ios setup */
 	spinlock_t		cancel_lock;
 	struct ublk_device *dev;
 	struct ublk_io ios[];
 };
 
-#define UBLK_DAEMON_MONITOR_PERIOD	(5 * HZ)
-
 struct ublk_device {
 	struct gendisk		*ub_disk;
 
@@ -179,11 +179,6 @@ struct ublk_device {
 	unsigned int		nr_queues_ready;
 	unsigned int		nr_privileged_daemon;
 
-	/*
-	 * Our ubq->daemon may be killed without any notification, so
-	 * monitor each queue's daemon periodically
-	 */
-	struct delayed_work	monitor_work;
 	struct work_struct	quiesce_work;
 	struct work_struct	stop_work;
 };
@@ -194,10 +189,11 @@ struct ublk_params_header {
 	__u32	types;
 };
 
+static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq);
+
 static inline unsigned int ublk_req_build_flags(struct request *req);
 static inline struct ublksrv_io_desc *ublk_get_iod(struct ublk_queue *ubq,
 						   int tag);
-
 static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
 {
 	return ub->dev_info.flags & UBLK_F_USER_COPY;
@@ -1122,8 +1118,6 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 		blk_mq_requeue_request(rq, false);
 	else
 		blk_mq_end_request(rq, BLK_STS_IOERR);
-
-	mod_delayed_work(system_wq, &ubq->dev->monitor_work, 0);
 }
 
 static inline void __ublk_rq_task_work(struct request *req,
@@ -1244,12 +1238,12 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 	io = &ubq->ios[rq->tag];
 	/*
 	 * If the check pass, we know that this is a re-issued request aborted
-	 * previously in monitor_work because the ubq_daemon(cmd's task) is
+	 * previously in cancel fn because the ubq_daemon(cmd's task) is
 	 * PF_EXITING. We cannot call io_uring_cmd_complete_in_task() anymore
 	 * because this ioucmd's io_uring context may be freed now if no inflight
 	 * ioucmd exists. Otherwise we may cause null-deref in ctx->fallback_work.
 	 *
-	 * Note: monitor_work sets UBLK_IO_FLAG_ABORTED and ends this request(releasing
+	 * Note: cancel fn sets UBLK_IO_FLAG_ABORTED and ends this request(releasing
 	 * the tag). Then the request is re-started(allocating the tag) and we are here.
 	 * Since releasing/allocating a tag implies smp_mb(), finding UBLK_IO_FLAG_ABORTED
 	 * guarantees that here is a re-issued request aborted previously.
@@ -1257,17 +1251,15 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
 	if (unlikely(io->flags & UBLK_IO_FLAG_ABORTED)) {
 		ublk_abort_io_cmds(ubq);
 	} else {
-		struct io_uring_cmd *cmd = io->cmd;
-		struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
-
-		pdu->ubq = ubq;
-		io_uring_cmd_complete_in_task(cmd, ublk_rq_task_work_cb);
+		io_uring_cmd_complete_in_task(io->cmd, ublk_rq_task_work_cb);
 	}
 }
 
 static enum blk_eh_timer_return ublk_timeout(struct request *rq)
 {
 	struct ublk_queue *ubq = rq->mq_hctx->driver_data;
+	unsigned int nr_inflight = 0;
+	int i;
 
 	if (ubq->flags & UBLK_F_UNPRIVILEGED_DEV) {
 		if (!ubq->timeout) {
@@ -1278,6 +1270,29 @@ static enum blk_eh_timer_return ublk_timeout(struct request *rq)
 		return BLK_EH_DONE;
 	}
 
+	if (!ubq_daemon_is_dying(ubq))
+		return BLK_EH_RESET_TIMER;
+
+	for (i = 0; i < ubq->q_depth; i++) {
+		struct ublk_io *io = &ubq->ios[i];
+
+		if (!(io->flags & UBLK_IO_FLAG_ACTIVE))
+			nr_inflight++;
+	}
+
+	/* cancelable uring_cmd can't help us if all commands are in-flight */
+	if (nr_inflight == ubq->q_depth) {
+		struct ublk_device *ub = ubq->dev;
+
+		if (ublk_abort_requests(ub, ubq)) {
+			if (ublk_can_use_recovery(ub))
+				schedule_work(&ub->quiesce_work);
+			else
+				schedule_work(&ub->stop_work);
+		}
+		return BLK_EH_DONE;
+	}
+
 	return BLK_EH_RESET_TIMER;
 }
 
@@ -1307,7 +1322,7 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	blk_mq_start_request(bd->rq);
 
-	if (unlikely(ubq_daemon_is_dying(ubq))) {
+	if (unlikely(ubq->canceling)) {
 		__ublk_abort_rq(ubq, rq);
 		return BLK_STS_OK;
 	}
@@ -1415,9 +1430,9 @@ static void ublk_commit_completion(struct ublk_device *ub,
 }
 
 /*
- * When ->ubq_daemon is exiting, either new request is ended immediately,
- * or any queued io command is drained, so it is safe to abort queue
- * lockless
+ * Called from ubq_daemon context via cancel fn, meantime quiesce ublk
+ * blk-mq queue, so we are called exclusively with blk-mq and ubq_daemon
+ * context, so everything is serialized.
  */
 static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 {
@@ -1440,10 +1455,17 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 	}
 }
 
-static bool ublk_abort_requests(struct ublk_device *ub)
+static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
 {
 	struct gendisk *disk;
-	int i;
+
+	spin_lock(&ubq->cancel_lock);
+	if (ubq->canceling) {
+		spin_unlock(&ubq->cancel_lock);
+		return false;
+	}
+	ubq->canceling = true;
+	spin_unlock(&ubq->cancel_lock);
 
 	spin_lock(&ub->lock);
 	disk = ub->ub_disk;
@@ -1457,53 +1479,69 @@ static bool ublk_abort_requests(struct ublk_device *ub)
 
 	/* Now we are serialized with ublk_queue_rq() */
 	blk_mq_quiesce_queue(disk->queue);
-	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
-		struct ublk_queue *ubq = ublk_get_queue(ub, i);
-
-		if (ubq_daemon_is_dying(ubq)) {
-			/* abort queue is for making forward progress */
-			ublk_abort_queue(ub, ubq);
-		}
-	}
+	/* abort queue is for making forward progress */
+	ublk_abort_queue(ub, ubq);
 	blk_mq_unquiesce_queue(disk->queue);
 	put_device(disk_to_dev(disk));
 
 	return true;
 }
 
-static void ublk_daemon_monitor_work(struct work_struct *work)
+static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
+		unsigned int issue_flags)
 {
-	struct ublk_device *ub =
-		container_of(work, struct ublk_device, monitor_work.work);
-	int i;
+	bool done;
 
-	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
-		struct ublk_queue *ubq = ublk_get_queue(ub, i);
+	if (!(io->flags & UBLK_IO_FLAG_ACTIVE))
+		return;
 
-		if (ubq_daemon_is_dying(ubq))
-			goto found;
-	}
-	return;
+	spin_lock(&ubq->cancel_lock);
+	done = !!(io->flags & UBLK_IO_FLAG_CANCELED);
+	if (!done)
+		io->flags |= UBLK_IO_FLAG_CANCELED;
+	spin_unlock(&ubq->cancel_lock);
+
+	if (!done)
+		io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
+}
+
+/*
+ * The ublk char device won't be closed when calling cancel fn, so both
+ * ublk device and queue are guaranteed to be live
+ */
+static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
+	struct ublk_queue *ubq = pdu->ubq;
+	struct task_struct *task;
+	struct ublk_device *ub;
+	bool need_schedule;
+	struct ublk_io *io;
 
-found:
-	if (!ublk_abort_requests(ub))
+	if (WARN_ON_ONCE(!ubq))
 		return;
 
-	if (ublk_can_use_recovery(ub))
-		schedule_work(&ub->quiesce_work);
-	else
-		schedule_work(&ub->stop_work);
+	if (WARN_ON_ONCE(pdu->tag >= ubq->q_depth))
+		return;
 
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
+	task = io_uring_cmd_get_task(cmd);
+	if (WARN_ON_ONCE(task && task != ubq->ubq_daemon))
+		return;
+
+	ub = ubq->dev;
+	need_schedule = ublk_abort_requests(ub, ubq);
+
+	io = &ubq->ios[pdu->tag];
+	WARN_ON_ONCE(io->cmd != cmd);
+	ublk_cancel_cmd(ubq, &ubq->ios[pdu->tag], issue_flags);
+
+	if (need_schedule) {
+		if (ublk_can_use_recovery(ub))
+			schedule_work(&ub->quiesce_work);
+		else
+			schedule_work(&ub->stop_work);
+	}
 }
 
 static inline bool ublk_queue_ready(struct ublk_queue *ubq)
@@ -1515,24 +1553,8 @@ static void ublk_cancel_queue(struct ublk_queue *ubq)
 {
 	int i;
 
-	for (i = 0; i < ubq->q_depth; i++) {
-		struct ublk_io *io = &ubq->ios[i];
-
-		if (io->flags & UBLK_IO_FLAG_ACTIVE) {
-			bool done;
-
-			spin_lock(&ubq->cancel_lock);
-			done = !!(io->flags & UBLK_IO_FLAG_CANCELED);
-			if (!done)
-				io->flags |= UBLK_IO_FLAG_CANCELED;
-			spin_unlock(&ubq->cancel_lock);
-
-			if (!done)
-				io_uring_cmd_done(io->cmd,
-						UBLK_IO_RES_ABORT, 0,
-						IO_URING_F_UNLOCKED);
-		}
-	}
+	for (i = 0; i < ubq->q_depth; i++)
+		ublk_cancel_cmd(ubq, &ubq->ios[i], IO_URING_F_UNLOCKED);
 }
 
 /* Cancel all pending commands, must be called after del_gendisk() returns */
@@ -1579,15 +1601,6 @@ static void __ublk_quiesce_dev(struct ublk_device *ub)
 	blk_mq_quiesce_queue(ub->ub_disk->queue);
 	ublk_wait_tagset_rqs_idle(ub);
 	ub->dev_info.state = UBLK_S_DEV_QUIESCED;
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
@@ -1650,7 +1663,6 @@ static void ublk_stop_dev(struct ublk_device *ub)
  unlock:
 	mutex_unlock(&ub->mutex);
 	ublk_cancel_dev(ub);
-	cancel_delayed_work_sync(&ub->monitor_work);
 }
 
 /* device can only be started after all IOs are ready */
@@ -1701,6 +1713,21 @@ static inline void ublk_fill_io_cmd(struct ublk_io *io,
 	io->addr = buf_addr;
 }
 
+static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
+				    unsigned int issue_flags,
+				    struct ublk_queue *ubq, unsigned int tag)
+{
+	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
+
+	/*
+	 * Safe to refer to @ubq since ublk_queue won't be died until its
+	 * commands are completed
+	 */
+	pdu->ubq = ubq;
+	pdu->tag = tag;
+	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+}
+
 static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 			       unsigned int issue_flags,
 			       const struct ublksrv_io_cmd *ub_cmd)
@@ -1816,6 +1843,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 	default:
 		goto out;
 	}
+	ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 	return -EIOCBQUEUED;
 
  out:
@@ -1883,6 +1911,11 @@ static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
 
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
+	if (unlikely(issue_flags & IO_URING_F_CANCEL)) {
+		ublk_uring_cmd_cancel_fn(cmd, issue_flags);
+		return 0;
+	}
+
 	/* well-implemented server won't run into unlocked */
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_uring_cmd_complete_in_task(cmd, ublk_ch_uring_cmd_cb);
@@ -2213,8 +2246,6 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 	if (wait_for_completion_interruptible(&ub->completion) != 0)
 		return -EINTR;
 
-	schedule_delayed_work(&ub->monitor_work, UBLK_DAEMON_MONITOR_PERIOD);
-
 	mutex_lock(&ub->mutex);
 	if (ub->dev_info.state == UBLK_S_DEV_LIVE ||
 	    test_bit(UB_STATE_USED, &ub->state)) {
@@ -2385,7 +2416,6 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	spin_lock_init(&ub->lock);
 	INIT_WORK(&ub->quiesce_work, ublk_quiesce_work_fn);
 	INIT_WORK(&ub->stop_work, ublk_stop_work_fn);
-	INIT_DELAYED_WORK(&ub->monitor_work, ublk_daemon_monitor_work);
 
 	ret = ublk_alloc_dev_number(ub, header->dev_id);
 	if (ret < 0)
@@ -2639,6 +2669,7 @@ static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
 	/* We have to reset it to NULL, otherwise ub won't accept new FETCH_REQ */
 	ubq->ubq_daemon = NULL;
 	ubq->timeout = false;
+	ubq->canceling = false;
 
 	for (i = 0; i < ubq->q_depth; i++) {
 		struct ublk_io *io = &ubq->ios[i];
@@ -2724,7 +2755,6 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 			__func__, header->dev_id);
 	blk_mq_kick_requeue_list(ub->ub_disk->queue);
 	ub->dev_info.state = UBLK_S_DEV_LIVE;
-	schedule_delayed_work(&ub->monitor_work, UBLK_DAEMON_MONITOR_PERIOD);
 	ret = 0;
  out_unlock:
 	mutex_unlock(&ub->mutex);
-- 
2.41.0

