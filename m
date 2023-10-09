Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A900C7BD728
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 11:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345799AbjJIJgD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 05:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345775AbjJIJgD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 05:36:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B70B9
        for <io-uring@vger.kernel.org>; Mon,  9 Oct 2023 02:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696844080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hy3J/yvb0KfYJNvwsfix6gMHGkLxfT8yOe7cLSEhwSo=;
        b=AzUEXSARo0mOYKR19FVCVQCoKNWJYnn4w3Dhlx5WSuSuRAgsn6nuGXUnWrM1uImHybSPpK
        y0gAIozrlWnis0+B2AUY5JymKKLL3W2OY6cKgIPGwPra8Tr/53oZNk4/Vyv/23qPAOrnfL
        vN37xS5ehIYkJ98JZ3LBFhNWzmMoes8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-hpELf4TGM7uOPn06y1prwg-1; Mon, 09 Oct 2023 05:34:37 -0400
X-MC-Unique: hpELf4TGM7uOPn06y1prwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CD263C025A2;
        Mon,  9 Oct 2023 09:34:36 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F1AE2027045;
        Mon,  9 Oct 2023 09:34:35 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-6.7/io_uring 3/7] ublk: move ublk_cancel_dev() out of ub->mutex
Date:   Mon,  9 Oct 2023 17:33:18 +0800
Message-ID: <20231009093324.957829-4-ming.lei@redhat.com>
In-Reply-To: <20231009093324.957829-1-ming.lei@redhat.com>
References: <20231009093324.957829-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ublk_cancel_dev() just calls ublk_cancel_queue() to cancel all pending
io commands after ublk request queue is idle. The only protection is just
the read & write of ubq->nr_io_ready and avoid duplicated command cancel,
so add one per-queue lock with cancel flag for providing this protection,
meantime move ublk_cancel_dev() out of ub->mutex.

Then we needn't to call io_uring_cmd_complete_in_task() to cancel
pending command. And the same cancel logic will be re-used for
cancelable uring command.

This patch basically reverts commit ac5902f84bb5 ("ublk: fix AB-BA lockdep warning").

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 46d499d96ca3..15b52210488a 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -115,6 +115,9 @@ struct ublk_uring_cmd_pdu {
  */
 #define UBLK_IO_FLAG_NEED_GET_DATA 0x08
 
+/* atomic RW with ubq->cancel_lock */
+#define UBLK_IO_FLAG_CANCELED	0x80000000
+
 struct ublk_io {
 	/* userspace buffer address from io cmd */
 	__u64	addr;
@@ -139,6 +142,7 @@ struct ublk_queue {
 	bool force_abort;
 	bool timeout;
 	unsigned short nr_io_ready;	/* how many ios setup */
+	spinlock_t		cancel_lock;
 	struct ublk_device *dev;
 	struct ublk_io ios[];
 };
@@ -1473,28 +1477,28 @@ static inline bool ublk_queue_ready(struct ublk_queue *ubq)
 	return ubq->nr_io_ready == ubq->q_depth;
 }
 
-static void ublk_cmd_cancel_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
-{
-	io_uring_cmd_done(cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
-}
-
 static void ublk_cancel_queue(struct ublk_queue *ubq)
 {
 	int i;
 
-	if (!ublk_queue_ready(ubq))
-		return;
-
 	for (i = 0; i < ubq->q_depth; i++) {
 		struct ublk_io *io = &ubq->ios[i];
 
-		if (io->flags & UBLK_IO_FLAG_ACTIVE)
-			io_uring_cmd_complete_in_task(io->cmd,
-						      ublk_cmd_cancel_cb);
-	}
+		if (io->flags & UBLK_IO_FLAG_ACTIVE) {
+			bool done;
 
-	/* all io commands are canceled */
-	ubq->nr_io_ready = 0;
+			spin_lock(&ubq->cancel_lock);
+			done = !!(io->flags & UBLK_IO_FLAG_CANCELED);
+			if (!done)
+				io->flags |= UBLK_IO_FLAG_CANCELED;
+			spin_unlock(&ubq->cancel_lock);
+
+			if (!done)
+				io_uring_cmd_done(io->cmd,
+						UBLK_IO_RES_ABORT, 0,
+						IO_URING_F_UNLOCKED);
+		}
+	}
 }
 
 /* Cancel all pending commands, must be called after del_gendisk() returns */
@@ -1541,7 +1545,6 @@ static void __ublk_quiesce_dev(struct ublk_device *ub)
 	blk_mq_quiesce_queue(ub->ub_disk->queue);
 	ublk_wait_tagset_rqs_idle(ub);
 	ub->dev_info.state = UBLK_S_DEV_QUIESCED;
-	ublk_cancel_dev(ub);
 	/* we are going to release task_struct of ubq_daemon and resets
 	 * ->ubq_daemon to NULL. So in monitor_work, check on ubq_daemon causes UAF.
 	 * Besides, monitor_work is not necessary in QUIESCED state since we have
@@ -1564,6 +1567,7 @@ static void ublk_quiesce_work_fn(struct work_struct *work)
 	__ublk_quiesce_dev(ub);
  unlock:
 	mutex_unlock(&ub->mutex);
+	ublk_cancel_dev(ub);
 }
 
 static void ublk_unquiesce_dev(struct ublk_device *ub)
@@ -1603,8 +1607,8 @@ static void ublk_stop_dev(struct ublk_device *ub)
 	put_disk(ub->ub_disk);
 	ub->ub_disk = NULL;
  unlock:
-	ublk_cancel_dev(ub);
 	mutex_unlock(&ub->mutex);
+	ublk_cancel_dev(ub);
 	cancel_delayed_work_sync(&ub->monitor_work);
 }
 
@@ -1978,6 +1982,7 @@ static int ublk_init_queue(struct ublk_device *ub, int q_id)
 	void *ptr;
 	int size;
 
+	spin_lock_init(&ubq->cancel_lock);
 	ubq->flags = ub->dev_info.flags;
 	ubq->q_id = q_id;
 	ubq->q_depth = ub->dev_info.queue_depth;
@@ -2585,8 +2590,9 @@ static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
 	int i;
 
 	WARN_ON_ONCE(!(ubq->ubq_daemon && ubq_daemon_is_dying(ubq)));
+
 	/* All old ioucmds have to be completed */
-	WARN_ON_ONCE(ubq->nr_io_ready);
+	ubq->nr_io_ready = 0;
 	/* old daemon is PF_EXITING, put it now */
 	put_task_struct(ubq->ubq_daemon);
 	/* We have to reset it to NULL, otherwise ub won't accept new FETCH_REQ */
-- 
2.41.0

