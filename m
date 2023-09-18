Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120BC7A3FF4
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbjIRENc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbjIRENH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:13:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAD512D
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jFn9Cdtk+7JZBpIhDNO+U1L5R3ZpxdukDn8LrFmDXLI=;
        b=hZJZ5F62/YM9k+Mb4fv+4j6yEET8NUk4hOZxYeiZzuRKRGP57+ct5Q4S5l1cESElhsrzFs
        cf5BdFpeXRK3bzl6CzbA2YJL9uZj2HcJ2Ld2R2/3aDhzqFfMQg7vyTNcghr9bpRmWKE4Dy
        q7f9MlUxLXcSodleNutPy9Q2K9X6bqs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-uPS8f0-MMn-QkJx2tfOKyQ-1; Mon, 18 Sep 2023 00:11:49 -0400
X-MC-Unique: uPS8f0-MMn-QkJx2tfOKyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE896185A78E;
        Mon, 18 Sep 2023 04:11:48 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBD9A2156701;
        Mon, 18 Sep 2023 04:11:47 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 07/10] ublk: rename mm_lock as lock
Date:   Mon, 18 Sep 2023 12:11:03 +0800
Message-Id: <20230918041106.2134250-8-ming.lei@redhat.com>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rename the mm_lock field of ublk_device as lock, so that this lock can
be reused for protecting access of ub->ub_disk, which will be used for
simplifying ublk_abort_queue() by quiesce queue in next patch.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 52dd53662ffb..4bc4c4f87b36 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -167,7 +167,7 @@ struct ublk_device {
 
 	struct mutex		mutex;
 
-	spinlock_t		mm_lock;
+	spinlock_t		lock;
 	struct mm_struct	*mm;
 
 	struct ublk_params	params;
@@ -1358,12 +1358,12 @@ static int ublk_ch_mmap(struct file *filp, struct vm_area_struct *vma)
 	unsigned long pfn, end, phys_off = vma->vm_pgoff << PAGE_SHIFT;
 	int q_id, ret = 0;
 
-	spin_lock(&ub->mm_lock);
+	spin_lock(&ub->lock);
 	if (!ub->mm)
 		ub->mm = current->mm;
 	if (current->mm != ub->mm)
 		ret = -EINVAL;
-	spin_unlock(&ub->mm_lock);
+	spin_unlock(&ub->lock);
 
 	if (ret)
 		return ret;
@@ -2348,7 +2348,7 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (!ub)
 		goto out_unlock;
 	mutex_init(&ub->mutex);
-	spin_lock_init(&ub->mm_lock);
+	spin_lock_init(&ub->lock);
 	INIT_WORK(&ub->quiesce_work, ublk_quiesce_work_fn);
 	INIT_WORK(&ub->stop_work, ublk_stop_work_fn);
 	INIT_DELAYED_WORK(&ub->monitor_work, ublk_daemon_monitor_work);
-- 
2.40.1

