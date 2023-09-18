Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272C27A3FEE
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbjIRENa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbjIRENC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F71132
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e772wTQJHJwxBOXO8UBygjxubDYmCkNIw23G8H1LTp0=;
        b=Y6zOXeW+2QR/SM1NIDD5omrywsE50szG6SPkNVBZNNbbZNpiGz4LWo+qDEbdbdZtZ12GmD
        0wIOtzg/aALog6FCa4RkcZK6jU0QEZpGGt/uFdyO4iCWBibO/EJOVN0fXwflzni5OSb35c
        NY11/+Zf9zmTCsjpVe5CNqgCXGgHyD4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-AW4f9IqIOCWV_UvVVcyz8A-1; Mon, 18 Sep 2023 00:11:53 -0400
X-MC-Unique: AW4f9IqIOCWV_UvVVcyz8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E877C85A5BA;
        Mon, 18 Sep 2023 04:11:52 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F058740C6EA8;
        Mon, 18 Sep 2023 04:11:51 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 08/10] ublk: quiesce request queue when aborting queue
Date:   Mon, 18 Sep 2023 12:11:04 +0800
Message-Id: <20230918041106.2134250-9-ming.lei@redhat.com>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/block/ublk_drv.c | 43 ++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 4bc4c4f87b36..3b691bf3d9ef 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1446,21 +1446,45 @@ static void ublk_daemon_monitor_work(struct work_struct *work)
 {
 	struct ublk_device *ub =
 		container_of(work, struct ublk_device, monitor_work.work);
+	struct gendisk *disk;
 	int i;
 
 	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
 		struct ublk_queue *ubq = ublk_get_queue(ub, i);
 
-		if (ubq_daemon_is_dying(ubq)) {
-			if (ublk_queue_can_use_recovery(ubq))
-				schedule_work(&ub->quiesce_work);
-			else
-				schedule_work(&ub->stop_work);
+		if (ubq_daemon_is_dying(ubq))
+			goto found;
+	}
+	return;
+
+found:
+	spin_lock(&ub->lock);
+	disk = ub->ub_disk;
+	if (disk)
+		get_device(disk_to_dev(disk));
+	spin_unlock(&ub->lock);
+
+	/* Our disk has been dead */
+	if (!disk)
+		return;
+
+	/* Now we are serialized with ublk_queue_rq() */
+	blk_mq_quiesce_queue(disk->queue);
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
+		struct ublk_queue *ubq = ublk_get_queue(ub, i);
 
+		if (ubq_daemon_is_dying(ubq)) {
 			/* abort queue is for making forward progress */
 			ublk_abort_queue(ub, ubq);
 		}
 	}
+	blk_mq_unquiesce_queue(disk->queue);
+	put_device(disk_to_dev(disk));
+
+	if (ublk_can_use_recovery(ub))
+		schedule_work(&ub->quiesce_work);
+	else
+		schedule_work(&ub->stop_work);
 
 	/*
 	 * We can't schedule monitor work after ub's state is not UBLK_S_DEV_LIVE.
@@ -1595,6 +1619,8 @@ static void ublk_unquiesce_dev(struct ublk_device *ub)
 
 static void ublk_stop_dev(struct ublk_device *ub)
 {
+	struct gendisk *disk;
+
 	mutex_lock(&ub->mutex);
 	if (ub->dev_info.state == UBLK_S_DEV_DEAD)
 		goto unlock;
@@ -1604,10 +1630,15 @@ static void ublk_stop_dev(struct ublk_device *ub)
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
 	ublk_cancel_dev(ub);
 	mutex_unlock(&ub->mutex);
-- 
2.40.1

