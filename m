Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5337BD72A
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 11:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345775AbjJIJgG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 05:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345800AbjJIJgF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 05:36:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAC4C6
        for <io-uring@vger.kernel.org>; Mon,  9 Oct 2023 02:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696844085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iORPmUdveCXK71IAfleFJmUzvMnWnU8t382yX/ZIa+8=;
        b=YArHxLETFPu1fazq3iK6xdjAX6gYj3LijKBbj1AvlxbSc++gtHaPBNbRTXqfPBBi7X/dG1
        TSizsh77X9rJUSt0eQum86sdFsNeTUntmTbAqCgYe5MSPzAh1Z5EfL6GX0PrRoBhrw5C6x
        LZE8rXMo7x37HJq1jg5n5Rm7yjMDEDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-GN1A-iNFOLKEc4Xb3fWL8g-1; Mon, 09 Oct 2023 05:34:43 -0400
X-MC-Unique: GN1A-iNFOLKEc4Xb3fWL8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F887805B32;
        Mon,  9 Oct 2023 09:34:43 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9086010EE859;
        Mon,  9 Oct 2023 09:34:42 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-6.7/io_uring 5/7] ublk: quiesce request queue when aborting queue
Date:   Mon,  9 Oct 2023 17:33:20 +0800
Message-ID: <20231009093324.957829-6-ming.lei@redhat.com>
In-Reply-To: <20231009093324.957829-1-ming.lei@redhat.com>
References: <20231009093324.957829-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

So far aborting queue ends request when the ubq daemon is exiting, and
it can be run concurrently with ublk_queue_rq(), this way is fragile and
we depend on the tricky usage of UBLK_IO_FLAG_ABORTED for avoiding such
race.

Quiesce queue when aborting queue, and the two code paths can be run
completely exclusively, then it becomes easier to add new ublk feature,
such as relaxing single same task limit for each queue.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 59 ++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index ab8828ab3a0c..e8d52cd7b226 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1440,25 +1440,59 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 	}
 }
 
-static void ublk_daemon_monitor_work(struct work_struct *work)
+static bool ublk_abort_requests(struct ublk_device *ub)
 {
-	struct ublk_device *ub =
-		container_of(work, struct ublk_device, monitor_work.work);
+	struct gendisk *disk;
 	int i;
 
+	spin_lock(&ub->lock);
+	disk = ub->ub_disk;
+	if (disk)
+		get_device(disk_to_dev(disk));
+	spin_unlock(&ub->lock);
+
+	/* Our disk has been dead */
+	if (!disk)
+		return false;
+
+	/* Now we are serialized with ublk_queue_rq() */
+	blk_mq_quiesce_queue(disk->queue);
 	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
 		struct ublk_queue *ubq = ublk_get_queue(ub, i);
 
 		if (ubq_daemon_is_dying(ubq)) {
-			if (ublk_queue_can_use_recovery(ubq))
-				schedule_work(&ub->quiesce_work);
-			else
-				schedule_work(&ub->stop_work);
-
 			/* abort queue is for making forward progress */
 			ublk_abort_queue(ub, ubq);
 		}
 	}
+	blk_mq_unquiesce_queue(disk->queue);
+	put_device(disk_to_dev(disk));
+
+	return true;
+}
+
+static void ublk_daemon_monitor_work(struct work_struct *work)
+{
+	struct ublk_device *ub =
+		container_of(work, struct ublk_device, monitor_work.work);
+	int i;
+
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
+		struct ublk_queue *ubq = ublk_get_queue(ub, i);
+
+		if (ubq_daemon_is_dying(ubq))
+			goto found;
+	}
+	return;
+
+found:
+	if (!ublk_abort_requests(ub))
+		return;
+
+	if (ublk_can_use_recovery(ub))
+		schedule_work(&ub->quiesce_work);
+	else
+		schedule_work(&ub->stop_work);
 
 	/*
 	 * We can't schedule monitor work after ub's state is not UBLK_S_DEV_LIVE.
@@ -1593,6 +1627,8 @@ static void ublk_unquiesce_dev(struct ublk_device *ub)
 
 static void ublk_stop_dev(struct ublk_device *ub)
 {
+	struct gendisk *disk;
+
 	mutex_lock(&ub->mutex);
 	if (ub->dev_info.state == UBLK_S_DEV_DEAD)
 		goto unlock;
@@ -1602,10 +1638,15 @@ static void ublk_stop_dev(struct ublk_device *ub)
 		ublk_unquiesce_dev(ub);
 	}
 	del_gendisk(ub->ub_disk);
+
+	/* Sync with ublk_abort_queue() by holding the lock */
+	spin_lock(&ub->lock);
+	disk = ub->ub_disk;
 	ub->dev_info.state = UBLK_S_DEV_DEAD;
 	ub->dev_info.ublksrv_pid = -1;
-	put_disk(ub->ub_disk);
 	ub->ub_disk = NULL;
+	spin_unlock(&ub->lock);
+	put_disk(disk);
  unlock:
 	mutex_unlock(&ub->mutex);
 	ublk_cancel_dev(ub);
-- 
2.41.0

